name             'tomcat'
maintainer       'Opscode, Inc.'
maintainer_email 'cookbooks@opscode.com'
license          'Apache 2.0'
description      'Installs/Configures tomcat'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.15.12'

depends 'java'
depends 'ark'
depends 'openssl'
depends 'sudo'

supports 'debian'
supports 'ubuntu'
supports 'centos'
supports 'redhat'
supports 'amazon'
supports 'scientific'

recipe 'tomcat::default', 'Installs and configures Tomcat'
recipe 'tomcat::users', 'Setup users and roles for Tomcat'
