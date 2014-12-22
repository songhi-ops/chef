{
  "name": "diamond-redis-slave",
  "chef_type": "role",
  "description": "",
  "override_attributes": {
  },
  "default_attributes": {
      "redisio": {
          "servers": [
          { "port": "6379", "slaveof": {"address": "172.16.91.30", "port":"6379" }}
          ]
      
      }
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
