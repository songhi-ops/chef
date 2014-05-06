
template "/etc/motd"  do
  cookbook node['operations']['template_cookbook']
  source 'motd.erb'
  group 'root'
  owner 'root'
  mode 0755
  variables(
  )
  action :create
end
