{
  "json_class": "Chef::Role",
  "run_list": [
    "recipe[operations]",
    "recipe[nginx]",
    "recipe[iptables-ng]"
  ],
  "chef_type": "role",
  "name": "magic-load-balancer",
  "default_attributes": {
    "iptables-ng": {
      "rules": {
        "filter": {
          "INPUT": {
            "000-established": {
              "rule": "-m state --state ESTABLISHED,RELATED -j ACCEPT"
            },
            "300-tomcat-ssl": {
              "rule": "--protocol tcp --dport 8443 --match state --state NEW --jump ACCEPT"
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
  "description": "",
  "override_attributes": {
  },
  "env_run_lists": {
  }
}
