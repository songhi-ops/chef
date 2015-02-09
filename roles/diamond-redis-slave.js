{
  "name": "diamond-redis-slave",
  "chef_type": "role",
  "description": "",
  "override_attributes": {
  },
  "default_attributes": {
      "redisio": {
          "servers": [
          { "port": "6379", "slaveof": {"address": "diamond-redis01.songhi-ops.com", "port":"6379" }}
          ],

          "sentinels": [{"master_ip":"diamond-redis01.songhi-ops.com", "sentinel_port": "26379", "master_port" : "6379", "name": "shard01"}]
      
      },
      "munin":{
          "app_name" : "diamond"
      }
  },
  "run_list": [
    "recipe[operations]",
    "recipe[hosts]",
    "recipe[redisio]",
    "recipe[redisio::enable]",
    "recipe[redisio::sentinel]",
    "recipe[redisio::sentinel_enable]",
    "recipe[munin::client]"

  ],
  "env_run_lists": {
  },
  "json_class": "Chef::Role"
}
