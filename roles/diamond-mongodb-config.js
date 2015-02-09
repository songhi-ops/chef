{
  "name": "diamond-mongodb-config",
  "description": "Only config and mongos",
  "json_class": "Chef::Role",
  "default_attributes": {
    "ulimit": {
      "users": {
        "mongod": {
          "filehandle_limit": 65000,
          "process_limit": "unlimited"
        }
      }
    },
    "mongodb": {
      "configsrv": true,
      "arbiter": true,
      "standalone": false,
      "backup": true
    },
    "iptables-ng": {
      "rules": {
        "filter": {
          "INPUT": {
            "100-ssh": {
              "rule": "--protocol tcp --dport 22 --match state --state NEW --jump ACCEPT"
            },
            "000-established": {
              "rule": "-m state --state ESTABLISHED,RELATED -j ACCEPT"
            },
            "200-mongo-config": {
              "rule": "--protocol tcp --dport 27019 --match state --state NEW --jump ACCEPT"
            },
            "300-ping": {
              "rule": "--protocol icmp --jump ACCEPT"
            },
            "400-ntp": {
              "rule": "--protocol udp --dport 123 --jump ACCEPT"
            },
            "500-munin": {
              "rule": "--protocol tcp --dport 4949 --match state --state NEW --jump ACCEPT"
            },
            "600-nagios": {
              "rule": "--protocol tcp --dport 5666 --match state --state NEW --jump ACCEPT"
            },
            "700-mongo-monitoring": {
              "rule": "--protocol tcp --dport 28019 --match state --state NEW --jump ACCEPT"
            },
            "800-redis": {
              "rule": "--protocol tcp --dport 6379 --match state --state NEW --jump ACCEPT"
            },
            "900-redis-sentinel": {
              "rule": "--protocol tcp --dport 26379 --match state --state NEW --jump ACCEPT"
            },
            "1000-mongo-monitoring": {
              "rule": "--protocol tcp --dport 3000 --match state --state NEW --jump ACCEPT"
            },
            "default": "DROP [0:0]"
          }
        }
      }
    },
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
    "recipe[operations]",
    "recipe[ulimit]",
    "recipe[mongodb]",
    "recipe[iptables-ng]",
    "recipe[users::developers]",
    "recipe[users::sysadmins]",
    "recipe[sudo]",
    "recipe[munin::client]",
    "recipe[nagios::client]",
    "recipe[hosts]",
    "recipe[redisio]",
    "recipe[redisio::enable]",
    "recipe[redisio::sentinel]",
    "recipe[redisio::sentinel_enable]"

  ],
  "env_run_lists": {

  }
}
