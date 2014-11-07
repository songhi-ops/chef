cookbook_file "dev-musiccity.cfg" do
    path "/etc/nagios/conf.d/dev-musiccity.cfg"
    action :create
end

bash "reload nagios" do
    code <<-EOF
    /etc/init.d/nagios reload
    EOF
end


