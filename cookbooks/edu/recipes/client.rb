package "httpd"
package "php"

user "release" do
    shell "/bin/bash"
end

directory "/data/api" do
    owner "release"
    group "release"
end

git_key = Chef::EncryptedDataBagItem.load("ssh-keys", "chef-server")

file "/root/.ssh/id_rsa" do
    mode 0700
    content git_key['id_rsa']
end

cookbook_file "/root/.ssh/known_hosts" do
    mode 0700
    owner 'root'
    group 'root'
    source "known_hosts"
end

git "/tmp/edu" do
  repository "git@github.com:songhi-ops/edu.git"
  reference "master"
  action :sync
end


file "/root/.ssh/id_rsa" do
  action :delete
end

bash "Copying sounds directory" do
    code <<-EOF
    mv /tmp/edu/songhi-sb/sounds /data/api
    mv /tmp/edu/SongHi/api/* /data/api
    mv /tmp/edu/songhi-jpa/default /etc/httpd/conf.d/default.conf
    EOF
end
