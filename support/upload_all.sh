#!/bin/bash
for cookbook in `ls cookbooks | egrep -v README.md` ; do knife cookbook upload $cookbook; done
for user in `ls data_bags/users.*`; do knife data bag from file users $user; done
for environment in `ls environments/*.js`; do knife environment from file $environment; done
for role in `ls roles/*.js`; do knife role from file $role; done
