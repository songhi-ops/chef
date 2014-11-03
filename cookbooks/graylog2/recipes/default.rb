#
# Cookbook Name:: graylog2
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Create apps directory

include_recipe 'java'
include_recipe 'mongodb'

service "mongod" do
      supports :status => true, :restart => true, :reload => true
        action [ :enable, :start ]
end

directory "#{node['graylog2']['app_root']}/sources" do
    recursive true
end

#remote_file "#{node['graylog2']['app_root']}/sources/graylog2-server-0.20.1.tgz" do
#    source "http://packages.graylog2.org/releases/graylog2-server/graylog2-server-0.91.1.tgz"
##    source "https://github.com/Graylog2/graylog2-server/releases/download/0.20.1/graylog2-server-0.20.1.tgz"
#end
#
#
#remote_file "#{node['graylog2']['app_root']}/sources/graylog2-web-interface-0.20.1.tgz" do
#    source "http://packages.graylog2.org/releases/graylog2-web-interface/graylog2-web-interface-0.91.1.tgz"
##    source "https://github.com/Graylog2/graylog2-web-interface/releases/download/0.20.1/graylog2-web-interface-0.20.1.tgz"
#end

#package "pwgen" do
#    action :install
#end

# Install Elastic search 

remote_file "#{Chef::Config[:file_cache_path]}/elasticsearch-1.3.4.noarch.rpm" do
#    source "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.10.noarch.rpm"
    source "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.4.noarch.rpm"
    action :create
end

rpm_package "elasticsearch-0.90.10" do
    source "#{Chef::Config[:file_cache_path]}/elasticsearch-1.3.4.noarch.rpm"
    action :install
end

cookbook_file "elasticsearch.yml" do
      path "/etc/elasticsearch/elasticsearch.yml"
      action :create
end

service "elasticsearch" do
      supports :status => true, :restart => true, :reload => true
        action [ :enable, :start ]
end

# Install Graylog server

ark "graylog2-server" do
    action :put
    url "http://packages.graylog2.org/releases/graylog2-server/graylog2-server-0.91.1.tgz"
#    url "https://github.com/Graylog2/graylog2-server/releases/download/0.20.1/graylog2-server-0.20.1.tgz"
    path "/opt"
end

link "#{node['graylog2']['app_root']}/graylog2-server" do
    to "#{node['graylog2']['app_root']}/graylog2-server-0.20.1"
end


cookbook_file "graylog2.conf" do
    path "/etc/graylog2.conf"
    action :create
end

cookbook_file "graylog2-server" do
    path "/etc/init.d/graylog2-server"
    mode 0744
    action :create
end

service "graylog2-server" do
      supports :status => true, :restart => true, :reload => true
        action [ :enable, :start ]
end

# Install Graylog web interface

ark "graylog2-web-interface" do
    action :put
    url "http://packages.graylog2.org/releases/graylog2-web-interface/graylog2-web-interface-0.91.1.tgz"
    #url "https://github.com/Graylog2/graylog2-web-interface/releases/download/0.20.1/graylog2-web-interface-0.20.1.tgz"
    path "/opt"
end

link "#{node['graylog2']['app_root']}/graylog2-web-interface" do
    to "#{node['graylog2']['app_root']}/graylog2-web-interface-0.20.1"
end


cookbook_file "graylog2-web-interface.conf" do
    path "/opt/graylog2-web-interface/conf/graylog2-web-interface.conf"
    action :create
end

cookbook_file "graylog2-web" do
    path "/etc/init.d/graylog2-web"
    mode 0744
    action :create
end

service "graylog2-web" do
      supports :status => true, :restart => true, :reload => true
        action [ :enable, :start ]
end
