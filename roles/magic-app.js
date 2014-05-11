{
  "name": "magic-app",
  "chef_type": "role",
  "description": "",
  "override_attributes": {
  },
  "default_attributes": {
    "ulimit": {
      "users": {
        "tomcat": {
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
            "200-tomcat": {
              "rule": "--protocol tcp --dport 8080 --match state --state NEW --jump ACCEPT"
            },
            "default": "DROP [0:0]"
          }
        }
      }
    }
  },
  "run_list": [
    "recipe[operations]",
    "recipe[ulimit]",
    "recipe[tomcat]",
    "recipe[iptables-ng]",
    "recipe[users::developers]",
    "recipe[users::sysadmins]",
    "recipe[sudo]"
  ],
  "env_run_lists": {
  },
  "json_class": "Chef::Role"
}
