{
  "name": "diamond-redis-master",
  "chef_type": "role",
  "description": "",
  "override_attributes": {
  },
  "default_attributes": {
      "redisio": {
          "servers": [
          { "port": "6379"}
          ],
          "sentinels": [{"master_ip":"diamond-redis-master.songhi-dev.com", "sentinel_port": "26379", "master_port" : "6379", "name": "mycluster"}]
      
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
