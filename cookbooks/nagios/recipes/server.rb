package 'nagios' 
package 'nagios-plugins-all' 
package 'nagios-plugins-nrpe' 
package 'nrpe' 
package 'php' 
package 'httpd'

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


applications = search(:node, "role:magic-app", %w(ipaddress hostname cpu))
load_balancers = search(:node, "role:magic-load-balancer", %w(ipaddress hostname cpu))
databases = search(:node, "role:magic-mongodb*", %w(ipaddress hostname cpu))



service 'nagios' do
  service_name "nagios"
  supports :restart => true, :status => true
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
