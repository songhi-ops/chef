package "nagios-plugins-all"
package "nrpe"

plugins = [
    "check_api",
    "check_memory",
    "check_nginx",
    "check_mongodb",
    "check_status_url"
]


Chef::Log.warn("HEEEY: #{node[:nagios][:app_name]}")
servers = search(:node, "chef_environment:#{node.environment} AND role:#{node[:nagios][:app_name]}-nagios-server", %w(ipaddress, fqdn))
template "/etc/nagios/nrpe.cfg" do
    source "nrpe.cfg.erb"
    variables({
    'nagios_server' => servers[0]
    })
    notifies :reload, 'service[nrpe]'
end

plugins.each do | plugin |
    cookbook_file "/usr/lib64/nagios/plugins/#{ plugin }" do
        source plugin
        owner 'root'
        group 'root'
        mode 0755
    end
end


if node.run_list.roles.include?("#{node[:nagios][:app_name]}-app") 
    python_pip "requests"
end


service 'nrpe' do
  service_name "nrpe"
  supports :restart => true, :status => true, :reload => true
  action [:start, :enable]
  retries 4
  retry_delay 30
end

