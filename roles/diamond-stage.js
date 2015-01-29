{
  "name": "diamond-stage",
  "description": "",
  "json_class": "Chef::Role",
  "default_attributes": {
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
            "200-http": {
              "rule": "--protocol tcp --dport 80 --match state --state NEW --jump ACCEPT"
            },
            "300-https": {
              "rule": "--protocol tcp --dport 443 --match state --state NEW --jump ACCEPT"
            },
            "400-tomcat": {
              "rule": "--protocol tcp --dport 8080 --match state --state NEW --jump ACCEPT"
            },
            "500-tomcat-ssl": {
              "rule": "--protocol tcp --dport 8443 --match state --state NEW --jump ACCEPT"
            },
            "600-tomcat-shutdown": {
              "rule": "--protocol tcp --dport 8005 --match state --state NEW --jump ACCEPT"
            },
            "700-mongod": {
              "rule": "--protocol tcp --dport 27017 --match state --state NEW --jump ACCEPT"
            },
            "800-ping": {
              "rule": "--protocol icmp --jump ACCEPT"
            },
            "900-ntp": {
              "rule": "--protocol udp --dport 123 --jump ACCEPT"
            },
            "1000-redis": {
              "rule": "--protocol udp --dport 6379 --jump ACCEPT"
            },
            "default": "DROP [0:0]"
          }
        }
      }
    },
    "ulimit": {
      "users": {
        "nginx": {
          "filehandle_limit": 65000
        },
        "tomcat": {
          "filehandle_limit": 65000
        }
      }
    },
    "nginx": {
        "app_name": "diamond"
    },
    "tomcat": {
        "app_name": "diamond"
    }
  },
  "override_attributes": {

  },
  "chef_type": "role",
  "run_list": [
    "recipe[operations]",
    "recipe[ulimit]",
    "recipe[nginx]",
    "recipe[iptables-ng]",
    "recipe[users::developers]",
    "recipe[users::sysadmins]",
    "recipe[sudo]",
    "recipe[tomcat]",
    "recipe[mongodb]",
    "recipe[redisio]",
    "recipe[redisio::enable]"

  ],
  "env_run_lists": {

  }
}
