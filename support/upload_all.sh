#!/bin/bash
for cookbook in `ls cookbooks | egrep -v README.md` ; do echo $cookbook; knife cookbook upload $cookbook; done
for user in `ls data_bags/users.*`; do echo $user; knife data bag from file users $user; done
for environment in `ls environments/*.js`; do echo $environment;  knife environment from file $environment; done
for role in `ls roles/*.js`; do echo $role;  knife role from file $role; done
