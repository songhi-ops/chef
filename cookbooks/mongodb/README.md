mongodb Cookbook
================

This cookbook installs mongodb

Requirements
------------
NONE


Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### mongodb::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['mongodb']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### mongodb::default
Just include `mongodb` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[mongodb]"
  ]
}
```


License and Authors
-------------------
Authors: Juan Jose Rodriguez Ponce
