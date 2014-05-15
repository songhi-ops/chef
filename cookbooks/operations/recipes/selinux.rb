# Desable SELINUX


bash "Disable SELINUX" do
    code <<-EOF
    echo 0 > /selinux/enforce
    EOF
end

template "/etc/sysconfig/selinux" do
    source "selinux.erb"
    action :create
end

