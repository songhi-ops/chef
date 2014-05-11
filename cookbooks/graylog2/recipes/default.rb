#
# Cookbook Name:: graylog2
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Create apps directory

include_recipe 'elasticsearch'
include_recipe 'java'
include_recipe 'mongodb'

directory "#{node['graylog2']['app_root']}/sources" do
    recursive true
    action :create
end

remote_file "#{node['graylog2']['app_root']}/sources/graylog2-server-0.20.1.tgz" do
    source "https://github.com/Graylog2/graylog2-server/releases/download/0.20.1/graylog2-server-0.20.1.tgz"
end


remote_file "#{node['graylog2']['app_root']}/sources/graylog2-web-interface-0.20.1.tgz" do
    source "https://github.com/Graylog2/graylog2-web-interface/releases/download/0.20.1/graylog2-web-interface-0.20.1.tgz"
end

package "pwgen" do
    action :install
end

