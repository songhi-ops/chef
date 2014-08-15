action :create do

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
        /tmp/secure_mysql.sh test
        EOF
        not_if "mysql -ptest -B"
    end

end

