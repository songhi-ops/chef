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
package "munin-core" 
package "munin-plugins"

template "/etc/httpd/conf.d/munin.conf" do
    owner "root"
    group "root"
    mode 0644
    source "munin.conf.erb"
end
