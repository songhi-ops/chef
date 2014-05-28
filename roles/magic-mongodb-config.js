{
  "env_run_lists": {
  },
  "name": "magic-mongodb-config",
  "description": "Only config and mongos",
  "run_list": [
    "recipe[operations]",
    "recipe[ulimit]",
    "recipe[mongodb]",
    "recipe[iptables-ng]",
    "recipe[users::developers]",
    "recipe[users::sysadmins]",
    "recipe[sudo]"
  ],
  "json_class": "Chef::Role",
  "chef_type": "role",
  "override_attributes": {
  },
  "default_attributes": {
    "ulimit": {
      "users": {
        "mongo": {
          "filehandle_limit": 65000
        }
      }
    },
    "mongodb": {
      "configsrv": true,
      "standalone": false
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
            "default": "DROP [0:0]"
          }
        }
      }
    }
  }
}
