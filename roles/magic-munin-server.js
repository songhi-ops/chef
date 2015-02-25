{
  "name": "magic-munin-server",
  "description": "",
  "json_class": "Chef::Role",
  "default_attributes": {
    "songhi" : {
        "app_name" : "magic"
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
