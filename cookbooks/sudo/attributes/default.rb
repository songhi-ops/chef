#
# Cookbook Name:: sudo
# Attribute File:: default
#
# Copyright 2008-2013, Opscode, Inc.
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

default['authorization']['sudo']['groups']            = ['sysadmins']
default['authorization']['sudo']['users']             = []
default['authorization']['sudo']['passwordless']      = false
default['authorization']['sudo']['include_sudoers_d'] = true
default['authorization']['sudo']['agent_forwarding']  = false
default['authorization']['sudo']['sudoers_defaults']  = ['!lecture,tty_tickets,!fqdn']

case node['platform_family']
when 'smartos'
  default['authorization']['sudo']['prefix'] = '/opt/local/etc'
when 'freebsd'
  default['authorization']['sudo']['prefix'] = '/usr/local/etc'
else
  default['authorization']['sudo']['prefix'] = '/etc'
end
