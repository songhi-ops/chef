{
  "override_attributes": {
  },
  "description": "",
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
            "200-tomcat": {
              "rule": "--protocol tcp --dport 8080 --match state --state NEW --jump ACCEPT"
            },
            "default": "DROP [0:0]",
            "300-tomcat-ssl": {
              "rule": "--protocol tcp --dport 8443 --match state --state NEW --jump ACCEPT"
            }
          }
        }
      }
    },
    "ulimit": {
      "users": {
        "nginx": {
          "filehandle_limit": 65000
        }
      }
    }
  },
  "name": "magic-load-balancer",
  "run_list": [
    "recipe[operations]",
    "recipe[ulimit]",
    "recipe[nginx]",
    "recipe[iptables-ng]"
  ],
  "chef_type": "role",
  "env_run_lists": {
  },
  "json_class": "Chef::Role"
}
