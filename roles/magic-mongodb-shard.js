{
  "run_list": [
    "recipe[operations]",
    "recipe[mongodb]",
    "recipe[iptables-ng]"
  ],
  "env_run_lists": {
  },
  "chef_type": "role",
  "name": "magic-mongodb-shard",
  "override_attributes": {
  },
  "default_attributes": {
    "iptables-ng": {
      "rules": {
        "filter": {
          "INPUT": {
            "000-established": {
              "rule": "-m state --state ESTABLISHED,RELATED -j ACCEPT"
            },
            "default": "DROP [0:0]",
            "400-mongos": {
              "rule": "--protocol tcp --dport 27017 --match state --state NEW --jump ACCEPT"
            },
            "300-mongo-config": {
              "rule": "--protocol tcp --dport 27019 --match state --state NEW --jump ACCEPT"
            },
            "200-mongo-shard": {
              "rule": "--protocol tcp --dport 27018 --match state --state NEW --jump ACCEPT"
            },
            "100-ssh": {
              "rule": "--protocol tcp --dport 22 --match state --state NEW --jump ACCEPT"
            }
          }
        }
      }
    },
    "mongodb": {
      "standalone": false,
      "configsrv": true,
      "mongos": true,
      "replica": true,
      "shard": true
    }
  },
  "description": "Replica member acting like shard, mongos and config server",
  "json_class": "Chef::Role"
}
