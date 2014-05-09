
template "/etc/yum.repos.d/nginx.repo" do
  source "nginx.repo.erb"
  action :create # see actions section below
end

# Install
package "nginx" do
  options '--nogpgcheck'
  action :install
end

hosts     = {}

search(:node, "role:magic-app", %w(ipaddress fqdn dns_aliases)) do |n|
  hosts[n["ipaddress"]] = n
end

template "/etc/nginx/conf.d/default.conf" do
  source "default.conf.erb"
  mode 0644
  variables(:hosts => hosts)
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  mode 0644
end




cert = Chef::EncryptedDataBagItem.load("certificates", "selfsigned-dev")

file "/etc/pki/tls/private/server.key" do
    content cert['key']
    owner "root"
    group "root"
    mode 0644
end

file "/etc/pki/tls/certs/server.crt" do
    content cert['cert']
    owner "root"
    group "root"
    mode 0644
end


include_recipe 'hosts'

service 'nginx' do
  service_name "nginx"
  supports :restart => true, :status => true
  action [:start, :enable]
  retries 4
  retry_delay 30
end
