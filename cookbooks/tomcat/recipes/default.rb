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

user "tomcat" do
    action :create
end

ark File.basename("#{node[:tomcat][:home]}") do
    url node['tomcat']['tarball'] 
    path File.dirname("#{node[:tomcat][:home]}")
    action :put
end

bash "Removing applications" do
    code <<-EOF
    rm -rf #{node[:tomcat][:home]}/webapps/*
    EOF
end

#Setting UMASK :
cookbook_file "#{node[:tomcat][:home]}/bin/catalina.sh" do
    owner 'tomcat'
    group 'tomcat'
    source 'catalina.sh'
end

cookbook_file "#{node[:tomcat][:home]}/conf/server.xml" do
    owner 'tomcat'
    group 'tomcat'
    source 'server.xml'
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



service 'tomcat' do
  service_name "tomcat"
  supports :restart => true, :status => true
  action [:start, :enable]
  notifies :run, 'execute[wait for tomcat]', :immediately
  retries 4
  retry_delay 30
end

if node.chef_environment != '_default'
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

