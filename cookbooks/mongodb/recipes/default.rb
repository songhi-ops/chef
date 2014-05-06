#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2014, Songhi Entertainment
#
# All rights reserved - Do Not Redistribute
#


unless node['mongodb']['mongos'] or node['mongodb']['configsrv'] or node['mongodb']['replica'] or node['mongodb']['standalone']
    Chef::Log.error("No role chosen")
    return
end

if node['mongodb']['mongos'] and node['mongodb']['standalone']
    Chef::Log.error("Server can't act as stand-alone and mongos")
    return
end

if node['mongodb']['mongos'] and node['mongodb']['configdb_string'].nil?
    Chef::Log.error("Mongos but no configdb string provided")
    return
end

if node['mongodb']['replica'] and node['mongodb']['replica_string'].nil?
    Chef::Log.error("Replica but no replica string provided")
    return
end


include_recipe 'mongodb::install'


 #mongodb_instance node['mongodb']['instance_name'] do
 #  bind_ip      node['mongodb']['config']['bind_ip']
 #  logpath      node['mongodb']['config']['logpath']
 #  dbpath       node['mongodb']['config']['dbpath']
 #  enable_rest  node['mongodb']['config']['rest']
 #  smallfiles   node['mongodb']['config']['smallfiles']
 #end
