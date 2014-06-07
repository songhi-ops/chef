#!/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin//python
import sys
import json

json_string= ''
while True:
    new_line=sys.stdin.readline()
    if not new_line:
        break
    else:
        json_string = json_string + new_line

nodes = json.loads ("[" + json_string + "]")

for node in nodes[0]['rows'] :
    print  node['automatic']['ipaddress'] + "\t\t" + node['automatic']['fqdn'] 
