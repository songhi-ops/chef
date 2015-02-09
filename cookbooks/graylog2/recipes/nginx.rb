
if node.chef_environment == '_default' or /_production_/ =~ node.chef_environment
    cookbook_file "rsyslog.conf" do
        path "/etc/rsyslog.conf"
        action :create
        notifies :restart, "service[rsyslog]"
    end
    
    cookbook_file "nginx.conf" do
        path "/etc/rsyslog.d/nginx.conf"
        action :create
        notifies :restart, "service[rsyslog]"
    end
    
    service "rsyslog" do
          supports :status => true, :restart => true, :reload => true
            action [ :enable, :start ]
    end
end

