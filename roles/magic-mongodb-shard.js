{
  "override_attributes": {
  },
  "name": "magic-mongodb-shard",
  "chef_type": "role",
  "description": "Replica member acting like shard, mongos and config server",
  "default_attributes": {
    "mongodb": {
      "configsrv": true,
      "standalone": false,
      "shard": true,
      "mongos": true,
      "replica": true
    },
    "ulimit": {
      "users": {
        "mongo": {
          "filehandle_limit": 65000
        }
      }
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
            "200-mongo-shard": {
              "rule": "--protocol tcp --dport 27018 --match state --state NEW --jump ACCEPT"
            },
            "300-mongo-config": {
              "rule": "--protocol tcp --dport 27019 --match state --state NEW --jump ACCEPT"
            },
            "400-mongos": {
              "rule": "--protocol tcp --dport 27017 --match state --state NEW --jump ACCEPT"
            },
            "500-ping": {
              "rule": "--protocol icmp --jump ACCEPT"
            },
            "default": "DROP [0:0]"
          }
        }
      }
    }
  },
  "json_class": "Chef::Role",
  "run_list": [
    "recipe[operations]",
    "recipe[ulimit]",
    "recipe[mongodb]",
    "recipe[iptables-ng]",
    "recipe[users::developers]",
    "recipe[users::sysadmins]",
    "recipe[sudo]"
  ],
  "env_run_lists": {
  }
}
