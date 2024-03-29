#
# Cookbook Name:: tomcat
# Attributes:: default
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

## HACK !!
#In centos epel repo package is called tomcat. So leaving base_verison empty
#
#default['tomcat']['base_version'] = ''
#default['tomcat']['port'] = 8080
#default['tomcat']['proxy_port'] = nil
#default['tomcat']['ssl_port'] = 8443
#default['tomcat']['ssl_proxy_port'] = nil
#default['tomcat']['ajp_port'] = 8009
#default['tomcat']['catalina_options'] = ''
#default['tomcat']['java_options'] = '-Xmx128M -Djava.awt.headless=true'
#default['tomcat']['use_security_manager'] = false
#default['tomcat']['authbind'] = 'no'
#default['tomcat']['deploy_manager_apps'] = false
#default['tomcat']['ssl_max_threads'] = 150
#default['tomcat']['ssl_cert_file'] = nil
#default['tomcat']['ssl_key_file'] = nil
#default['tomcat']['ssl_chain_files'] = []
#default['tomcat']['keystore_file'] = 'keystore.jks'
#default['tomcat']['keystore_type'] = 'jks'
#
## The keystore and truststore passwords will be generated by the
## openssl cookbook's secure_password method in the recipe if they are
## not otherwise set. Do not hardcode passwords in the cookbook.
## default["tomcat"]["keystore_password"] = nil
## default["tomcat"]["truststore_password"] = nil
#default['tomcat']['truststore_file'] = nil
#default['tomcat']['truststore_type'] = 'jks'
#default['tomcat']['certificate_dn'] = 'cn=localhost'
#default['tomcat']['loglevel'] = 'INFO'
#default['tomcat']['tomcat_auth'] = 'true'
#
#case node['platform']
#
#when 'centos', 'redhat', 'fedora', 'amazon', 'scientific', 'oracle'
#  default['tomcat']['user'] = 'tomcat'
#  default['tomcat']['group'] = 'tomcat'
#  default['tomcat']['home'] = "/usr/share/tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['base'] = "/usr/share/tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['config_dir'] = "/etc/tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['log_dir'] = "/var/log/tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['tmp_dir'] = "/var/cache/tomcat#{node["tomcat"]["base_version"]}/temp"
#  default['tomcat']['work_dir'] = "/var/cache/tomcat#{node["tomcat"]["base_version"]}/work"
#  default['tomcat']['context_dir'] = "#{node["tomcat"]["config_dir"]}/Catalina/localhost"
#  default['tomcat']['webapp_dir'] = "/var/lib/tomcat#{node["tomcat"]["base_version"]}/webapps"
#  default['tomcat']['keytool'] = 'keytool'
#  default['tomcat']['lib_dir'] = "#{node["tomcat"]["home"]}/lib"
#  default['tomcat']['endorsed_dir'] = "#{node["tomcat"]["lib_dir"]}/endorsed"
#when 'debian', 'ubuntu'
#  default['tomcat']['user'] = "tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['group'] = "tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['home'] = "/usr/share/tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['base'] = "/var/lib/tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['config_dir'] = "/etc/tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['log_dir'] = "/var/log/tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['tmp_dir'] = "/tmp/tomcat#{node["tomcat"]["base_version"]}-tmp"
#  default['tomcat']['work_dir'] = "/var/cache/tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['context_dir'] = "#{node["tomcat"]["config_dir"]}/Catalina/localhost"
#  default['tomcat']['webapp_dir'] = "/var/lib/tomcat#{node["tomcat"]["base_version"]}/webapps"
#  default['tomcat']['keytool'] = 'keytool'
#  default['tomcat']['lib_dir'] = "#{node["tomcat"]["home"]}/lib"
#  default['tomcat']['endorsed_dir'] = "#{node["tomcat"]["lib_dir"]}/endorsed"
#when 'smartos'
#  default['tomcat']['user'] = 'tomcat'
#  default['tomcat']['group'] = 'tomcat'
#  default['tomcat']['home'] = '/opt/local/share/tomcat'
#  default['tomcat']['base'] = '/opt/local/share/tomcat'
#  default['tomcat']['config_dir'] = '/opt/local/share/tomcat/conf'
#  default['tomcat']['log_dir'] = '/opt/local/share/tomcat/logs'
#  default['tomcat']['tmp_dir'] = '/opt/local/share/tomcat/temp'
#  default['tomcat']['work_dir'] = '/opt/local/share/tomcat/work'
#  default['tomcat']['context_dir'] = "#{node["tomcat"]["config_dir"]}/Catalina/localhost"
#  default['tomcat']['webapp_dir'] = '/opt/local/share/tomcat/webapps'
#  default['tomcat']['keytool'] = '/opt/local/bin/keytool'
#  default['tomcat']['lib_dir'] = "#{node["tomcat"]["home"]}/lib"
#  default['tomcat']['endorsed_dir'] = "#{node["tomcat"]["home"]}/lib/endorsed"
#else
#  default['tomcat']['user'] = "tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['group'] = "tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['home'] = "/usr/share/tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['base'] = "/var/lib/tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['config_dir'] = "/etc/tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['log_dir'] = "/var/log/tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['tmp_dir'] = "/tmp/tomcat#{node["tomcat"]["base_version"]}-tmp"
#  default['tomcat']['work_dir'] = "/var/cache/tomcat#{node["tomcat"]["base_version"]}"
#  default['tomcat']['context_dir'] = "#{node["tomcat"]["config_dir"]}/Catalina/localhost"
#  default['tomcat']['webapp_dir'] = "/var/lib/tomcat#{node["tomcat"]["base_version"]}/webapps"
#  default['tomcat']['keytool'] = 'keytool'
#  default['tomcat']['lib_dir'] = "#{node["tomcat"]["home"]}/lib"
#  default['tomcat']['endorsed_dir'] = "#{node["tomcat"]["lib_dir"]}/endorsed"
#end
