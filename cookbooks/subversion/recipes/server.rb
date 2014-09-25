#
# Author:: Daniel DeLeo <dan@kallistec.com>
# Cookbook Name:: subversion
# Recipe:: server
#
# Copyright 2009, Daniel DeLeo
# Copyright 2013, Opscode
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

include_recipe 'apache2::mod_dav'
include_recipe 'apache2::mod_dav_svn'
include_recipe 'subversion::client'

directory node['subversion']['repo_dir'] do
  owner     node['apache']['user']
  group     node['apache']['user']
  mode      '0755'
  recursive true
end

web_app 'subversion' do
  template    'subversion.conf.erb'
  server_name "#{node['subversion']['server_name']}.#{node['domain']}"
  notifies    'restart[apache2]'
end


file "#{node['subversion']['repo_dir']}/htpasswd" do
    action :delete
end

execute 'create htpasswd file' do
    command "htpasswd -scb #{node['subversion']['repo_dir']}/htpasswd test test"
end

repo_list = []
search(:svn_repos, "*:*", %w(id)).each do |encrypted|
    repo = Chef::EncryptedDataBagItem.load("svn_repos", encrypted['id'])
    repo_list << [repo['id'],repo['users']]

    group "svn_#{repo['id']}" do
      action :create
    end

    execute 'svnadmin create repo' do
      command "svnadmin create #{node['subversion']['repo_dir']}/#{repo['id']}"
      user    node['apache']['user']
      group   "svn_#{repo['id']}"
      not_if "[ -d '#{node['subversion']['repo_dir']}/#{repo['id']}' ]"
    end

    bash "Setting permissions to repo directory..." do
        code <<-EOF
        chmod -R 0770 #{node['subversion']['repo_dir']}/#{repo['id']}
        EOF
    end

    Chef::Log.warn("HEEEEEEY: svn_#{repo['id']}")
    users_manage "svn_#{repo['id']}" do
      action [ :remove, :create ]
    end
    

    repo['users'].each do |user|
        execute 'create htpasswd file' do
            command "htpasswd -sb #{node['subversion']['repo_dir']}/htpasswd #{user['username']} #{user['password']}"
        end
    end

end


template "#{node['subversion']['repo_dir']}/svn-access-file" do
    source "svn-access-file.erb"
    owner "root"
    group "root"
    mode 0644
    variables ({
        :repo_list => repo_list 
    })
end

execute 'create htpasswd file' do
    command "htpasswd -D #{node['subversion']['repo_dir']}/htpasswd test"
end



