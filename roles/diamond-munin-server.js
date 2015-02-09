{
  "name": "diamond-munin-server",
  "description": "",
  "json_class": "Chef::Role",
  "default_attributes": {
      "munin": {
      "app_name": "diamond"
      },
      "nagios": {
      "app_name": "diamond"
      }
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "recipe[munin::server]"
  ],
  "env_run_lists": {
  }
}
