package "nagios-plugins-all"
package "nrpe"

plugins = [
    "check_api",
    "check_database_pgsql",
    "check_elasticsearch",
    "check_error_log",
    "check_exit_status",
    "check_haproxy",
    "check_kannel",
    "check_memcached",
    "check_memory",
    "check_mountpoints",
    "check_nginx",
    "check_pg_streaming_replication",
    "check_redis",
    "check_tunnel",
    "check_varnishbackends"
]


servers = search(:node, "chef_environment:#{node.environment} AND role:magic-nagios-server", %w(ipaddress, fqdn))
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

service 'nrpe' do
  service_name "nrpe"
  supports :restart => true, :status => true, :reload => true
  action [:start, :enable]
  retries 4
  retry_delay 30
end
