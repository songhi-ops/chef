
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

search(:node, "role:#{node[:songhi][:app_name]}-app", %w(ipaddress fqdn dns_aliases)) do |n|
  hosts[n["ipaddress"]] = n
end

template "/etc/nginx/conf.d/default.conf" do
  source "default.conf.erb"
  mode 0644
  variables(
      :hosts => hosts,
      :http => node["nginx"]["http_port"],
      :https => node["nginx"]["https_port"]
  )
  notifies :reload, 'service[nginx]'
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  mode 0644
  notifies :reload, 'service[nginx]'
end

cookbook_file "/etc/nginx/conf.d/monitoring.conf" do
    source "monitoring.conf"
    owner "root"
    group "root"
    mode 0644
    notifies :reload, 'service[nginx]'
end


cert = Chef::EncryptedDataBagItem.load("certificates", "#{node[:nginx][:certificate]}")

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
  supports :restart => true, :status => true, :reload => true
  action [:start, :enable]
  retries 4
  retry_delay 30
end
