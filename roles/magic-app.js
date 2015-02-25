{
  "name": "magic-app",
  "chef_type": "role",
  "description": "",
  "override_attributes": {
  },
  "default_attributes": {
    "mongodb": {
      "standalone": false,
      "mongos": true
    },
    "songhi" : {
        "app_name" : "magic"
    },
    "ulimit": {
      "users": {
        "mongod": {
          "filehandle_limit": 65000,
          "process_limit": "unlimited"
        },
        "tomcat": {
          "filehandle_limit": 65000,
          "process_limit": 65000
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
            "200-tomcat": {
              "rule": "--protocol tcp --dport 8080 --match state --state NEW --jump ACCEPT"
            },
            "300-tomcat-shutdown": {
              "rule": "--protocol tcp --dport 9626 --match state --state NEW -s localhost --jump ACCEPT"
            },
            "400-mongos": {
              "rule": "--protocol tcp --dport 27017 --match state --state NEW --jump ACCEPT"
            },
            "500-munin": {
              "rule": "--protocol tcp --dport 4949 --match state --state NEW --jump ACCEPT"
            },
            "500-nagios": {
              "rule": "--protocol tcp --dport 5666 --match state --state NEW --jump ACCEPT"
            },
            "600-ping": {
              "rule": "--protocol icmp --jump ACCEPT"
            },
            "700-ntp": {
              "rule": "--protocol udp --dport 123 --jump ACCEPT"
            },
            "800-munin": {
              "rule": "--protocol tcp --dport 4949 --match state --state NEW --jump ACCEPT"
            },
            "900-nagios": {
              "rule": "--protocol tcp --dport 5666 --match state --state NEW --jump ACCEPT"
            },
            "default": "DROP [0:0]"
          }
        }
      }
    },
    "sysctl":{
        "allow_sysctl_conf": true,
        "params": {
            "net": {
                "ipv4": {
                    "tcp_tw_reuse": 1
                }
            }
        }
    }
  },
  "run_list": [
    "recipe[operations]",
    "recipe[sysctl::apply]",
    "recipe[ulimit]",
    "recipe[tomcat]",
    "recipe[mongodb]",
    "recipe[iptables-ng]",
    "recipe[users::developers]",
    "recipe[users::sysadmins]",
    "recipe[sudo]",
    "recipe[munin::client]",
    "recipe[nagios::client]",
    "recipe[graylog2::tomcat]"
  ],
  "env_run_lists": {
  },
  "json_class": "Chef::Role"
}
