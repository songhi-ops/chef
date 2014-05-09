{
  "name": "magic-app",
  "chef_type": "role",
  "env_run_lists": {
  },
  "description": "",
  "json_class": "Chef::Role",
  "run_list": [
    "recipe[operations]",
    "recipe[tomcat]",
    "recipe[iptables-ng]"
  ],
  "override_attributes": {
  },
  "default_attributes": {
    "iptables-ng": {
      "rules": {
        "filter": {
          "INPUT": {
            "000-established": {
              "rule": "-m state --state ESTABLISHED,RELATED -j ACCEPT"
            },
            "default": "DROP [0:0]",
            "200-tomcat": {
              "rule": "--protocol tcp --dport 8080 --match state --state NEW --jump ACCEPT"
            },
            "100-ssh": {
              "rule": "--protocol tcp --dport 22 --match state --state NEW --jump ACCEPT"
            }
          }
        }
      }
    }
  }
}
