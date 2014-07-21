package 'nagios' 
package 'nagios-plugins-all' 
package 'nagios-plugins-nrpe' 
package 'nrpe' 
package 'php' 
package 'httpd'

python_pip "pymongo" do
    action :install
end

cookbook_file "/var/www/html/index.php" do
    owner 'root'
    group 'root'
    source 'index.php'
    mode 0644
end

cookbook_file "/etc/nagios/cgi.cfg" do
    owner 'root'
    group 'root'
    source 'cgi.cfg'
    mode 0664
    notifies :restart, 'service[httpd]'
    notifies :restart, 'service[nagios]'
end

cookbook_file "/etc/nagios/objects/localhost.cfg" do
    owner 'root'
    group 'root'
    source 'localhost.cfg'
    mode 0664
    notifies :restart, 'service[nagios]'
end

cookbook_file "/etc/httpd/conf/httpd.conf" do
    owner 'root'
    group 'root'
    source 'httpd.conf'
    mode 0664
    notifies :restart, 'service[httpd]'
end

cookbook_file "/etc/nagios/passwd" do
    owner 'root'
    group 'root'
    source 'passwd'
    mode 0664
    notifies :restart, 'service[httpd]'
end

plugins = [
    "check_api",
    "check_memory",
    "check_nginx",
    "check_mongodb"
]

plugins.each do | plugin |
    cookbook_file "/usr/lib64/nagios/plugins/#{ plugin }" do
        source plugin
        owner 'root'
        group 'root'
        mode 0755
    end
end

cookbook_file "/etc/nagios/objects/commands.cfg" do
    source "commands.cfg"
end

server_types = [
    [ 'applications', 'role:magic-app' ],
    [ 'load_balancers', 'role:magic-load-balancer' ],
    [ 'data_bases', 'role:magic-mongodb-shard' ],
    [ 'data_bases_config', 'role:magic-mongodb-config' ]
]

server_types.each do | servers | 
    search(:node, servers[1], %w(ipaddress hostname cpu)).each do | server |
    template "/etc/nagios/conf.d/#{server[:hostname]}.cfg" do
            source "#{servers[0]}.cfg.erb"  
            variables ({
                'hostname' => server[:hostname],
                'ipaddress' => server[:ipaddress],
                'cores' => server[:cpu][:total]
            
            })
            notifies :reload, 'service[nagios]'
        end
    end
end





service 'nagios' do
  service_name "nagios"
  supports :restart => true, :status => true, :reload => true
  action [:start, :enable]
  retries 4
  retry_delay 30
end

service 'httpd' do
  service_name "httpd"
  supports :restart => true, :status => true
  action [:start, :enable]
  retries 4
  retry_delay 30
end
