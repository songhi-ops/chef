{
  "name": "magic-all",
  "description": "",
  "json_class": "Chef::Role",
  "default_attributes": {
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "recipe[operations]",
    "recipe[tomcat]",
    "recipe[mongodb]",
    "recipe[sudo]",
    "recipe[users::developers]",
    "recipe[users::sysadmins]"
  ],
  "env_run_lists": {
  }
}
