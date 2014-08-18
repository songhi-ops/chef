action :create do
    mysql_password = 'test'

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
        /tmp/secure_mysql.sh #{mysql_password}
        EOF
        not_if "mysql -p#{mysql_password} -B"
    end

    bash "Create Database" do
        code <<-EOF
        mysql -p#{mysql_password} -e "CREATE DATABASE IF NOT EXISTS core;"
        EOF
        not_if "[ `mysql --skip-column-names -B  -ptest -e 'SELECT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '\"'\"'core'\"'\"');'` == 1 ]"
    end
    bash "Create users" do
        code <<-EOF
        mysql -p#{mysql_password} -e "CREATE USER 'mcuser'@'localhost' IDENTIFIED BY 'mc.pwd';"
        mysql -p#{mysql_password} -e "CREATE USER 'mcuser'@'%' IDENTIFIED BY 'mc.pwd';"
        mysql -p#{mysql_password} -e "GRANT ALL ON core.* TO 'mcuser'@'localhost';"
        mysql -p#{mysql_password} -e "GRANT ALL ON core.* TO 'mcuser'@'%';"
        mysql -p#{mysql_password} -e "GRANT ALL ON core.* TO 'mcuser'@'localhost';"
        mysql -p#{mysql_password} -e "GRANT ALL ON core.* TO 'mcuser'@'%';"
        EOF
        not_if "[ `mysql --skip-column-names -B  -ptest -e 'SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '\"'\"'mcuser'\"'\"');'` == 1 ]"
    end

end

