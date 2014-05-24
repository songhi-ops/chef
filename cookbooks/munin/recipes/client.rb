package 'munin-node'

if node.run_list.roles.include?('magic-app')
    package 'munin-java-plugins'
end

servers = search(:node, "chef_environment:#{node.environment} AND role:magic-munin-server", %w(ipaddress, fqdn))
template "/etc/munin/munin-node.conf" do
    source "munin-node.conf.erb"
    variables({
    'server' => servers[0]
    })
    notifies :restart, 'service[munin-node]'
end

service 'munin-node' do
  service_name "munin-node"
  supports :restart => true, :status => true
  action [:start, :enable]
  retries 4
  retry_delay 30
end

