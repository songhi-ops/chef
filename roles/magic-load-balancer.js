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
            "200-http": {
              "rule": "--protocol tcp --dport 80 --match state --state NEW --jump ACCEPT"
            },
            "300-https": {
              "rule": "--protocol tcp --dport 443 --match state --state NEW --jump ACCEPT"
            },
            "400-ping": {
              "rule": "--protocol icmp --jump ACCEPT"
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
        }
      }
    }
  },
  "name": "magic-load-balancer",
  "run_list": [
    "recipe[operations]",
    "recipe[ulimit]",
    "recipe[nginx]",
    "recipe[iptables-ng]",
    "recipe[users::developers]",
    "recipe[users::sysadmins]",
    "recipe[sudo]"
  ],
  "chef_type": "role",
  "env_run_lists": {
  },
  "json_class": "Chef::Role"
}
