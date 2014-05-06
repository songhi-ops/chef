#
# Cookbook Name:: mongodb
# Attributes:: default
#
# Copyright 2014, Songhi Entertainment
#
# All rights reserved - Do Not Redistribute

# this option can be "distro" or "10gen"
default[:mongodb][:install_method] = 'distro'
default[:mongodb][:template_cookbook] = 'mongodb'
default[:mongodb][:root_group] = 'root'
default[:mongodb][:configfile_path] = '/etc/'
default[:mongodb][:mongos] = false
default[:mongodb][:configsrv] = false
default[:mongodb][:replica] = false
default[:mongodb][:standalone] = true
default[:mongodb][:shard] = false
default[:mongodb][:config_template] = 'mongod.conf.erb'

#Replica stuff
default[:mongodb][:replica_string] = nil

#Shard stuff
default[:mongodb][:configdb_string] = nil


case node['platform_family']
when 'rhel', 'fedora'
  # determine the package name
  # from http://rpm.pbone.net/index.php3?stat=3&limit=1&srodzaj=3&dl=40&search=mongodb
  # verified for RHEL5,6 Fedora 18,19
  default[:mongodb][:init_dir] = '/etc/init.d'
  default[:mongodb][:package_name] = 'mongodb-org'
  default[:mongodb][:user] = 'mongod'
  default[:mongodb][:group] = 'mongod'
  default[:mongodb][:init_script_template] = 'redhat-mongodb.init.erb'
  default[:mongodb][:instance_name] = 'mongod'
  # then there is this guy
  if node['platform'] == 'centos' || node['platform'] == 'amazon'
    Chef::Log.warn("CentOS doesn't provide mongodb, forcing use of 10gen repo")
    default[:mongodb][:install_method] = '10gen'
    default[:mongodb][:package_name] = 'mongodb-org'
    Chef::Log.info("Installing: #{node['mongodb']['package_name']}")
  end
when 'debian'
  default[:mongodb][:package_name] = 'mongodb'
  default[:mongodb][:template_cookbook] = 'mongodb'
  default[:mongodb][:instance_name] = 'mongodb'
  if node['platform'] == 'ubuntu'
    default[:mongodb][:apt_repo] = 'ubuntu-upstart'
    default[:mongodb][:init_dir] = '/etc/init/'
    default[:mongodb][:init_script_template] = 'debian-mongodb.upstart.erb'
  else
    default[:mongodb][:apt_repo] = 'debian-sysvinit'
  end
else
  Chef::Log.error("Unsupported Platform Family: #{node['platform_family']}")
  fail
end


