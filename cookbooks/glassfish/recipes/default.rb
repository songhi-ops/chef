#
# Cookbook Name:: glassfish
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user node['glassfish']['user'] do
    comment 'GlassFish Application Server'
    home node['glassfish']['base_dir']
    shell '/bin/bash'
    system true
end

ark "glassfish" do
    url 'http://download.java.net/glassfish/3.1.2/release/glassfish-3.1.2.zip'
    path node['glassfish']['base_dir']
    owner node['glassfish']['user']
    group node['glassfish']['group']
    action :put
end

cookbook_file '/etc/init.d/glassfish' do
    owner 'root'
    group 'root'
    mode 0755
    source 'init'
end

cookbook_file '/opt/glassfish/glassfish/domains/domain1/config/domain.xml' do
    owner 'glassfish'
    group 'glassfish'
    mode 0600
    source 'domain.xml'
end

cookbook_file '/opt/glassfish/glassfish/lib/mysql-connector-java-5.1.24-bin.jar' do
    owner 'glassfish'
    group 'glassfish'
    mode 0770
    source 'mysql-connector-java-5.1.24-bin.jar'
end
