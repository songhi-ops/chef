{
  "name": "diamond-redis-master",
  "chef_type": "role",
  "description": "",
  "override_attributes": {
  },
  "default_attributes": {
  },
  "run_list": [
    "recipe[operations]",
    "recipe[redisio]",
    "recipe[redisio::enable]",
    "recipe[redisio::sentinel]",
    "recipe[redisio::sentinel_enable]"

  ],
  "env_run_lists": {
  },
  "json_class": "Chef::Role"
}
