#
#
# Cookbook Name:: mongodb:install
# Recipe:: install
#
# Copyright 2014, Songhi Entertainment
#
# All rights reserved - Do Not Redistribute
#

# install the 10gen repo if necessary
include_recipe 'mongodb::10gen_repo' if node['mongodb']['install_method'] == '10gen'


roles = [
    ["mongos", "mongos"],
    ["replica", "mongod"],
    ["configsrv", "mongo-config"],
    ["standalone", "mongod"]
]

roles.each do |role,file|

    if node['mongodb']["#{role}"]

        ## init_file = /etc/init.d/mongo-something
        if node['mongodb']['apt_repo'] == 'ubuntu-upstart'
          init_file = File.join(node['mongodb']['init_dir'], "#{file}.conf")
          mode = '0644'
        else
          init_file = File.join(node['mongodb']['init_dir'], "#{file}")
          mode = '0755'
        end

        ## config_file = /data/mongo-something
        config_file = File.join(node['mongodb']['configfile_path'], "#{file}.conf")
        config_physical_file = File.join(node['mongodb']['configfile_physical_path'], "#{file}.conf")


        # Specific config settings according to role
        case role
        when  'mongos'
            node.override['mongodb']['config']['logpath'] = '/data/log/mongodb/mongos.log'
            node.override['mongodb']['config']['pidfilepath'] = '/var/run/mongodb/mongos.pid'
            node.override['mongodb']['config']['dbpath'] = nil
            node.override['mongodb']['config']['configdb'] = node['mongodb']['configdb_string']
            node.override['mongodb']['config']['configsvr'] = nil
            node.override['mongodb']['config']['replSet'] = nil
            node.override['mongodb']['config']['shardsvr'] = nil
            node.override['mongodb']['package_name'] = ['mongodb-org-mongos', 'mongodb-org-shell']
        when  'configsrv'
            node.override['mongodb']['config']['logpath'] = '/data/log/mongodb/mongo-config.log'
            node.override['mongodb']['config']['pidfilepath'] = '/var/run/mongodb/mongo-config.pid'
            node.override['mongodb']['config']['dbpath'] = '/data/lib/mongo-config'
            node.override['mongodb']['config']['configdb'] = nil
            node.override['mongodb']['config']['configsvr'] = 'true'
            node.override['mongodb']['config']['replSet'] = nil
            node.override['mongodb']['config']['shardsvr'] = nil
        when  'replica'
            node.override['mongodb']['config']['logpath'] = '/data/log/mongodb/mongod.log'
            node.override['mongodb']['config']['pidfilepath'] = '/var/run/mongodb/mongod.pid'
            node.override['mongodb']['config']['dbpath'] = '/data/lib/mongo'
            node.override['mongodb']['config']['configdb'] = nil
            node.override['mongodb']['config']['configsvr'] = nil
            node.override['mongodb']['config']['replSet'] = node['mongodb']['replica_string']
            if node['mongodb']['shard']
                node.override['mongodb']['config']['shardsvr'] = 'true'
            end
        when  'standalone'
            node.override['mongodb']['config']['logpath'] = '/data/log/mongodb/mongod.log'
            node.override['mongodb']['config']['pidfilepath'] = '/var/run/mongodb/mongod.pid'
            node.override['mongodb']['config']['dbpath'] = '/data/lib/mongodb'
            node.override['mongodb']['config']['configdb'] = nil
            node.override['mongodb']['config']['configsvr'] = nil
            node.override['mongodb']['config']['replSet'] = nil
            node.override['mongodb']['config']['shardsvr'] = nil
        end
        
        

        # Create /etc/init.d/mongo
        if role != 'mongos'

            template init_file do
              cookbook node['mongodb']['template_cookbook']
              source node['mongodb']['init_script_template']
              group node['mongodb']['root_group']
              owner 'root'
              mode mode
              variables(
                :provides => 'mongod',
                :configfile => config_file,
                :ulimit => node['mongodb']['ulimit'],
                :lock => file
              )
              action :create_if_missing
            end
        else
            cookbook_file init_file do
                owner 'root'
                group 'root'
                mode mode
                source 'mongos'
                action :create_if_missing
            end

            directory "/data" do
                action :create
            end

        end

        # Create /etc/mongo


        #Chef::Log.info ("#{role}: #{node['mongodb']['config']['dbpath']}")
        template config_physical_file do
          cookbook node['mongodb']['template_cookbook']
          source node['mongodb']['config_template']
          group node['mongodb']['root_group']
          owner 'root'
          mode mode
          variables(
            :config => node['mongodb']['config']
          )
          action :create_if_missing
        end

        link config_file do
            to config_physical_file
            group node['mongodb']['root_group']
            owner 'root'
        end


        # Create DB  and log directory

        unless ::File.directory?("#{node['mongodb']['config']['dbpath']}") or node['mongodb']['config']['dbpath'].nil?
                directory node['mongodb']['config']['dbpath'] do
                  owner 'mongod'
                  group 'mongod'
                  mode '0755'
                  recursive true
                  action :create
                end
        end


        unless ::File.directory?(File.dirname("#{node['mongodb']['config']['logpath']}"))
                directory File.dirname(node['mongodb']['config']['logpath']) do
                  owner 'mongod'
                  group 'mongod'
                  mode '0755'
                  recursive true
                  action :create
                end
        end

        # Set Selinnux context

        bash "Selinux context config file #{config_file}" do
            user 'root'
            code <<-EOH
            chcon system_u:object_r:etc_t:s0 #{config_file}
            EOH
        end

        unless node['mongodb']['config']['dbpath'].nil?
            bash 'selinux context dbpath' do
                user 'root'
                code <<-EOF
                chcon system_u:object_r:var_lib_t:s0 #{node['mongodb']['config']['dbpath']}
                EOF
            end
        end

        # Create initialization scripts (meant to be run manually
        if role == 'replica'
            array="#{node['mongodb']['config']['replSet']}".split("/").last.split(",")
            template "/tmp/initialize-replica.js" do
                cookbook node['mongodb']['template_cookbook']
                source 'initialize-replica.js.erb'
                group 'root'
                owner 'root'
                mode 600
                variables(
                    :array => array
                )
                action :create
            end
        end

        
        #Chef::Log.warn("AQUI: #{node['mongodb']['mongos']}")
        if node['mongodb']['mongos']
            shard="#{node['mongodb']['replica_string']}".split(",").first
            name="#{node['mongodb']['replica_string']}".split("/").first
            #name=shard.split("/").first
            template "/tmp/initialize-shard.js" do
                cookbook node['mongodb']['template_cookbook']
                source 'initialize-shard.js.erb'
                group 'root'
                owner 'root'
                mode 600
                variables(
                    :shard => shard,
                    :name => name
                )
                action :create
            end
        end


        Chef::Log.warn("AQUI: #{role}")
        if role == 'mongos'
            user "mongod" do
                action :create
            end

            directory "/var/run/mongodb" do
                owner "mongod"
                group "mongod"
                action :create
            end
        end
    end
