{
  "name": "mongodb-config",
  "description": "Only config and mongos",
  "json_class": "Chef::Role",
  "default_attributes": {
    "mongodb": {
      "configsrv": true,
      "standalone": false
    },
    "iptables-ng":{
        "rules":{
            "filter":{
                "INPUT":{
                    "default": "DROP [0:0]",
                    "000-established" : {
                        "rule": "-m state --state ESTABLISHED,RELATED -j ACCEPT"
                    },
                    "100-ssh": {
                        "rule": "--protocol tcp --dport 22 --match state --state NEW --jump ACCEPT" 
                    },
                    "200-mongo-config": {
                        "rule": "--protocol tcp --dport 27019 --match state --state NEW --jump ACCEPT" 
                    }
                }
            }
        }
    }
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "recipe[operations]",
    "recipe[mongodb]"
  ],
  "env_run_lists": {
  }
}
