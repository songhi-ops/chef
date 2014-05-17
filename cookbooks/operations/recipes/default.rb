#
# Cookbook Name:: operations
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


include_recipe 'operations::packages'
include_recipe 'operations::vim'
include_recipe 'operations::motd'
include_recipe 'operations::misc'
include_recipe 'operations::selinux'
include_recipe 'operations::sshd'
include_recipe 'ntp'
include_recipe 'operations::ec2-metadata'

