{
  "name": "diamond-redis-slave",
  "chef_type": "role",
  "description": "",
  "override_attributes": {
  },
  "default_attributes": {
      "redisio": {
          "servers": [
          { "port": "6379", "slaveof": {"address": "diamond-redis01.songhi-ops.com", "port":"6379" }, "backuptype": "none"}
          ],

          "sentinels": [{"master_ip":"diamond-redis01.songhi-ops.com", "sentinel_port": "26379", "master_port" : "6379", "name": "shard01"}]
      
      },
    "iptables-ng": {
      "rules": {
        "filter": {
          "INPUT": {
            "000-established": {
              "rule": "-m state --state ESTABLISHED,RELATED -j ACCEPT"
            },
            "100-ssh": {
              "rule": "--protocol tcp --dport 22 --match state --state NEW --jump ACCEPT"
            },
            "200-ping": {
              "rule": "--protocol icmp --jump ACCEPT"
            },
            "300-ntp": {
              "rule": "--protocol udp --dport 123 --jump ACCEPT"
            },
            "400-munin": {
              "rule": "--protocol tcp --dport 4949 --match state --state NEW --jump ACCEPT"
            },
            "500-nagios": {
              "rule": "--protocol tcp --dport 5666 --match state --state NEW --jump ACCEPT"
            },
            "600-redis": {
              "rule": "--protocol tcp --dport 6379 --match state --state NEW --jump ACCEPT"
            },
            "700-redis-sentinel": {
              "rule": "--protocol tcp --dport 26379 --match state --state NEW --jump ACCEPT"
            },
            "default": "DROP [0:0]"
          }
        }
      }
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
    "recipe[munin::client]",
    "recipe[nagios::client]",
    "recipe[iptables-ng]"

  ],
  "env_run_lists": {
  },
  "json_class": "Chef::Role"
}
