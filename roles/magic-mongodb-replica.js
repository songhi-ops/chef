{
  "override_attributes": {
  },
  "name": "magic-mongodb-replica",
  "chef_type": "role",
  "description": "Replica member acting like shard, NO mongos and NO config server",
  "default_attributes": {
    "mongodb": {
      "configsrv": false,
      "standalone": false,
      "shard": true,
      "replica": true
    },
    "ulimit": {
      "users": {
        "mongod": {
          "filehandle_limit": 65000,
          "process_limit": "unlimited"
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
              "rule": "--protocol tcp --dport 28018 --match state --state NEW --jump ACCEPT"
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
    "recipe[sudo]",
    "recipe[munin::client]",
    "recipe[nagios::client]"


  ],
  "env_run_lists": {
  }
}
