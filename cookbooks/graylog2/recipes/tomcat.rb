
if node.chef_environment == '_default'
    cookbook_file "rsyslog.conf" do
        path "/etc/rsyslog.conf"
        action :create
        notifies :restart, "service[rsyslog]"
    end
    
    cookbook_file "tomcat.conf" do
        path "/etc/rsyslog.d/tomcat.conf"
        action :create
        notifies :restart, "service[rsyslog]"
    end
    
    service "rsyslog" do
          supports :status => true, :restart => true, :reload => true
            action [ :enable, :start ]
    end
end

