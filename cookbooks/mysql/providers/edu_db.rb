action :create do
    mysql_credentials = Chef::EncryptedDataBagItem.load("mysql_credentials", "edu_production")
    mysql_root = Chef::EncryptedDataBagItem.load("mysql_credentials", "edu_root_production") 

    package 'expect' do
    end

    template "/etc/my.cnf" do
        owner 'root'
        group 'root'
        source 'my.cnf.erb'
    end

    service 'mysqld' do
        supports :status => true, :restart => true, :reload => true
        action [:enable, :start]
    end

    execute "sleep 10" do
    end

    cookbook_file '/tmp/secure_mysql.sh' do
        source 'secure_mysql.sh'
        mode 0700
        owner 'root'
        group 'root'
    end

    bash "mysql_secure_installation" do
        code <<-EOF
        /tmp/secure_mysql.sh #{mysql_root['password']}
        EOF
        not_if "mysql -uroot -p#{mysql_root['password']} -B"
    end

    bash "Create Database" do
        code <<-EOF
        mysql -p#{mysql_root['password']} -e "CREATE DATABASE IF NOT EXISTS core;"
        EOF
        not_if "[ `mysql -p#{mysql_root['password']} --skip-column-names -B  -ptest -e 'SELECT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '\"'\"'core'\"'\"');'` == 1 ]"
    end
    bash "Create users" do
        code <<-EOF
        mysql -p#{mysql_root['password']} -e "CREATE USER '#{mysql_credentials['user']}'@'localhost' IDENTIFIED BY '#{mysql_credentials['password']}';"
        mysql -p#{mysql_root['password']} -e "CREATE USER '#{mysql_credentials['user']}'@'%' IDENTIFIED BY '#{mysql_credentials['password']}';"
        mysql -p#{mysql_root['password']} -e "GRANT ALL ON core.* TO '#{mysql_credentials['user']}'@'localhost';"
        mysql -p#{mysql_root['password']} -e "GRANT ALL ON core.* TO '#{mysql_credentials['user']}'@'%';"
        mysql -p#{mysql_root['password']} -e "GRANT ALL ON core.* TO '#{mysql_credentials['user']}'@'localhost';"
        mysql -p#{mysql_root['password']} -e "GRANT ALL ON core.* TO '#{mysql_credentials['user']}'@'%';"
        EOF
        not_if "[ `mysql -p#{mysql_root['password']} --skip-column-names -B  -ptest -e 'SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '\"'\"'#{mysql_credentials['user']}'\"'\"');'` == 1 ]"
    end

end

