package 'nagios' 
package 'nagios-plugins-all' 
package 'nagios-plugins-nrpe' 
package 'nrpe' 
package 'php' 
package 'httpd'


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
