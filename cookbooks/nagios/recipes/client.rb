

package "nagios-plugins-all"
package "nrpe"

plugins = [
    "check_api",
    "check_memory",
    "check_nginx",
    "check_mongodb",
    "check_redis"
]

application = "#{node[:songhi][:app_name]}"

servers = search(:node, "chef_environment:#{node.environment} AND role:#{node[:songhi][:app_name]}-nagios-server", %w(ipaddress, fqdn))
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




######
#
if node.run_list.roles.include?("#{node[:songhi][:app_name]}-app") 
    python_pip "requests"
    template "/usr/lib64/nagios/plugins/check_status_url" do
            source "check_status_url.erb"  
            variables ({
                'status_url' => "#{node[:nagios][:status_url]}"
            
            })
            notifies :reload, 'service[nrpe]'
    end
end


if node.run_list.roles.include?("#{node[:songhi][:app_name]}-redis-master") or node.run_list.roles.include?("#{node[:songhi][:app_name]}-redis-slave")

    include_recipe 'cpan::bootstrap'

    # SAD NOTE: you must install manually Bundle::CPAN (so comment out the lines bellow, also: 
    # ExtUtils::MakeMaker because-> sudo: sorry, you must have a tty to run sudo
    # Test::More because-> sudo: sorry, you must have a tty to run sudo
    # App::cpanminus
    # Redis

    #cpan_client 'Bundle::CPAN' do
    #    action 'install'
    #    install_type 'cpan_module'
    #end

    #cpan_client 'Redis' do
    #    action 'install'
    #    install_type 'cpan_module'
    #end


end

service 'nrpe' do
  service_name "nrpe"
  supports :restart => true, :status => true, :reload => true
  action [:start, :enable]
  retries 4
  retry_delay 30
end

