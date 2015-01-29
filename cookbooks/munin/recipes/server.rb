#
# Cookbook Name:: munin
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "httpd"
package "munin"
package "munin-cgi"


applications = search(:node, "role:#{node[:munin][:app_name]}-app", %w(ipaddress fqdn))
load_balancers = search(:node, "role:#{node[:munin][:app_name]}-load-balancer", %w(ipaddress fqdn))
databases = search(:node, "role:#{node[:munin][:app_name]}-mongodb*", %w(ipaddress fqdn))
redis = search(:node, "role:#{node[:munin][:app_name]}-redis*", %w(ipaddress fqdn))

template "/etc/munin/munin.conf" do
    source "munin.conf.erb"
    variables({
        "applications" => applications,
        "load_balancers" => load_balancers,
        "databases" => databases,
        "redis" => redis
    })
end

template "/etc/httpd/conf/httpd.conf" do
    source "httpd.conf.erb"
    notifies :restart, 'service[httpd]'
end


template "/etc/httpd/conf.d/munin-cgi.conf" do
    source "munin-cgi.conf.erb"
    notifies :restart, 'service[httpd]'
end

template "/etc/httpd/conf.d/munin.conf" do
    source "munin.conf.html.erb"
    notifies :restart, 'service[httpd]'
end

cookbook_file "/etc/munin/munin-htpasswd" do
    source "munin-htpasswd"
    notifies :restart, 'service[httpd]'
end

service 'httpd' do
  service_name "httpd"
  supports :restart => true, :status => true
  action [:start, :enable]
  retries 4
  retry_delay 30
end

service 'munin-node' do
  service_name "munin-node"
  supports :restart => true, :status => true
  action [:start, :enable]
  retries 4
  retry_delay 30
end

