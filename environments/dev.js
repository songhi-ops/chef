{
  "name": "_dev",
  "description": "",
  "cookbook_versions": {
  },
  "json_class": "Chef::Environment",
  "chef_type": "environment",
  "default_attributes": {
  },
  "override_attributes": {
    "nginx": {
      "certificate": "selfsigned-dev"
    },
    "operations": {
      "PS1": "[\\u@\\h \\W]"
    }
  }
}
