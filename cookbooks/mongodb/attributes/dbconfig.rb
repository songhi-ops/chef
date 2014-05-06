# All the configuration files that can be dumped
# the attribute-based-configuration
# dump anything into default['mongodb']['config'][<setting>] = <value>
# these options are in the order of mongodb docs

include_attribute 'mongodb::default'

case node['platform_family']
when 'rhel', 'fedora'
  default['mongodb']['config']['fork'] = true
else
  default['mongodb']['config']['fork'] = false
end



default['mongodb']['config']['bind_ip'] = '0.0.0.0'
default['mongodb']['config']['logpath'] = '/var/log/mongodb/mongodb.log'
default['mongodb']['config']['logappend'] = true
default['mongodb']['config']['pidfilepath'] = nil
default['mongodb']['config']['dbpath'] = nil
default['mongodb']['config']['nojournal'] = nil
default['mongodb']['config']['rest'] = nil
default['mongodb']['config']['smallfiles'] = nil
default['mongodb']['config']['oplogSize'] = nil
default['mongodb']['config']['replSet'] = nil
default['mongodb']['config']['shardsvr'] = nil
default['mongodb']['config']['configsvr'] = nil
default['mongodb']['config']['configdb'] = nil



#default['mongodb']['config']['keyFile'] = '/etc/mongodb.key' if node['mongodb']['key_file_content']
