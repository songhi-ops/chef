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


applications = search(:node, "role:magic-app", %w(ipaddress fqdn))
load_balancers = search(:node, "role:magic-load-balancer", %w(ipaddress fqdn))
databases = search(:node, "role:magic-mongodb*", %w(ipaddress fqdn))

template "/etc/munin/munin.conf" do
    source "munin.conf.erb"
    variables({
        "applications" => applications,
        "load_balancers" => load_balancers,
        "databases" => databases
    })
end

bash "restart httpd, munin-node" do
    code <<-EOF
    /etc/init.d/httpd restart
    /etc/init.d/munin-node restart
    EOF
end
