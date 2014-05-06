{
  "name": "mongodb-shard",
  "description": "Replica member acting like shard, mongos and config server",
  "json_class": "Chef::Role",
  "default_attributes": {
    "mongodb": {
      "replica": true,
      "mongos": true,
      "configsrv": true,
      "standalone": false,
      "shard": true
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
                    "200-mongo-shard": {
                        "rule": "--protocol tcp --dport 27018 --match state --state NEW --jump ACCEPT" 
                    },
                    "300-mongo-config": {
                        "rule": "--protocol tcp --dport 27019 --match state --state NEW --jump ACCEPT" 
                    },
                    "400-mongos": {
                        "rule": "--protocol tcp --dport 27017 --match state --state NEW --jump ACCEPT" 
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
    "recipe[mongodb]",
    "recipe[iptables-ng]"
  ],
  "env_run_lists": {
  }
}