end

# Yum options
case node['platform_family']
when 'debian'
  # this options lets us bypass complaint of pre-existing init file
  # necessary until upstream fixes ENABLE_MONGOD/DB flag
  packager_opts = '-o Dpkg::Options::="--force-confold"'
when 'rhel'
  # Add --nogpgcheck option when package is signed
  # see: https://jira.mongodb.org/browse/SERVER-8770
  packager_opts = '--nogpgcheck'
else
  packager_opts = ''
end

# Nedded to download package
package "yum-utils" do
  action :install
end


for package_name in node[:mongodb][:package_name] do
    bash "Download package" do
        code <<-EOF
        ls /data/packages
        if [ "$?" != "0" ]
        then
            mkdir -R /data/packages
            yumdownloader --resolve --destdir /data/packages #{package_name} 
        fi
        EOF
    end
end


# Install


for package_name in node[:mongodb][:package_name] do
    package package_name do
      options packager_opts
      action :install
      version node[:mongodb][:package_version]
    end
end

# mongod user doesnt exists at the moment of creating the directories


bash 'change ownership directories' do
        user "root"
        code <<-EOH
                chown mongod.mongod -R /data
        EOH
end

#Enable services:
#
roles.each do |role,file|
    if node['mongodb']["#{role}"]
        ## init_file = /etc/init.d/mongo-something
        if node['mongodb']['apt_repo'] == 'ubuntu-upstart'
          init_file = File.join(node['mongodb']['init_dir'], "#{file}.conf")
        else
          init_file = File.join(node['mongodb']['init_dir'], "#{file}")
        end

        bash 'chkconfig' do
            code <<-EOF
            chkconfig #{file} on
            EOF
        end
    end
end




bash 'stop iptables and disable selinux' do
    user "root"
    code <<-EOH
        echo 0 > /selinux/enforce
    EOH
end

#Needed to freeze file system and do backup
package "xfsprogs" do
  action :install
end

