
chef_gem "chef-vault"
require "chef-vault"

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




vault_certificates = ChefVault::Item.load("certificates", "selfsigned-dev")

file "/etc/ssl/certs/server.key" do
    content vault_certificates['selfsigned-dev']
    owner "root"
    group "root"
    mode 0644
end
