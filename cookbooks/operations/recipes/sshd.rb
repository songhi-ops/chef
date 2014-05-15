template "/etc/ssh/sshd_config" do
    source "sshd_config.erb"
    action :create
end

bash "Reload SSH" do
    code <<-EOF
    /etc/init.d/sshd reload
    EOF
end
