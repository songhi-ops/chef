#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: java
# Attributes:: default
#
# Copyright 2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# default jdk attributes
default['java']['jdk_version'] = '8'
default['java']['arch'] = kernel['machine'] =~ /x86_64/ ? "x86_64" : "i586"
default['java']['openjdk_packages'] = []
default['java']['accept_license_agreement'] = false
default['java']['set_default'] = true

case node['platform_family']
when "windows"
  default['java']['install_flavor'] = "windows"
  default['java']['windows']['url'] = nil
  default['java']['windows']['checksum'] = nil
  default['java']['windows']['package_name'] = "Java(TM) SE Development Kit 7 (64-bit)"
else
  default['java']['install_flavor'] = "oracle"
end

case node['java']['install_flavor']
when 'ibm', 'ibm_tar'
  default['java']['ibm']['url'] = nil
  default['java']['ibm']['checksum'] = nil
  default['java']['ibm']['accept_ibm_download_terms'] = false
  default['java']['java_home'] = "/opt/ibm/java"

  default['java']['ibm']['6']['bin_cmds'] = [ "appletviewer", "apt", "ControlPanel", "extcheck", "HtmlConverter", "idlj", "jar", "jarsigner",
                                              "java", "javac", "javadoc", "javah", "javap", "javaws", "jconsole", "jcontrol", "jdb", "jdmpview",
                                              "jrunscript", "keytool", "native2ascii", "policytool", "rmic", "rmid", "rmiregistry",
                                              "schemagen", "serialver", "tnameserv", "wsgen", "wsimport", "xjc" ]

  default['java']['ibm']['7']['bin_cmds'] = node['java']['ibm']['6']['bin_cmds'] + [ "pack200", "unpack200" ]
when 'oracle_rpm'
  default['java']['oracle_rpm']['type'] = 'jdk'
  default['java']['java_home'] = "/usr/java/latest"
end

# if you change this to true, you can download directly from Oracle
default['java']['oracle']['accept_oracle_download_terms'] = true

# direct download paths for oracle, you have been warned!

# jdk6 attributes
default['java']['jdk']['6']['bin_cmds'] = [ "appletviewer", "apt", "ControlPanel", "extcheck", "HtmlConverter", "idlj", "jar", "jarsigner",
                                            "java", "javac", "javadoc", "javah", "javap", "javaws", "jconsole", "jcontrol", "jdb", "jhat",
                                            "jinfo", "jmap", "jps", "jrunscript", "jsadebugd", "jstack", "jstat", "jstatd", "jvisualvm",
                                            "keytool", "native2ascii", "orbd", "pack200", "policytool", "rmic", "rmid", "rmiregistry",
                                            "schemagen", "serialver", "servertool", "tnameserv", "unpack200", "wsgen", "wsimport", "xjc" ]

# x86_64
default['java']['jdk']['6']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-x64.bin'
default['java']['jdk']['6']['x86_64']['checksum'] = '6b493aeab16c940cae9e3d07ad2a5c5684fb49cf06c5d44c400c7993db0d12e8'

# i586
default['java']['jdk']['6']['i586']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-i586.bin'
default['java']['jdk']['6']['i586']['checksum'] = 'd53b5a2518d80e1d95565f0adda54eee229dc5f4a1d1a3c2f7bf5045b168a357'

# jdk7 attributes

default['java']['jdk']['7']['bin_cmds'] = [ "appletviewer", "apt", "ControlPanel", "extcheck", "idlj", "jar", "jarsigner", "java", "javac",
                                            "javadoc", "javafxpackager", "javah", "javap", "javaws", "jcmd", "jconsole", "jcontrol", "jdb",
                                            "jhat", "jinfo", "jmap", "jps", "jrunscript", "jsadebugd", "jstack", "jstat", "jstatd", "jvisualvm",
                                            "keytool", "native2ascii", "orbd", "pack200", "policytool", "rmic", "rmid", "rmiregistry",
                                            "schemagen", "serialver", "servertool", "tnameserv", "unpack200", "wsgen", "wsimport", "xjc" ]

# Oracle doesn't seem to publish SHA256 checksums for Java releases, so we use MD5 instead.
# Official checksums for the latest release can be found at http://www.oracle.com/technetwork/java/javase/downloads/java-se-binaries-checksum-1956892.html

# x86_64
default['java']['jdk']['7']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.tar.gz'
default['java']['jdk']['7']['x86_64']['checksum'] = '764f96c4b078b80adaa5983e75470ff2'

# i586
default['java']['jdk']['7']['i586']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-i586.tar.gz'
default['java']['jdk']['7']['i586']['checksum'] = '909d353c1caf6b3b54cc20767a7778ef'

# jdk8 attributes

default['java']['jdk']['8']['bin_cmds'] = [ "appletviewer", "apt", "ControlPanel", "extcheck", "idlj", "jar", "jarsigner", "java", "javac",
                                            "javadoc", "javafxpackager", "javah", "javap", "javaws", "jcmd", "jconsole", "jcontrol", "jdb",
                                            "jdeps", "jhat", "jinfo", "jjs", "jmap", "jmc", "jps", "jrunscript", "jsadebugd", "jstack",
                                            "jstat", "jstatd", "jvisualvm", "keytool", "native2ascii", "orbd", "pack200", "policytool",
                                            "rmic", "rmid", "rmiregistry", "schemagen", "serialver", "servertool", "tnameserv",
                                            "unpack200", "wsgen", "wsimport", "xjc" ]

# Oracle doesn't seem to publish SHA256 checksums for Java releases, so we use MD5 instead.
# Official checksums for the latest release can be found at http://www.oracle.com/technetwork/java/javase/downloads/javase8-binaries-checksum-2133161.html

# x86_64
default['java']['jdk']['8']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/8-b132/jdk-8-linux-x64.tar.gz'
default['java']['jdk']['8']['x86_64']['checksum'] = '7e9e5e5229c6603a4d8476050bbd98b1'

# i586
default['java']['jdk']['8']['i586']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/8-b132/jdk-8-linux-i586.tar.gz'
default['java']['jdk']['8']['i586']['checksum'] = '45556e463a561b470bd9d0c07a73effb'
