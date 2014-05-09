{
  "chef_type": "role",
  "json_class": "Chef::Role",
  "override_attributes": {
  },
  "default_attributes": {
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
            "default": "DROP [0:0]"
          }
        }
      }
    },
    "mongodb": {
      "configsrv": true,
      "standalone": false
    }
  },
  "run_list": [
    "recipe[operations]",
    "recipe[mongodb]",
    "recipe[iptables-ng]"
  ],
  "description": "Only config and mongos",
  "env_run_lists": {
  },
  "name": "magic-mongodb-config"
}
