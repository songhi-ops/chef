#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#



include_recipe 'java'
include_recipe 'ark'

package 'redhat-lsb-core'

if node.chef_environment == '_default'
    key = Chef::EncryptedDataBagItem.load("ssh-keys", "chef-server")
    
    file "/root/.ssh/id_rsa" do
        content key['id_rsa']
        owner "root"
        group "root"
        mode 0600
    end
end

user "tomcat" do
    action :create
end

if not File.directory? "#{node[:tomcat][:home]}"
    ark File.basename("#{node[:tomcat][:home]}") do
        url node['tomcat']['tarball'] 
        path File.dirname("#{node[:tomcat][:home]}")
        action :put
    end


end



directory "/logs/tomcat" do
  owner "tomcat"
  group "tomcat"
  mode 00744
  action :create
end


directory "#{node[:tomcat][:log_directory]}/#{node[:songhi][:app_name]}" do
  owner "tomcat"
  group "tomcat"
  mode 00644
  action :create
end

bash 'logs directory permissions' do
    code <<-EOF
    chown  tomcat.tomcat /logs
    chmod  -R 755 /logs
    EOF
end

if !File.symlink?("#{node[:tomcat][:log_directory_old]}") 
    directory "#{node[:tomcat][:log_directory_old]}" do
        action :delete
    end

    link "#{node[:tomcat][:log_directory_old]}" do
        owner 'tomcat'
        group 'tmcat'
        mode 0755
        to "#{node[:tomcat][:log_directory]}/tomcat"
    end
end

link "/var/log/#{node[:songhi][:app_name]}" do
    owner 'tomcat'
    group 'tomcat'
    mode 0755
    to "#{node[:tomcat][:log_directory]}/#{node[:songhi][:app_name]}"
end


bash "Removing applications, catalina.sh and server.xml" do
    code <<-EOF
    rm -rf #{node[:tomcat][:home]}/webapps/*
    EOF
end



link "#{node[:tomcat][:symlink]}" do
    to "#{node[:tomcat][:home]}"
end

link "/usr/sbin/tomcat" do
    to "#{node[:tomcat][:home]}/bin/startup.sh"
end

link "/usr/sbin/tomcat_stop" do
    to "#{node[:tomcat][:home]}/bin/shutdown.sh"
end

#New relic
#cookbook_file "/root/newrelic_agent3.7.2.tar.gz" do
#    source 'newrelic_agent3.7.2.tar.gz'
#end
#
#bash 'unpacking newrelic' do
#    code <<-EOF
#    tar xzvf /root/newrelic_agent3.7.2.tar.gz -C #{node[:tomcat][:home]}
#    EOF
#end

bash "Permissions for /opt/apache... " do
    code <<-EOF
    chown -R tomcat.tomcat #{node[:tomcat][:home]}
    EOF
end

package "tomcat-native" do
    action :install
end

template "/etc/init.d/tomcat" do
  source 'init.erb'
  owner 'root'
  group 'root'
  mode '0755'
end



template "/etc/tomcat.conf" do
    source 'tomcat.conf.erb'
    owner 'tomcat'
    group 'tomcat'
    mode '0664'
    variables ({
    :tomcat_home => "#{node[:tomcat][:home]}"
    })
    notifies :restart, 'service[tomcat]'
end

        
cookbook_file "#{node[:tomcat][:home]}/conf/server.xml" do
    owner 'tomcat'
    group 'tomcat'
    source 'server.xml'
    notifies :restart, 'service[tomcat]'
end

template "#{node[:tomcat][:home]}/bin/catalina.sh" do
    owner 'tomcat'
    group 'tomcat'
    source 'catalina.sh.erb'
    notifies :restart, 'service[tomcat]'
end



service 'tomcat' do
  service_name "tomcat"
  supports :restart => true, :status => true
  action [:start, :enable]
  notifies :run, 'execute[wait for tomcat]', :immediately
  retries 4
  retry_delay 30
end

if node.chef_environment != '_default' and not /_prod_/ =~ node.chef_environment 
    directory "/home/tomcat/.ssh" do
        owner 'tomcat'
        group 'tomcat'
        mode 0700
    end

    template "/home/tomcat/.ssh/authorized_keys" do
        source "authotized_keys_dev.erb"
        owner "tomcat"
        group "tomcat"
        mode 0700
    end

    sudo 'tomcat' do
      user      "tomcat"
      commands  ['/etc/init.d/tomcat restart']
      nopasswd true
    end
end



execute 'wait for tomcat' do
  command 'sleep 5'
  action :nothing
end


#if node.chef_environment == "_default" or /_prod_/ =~ node.chef_environment
#    servers = search(:node, "#{node[:tomcat][:role_stage]}", %w(ipaddress, fqdn))
#    bash "Get the build" do
#        code <<-EOF
#        scp -i /root/id_rsa root@#{servers[0][:ipaddress]}:/opt/tomcat/webapps/#{node[:songhi][:app_name]}-server.war /opt/tomcat/webapps/
#        /etc/init.d/tomcat restart
#        EOF
#    end
#end

case node.chef_environment
when '_dev'
    environment = 'dev'
when '_default'
    environment = 'prod'
when /_production_/
    environment = 'prod'
when '_stage'
    environment = 'stage'
end


template "/usr/bin/songhi-env" do
    source "songhi-env.erb"
    mode 0755
    variables ({
    :env => environment
    })
end
