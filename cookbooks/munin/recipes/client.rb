package 'munin-node'

if node.run_list.roles.include?("#{node[:munin][:app_name]}-app")
    package 'munin-java-plugins'
end

servers = search(:node, "chef_environment:#{node.environment} AND role:#{node[:munin][:app_name]}-munin-server", %w(ipaddress, fqdn))
template "/etc/munin/munin-node.conf" do
    source "munin-node.conf.erb"
    variables({
    'server' => servers[0]
    })
    notifies :restart, 'service[munin-node]'
end

if node.recipes.include? 'nginx'

    link '/etc/munin/plugins/nginx_request' do 
        to '/usr/share/munin/plugins/nginx_request'
    end

    link '/etc/munin/plugins/nginx_status' do
        to '/usr/share/munin/plugins/nginx_status'
    end

    cookbook_file "/etc/munin/plugin-conf.d/nginx" do
        owner "root"
        group "root"
        source "nginx"
        mode 0644
        notifies :restart, 'service[munin-node]'
    end
end

if node.recipes.include? 'redisio'
    gem_package 'redis' do
        action :install
    end

    for plugin in ['redis_changes_since_last_save_', "redis_commands_", "redis_connections_","redis_databases_","redis_memory_","redis_users_", "resque_failed_","resque_queues_", "resque_workers_"]
        cookbook_file "/usr/share/munin/plugins/#{plugin}" do
            owner "root"
            group "root"
            source "#{plugin}"
            mode 0755
        end


        link "/etc/munin/plugins/#{plugin}" do
            to "/usr/share/munin/plugins/#{plugin}"
            notifies :restart, 'service[munin-node]'
        end

    end

    
    
end


service 'munin-node' do
  service_name "munin-node"
  supports :restart => true, :status => true
  action [:start, :enable]
  retries 4
  retry_delay 30
end


if node.run_list.roles.include?("#{node[:munin][:app_name]}-mongodb-shard") or node.run_list.roles.include?("#{node[:munin][:app_name]}-mongodb-config") or node.run_list.roles.include?("#{node[:munin][:app_name]}-mongodb-replica")
    if node.run_list.roles.include?("#{node[:munin][:app_name]}-mongodb-shard") or node.run_list.roles.include?("#{node[:munin][:app_name]}-mongodb-replica")
        port_api = '28018'
    else
        port_api = '28019'
    end
    for plugin in ['mongo_btree', 'mongo_lock', 'mongo_ops', 'mongo_conn', 'mongo_mem']
        template "/usr/share/munin/plugins/#{plugin}" do
            source "#{plugin}.erb"
            mode 0755
            variables({
            'port' => port_api
            })
        end

        link "/etc/munin/plugins/#{plugin}" do
            to "/usr/share/munin/plugins/#{plugin}"
            notifies :restart, 'service[munin-node]'
        end

    end
end

if node.run_list.roles.include?("#{node[:munin][:app_name]}-load-balancer")
    python_pip "requests"

    cookbook_file "/usr/share/munin/plugins/response_time" do
        owner "root"
        group "root"
        source "response_time"
        mode 0755
    end
    
    link '/etc/munin/plugins/response_time' do
        to '/usr/share/munin/plugins/response_time'
        notifies :restart, 'service[munin-node]'
    end
end

