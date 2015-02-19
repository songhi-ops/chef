
default[:tomcat][:home] = "/opt/apache-tomcat-7.0.53"
default[:tomcat][:tarball] = "http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.53/bin/apache-tomcat-7.0.53.tar.gz"
default[:tomcat][:symlink]="/opt/tomcat"
default[:tomcat][:log_directory_old]="/opt/apache-tomcat-7.0.53/logs"
default[:tomcat][:log_directory]="/logs"

if node.chef_environment == "_default" or /_production_/ =~ node.chef_environment
    default[:tomcat][:heap]="-Xms7000m -Xmx7000m"
else
    default[:tomcat][:heap]="-Xms900m -Xmx900m"
end

