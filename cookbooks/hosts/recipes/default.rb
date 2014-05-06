#
# Cookbook Name:: hosts
# Recipe:: default
#
# Copyright 2009, Bitfluent
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

hosts     = {}

search(:node, "*:*", %w(ipaddress fqdn dns_aliases)) do |n|
  hosts[n["ipaddress"]] = n
end

template "/etc/hosts" do
  source "hosts.erb"
  mode 0644
  variables(:hosts => hosts)
end
