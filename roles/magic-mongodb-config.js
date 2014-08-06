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
    "recipe[sudo]",
    "recipe[munin::client]",
    "recipe[nagios::client]"
  ],
  "json_class": "Chef::Role",
  "chef_type": "role",
  "override_attributes": {
  },
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
            "800-mongo-monitoring": {
              "rule": "--protocol tcp --dport 3000 --match state --state NEW --jump ACCEPT"
            },
            "default": "DROP [0:0]"
          }
        }
      }
    }
  }
}
