{
  "name": "magic-nagios-server",
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
    "recipe[nagios::server]"
  ],
  "env_run_lists": {
  }
}
