{
  "name": "svn-server",
  "description": "",
  "json_class": "Chef::Role",
  "default_attributes": {
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "recipe[operations]",
    "recipe[subversion::server]"
  ],
  "env_run_lists": {
  }
}
