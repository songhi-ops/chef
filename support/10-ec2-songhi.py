

# Instructions:
# 1. Create an ipython profile
# 2. Create a file in ~/.ipython/profile_default/startup/00-start.py
#    with this content:
#    e = {
#       AWS_ACCESS_KEY: 'your access key',
#       AWS_SECRET_KEY: 'your access secret key'
#    }
# 3. symlink this file to the path: ~/.ipython/profile_default/startup/10-start.py

from boto.ec2.connection import EC2Connection
from boto.ec2.blockdevicemapping import BlockDeviceType, BlockDeviceMapping
import boto.ec2
import time
import os

regions = boto.ec2.regions()
us_east_1 = filter(lambda obj: obj.name == 'us-east-1', regions)[0]
us_west_2 = filter(lambda obj: obj.name == 'us-west-2', regions)[0]
eu_west_1 = filter(lambda obj: obj.name == 'eu-west-1', regions)[0]
ap_southeast_1 = filter(lambda obj: obj.name == 'ap-southeast-1', regions)[0]

conn_east = EC2Connection(aws_access_key_id=e['AWS_ACCESS_KEY'], aws_secret_access_key=e['AWS_SECRET_KEY'], region=us_east_1)
reservations_east = conn_east.get_all_instances()
instances_east = [x for x in  sorted(tuple(x.instances[0] for x in reservations_east) , key=lambda tup: tup.tags.get('Name'))]

conn_west = EC2Connection(aws_access_key_id=e['AWS_ACCESS_KEY'], aws_secret_access_key=e['AWS_SECRET_KEY'], region=us_west_2)
reservations_west = conn_west.get_all_instances()
instances_west = [x for x in  sorted(tuple(x.instances[0] for x in reservations_west) , key=lambda tup: tup.tags.get('Name'))]

conn_eu = EC2Connection(aws_access_key_id=e['AWS_ACCESS_KEY'], aws_secret_access_key=e['AWS_SECRET_KEY'], region=eu_west_1)
reservations_eu = conn_eu.get_all_instances()
instances_eu = [x for x in  sorted(tuple(x.instances[0] for x in reservations_eu) , key=lambda tup: tup.tags.get('Name'))]

conn_ap = EC2Connection(aws_access_key_id=e['AWS_ACCESS_KEY'], aws_secret_access_key=e['AWS_SECRET_KEY'], region=ap_southeast_1)
reservations_ap = conn_ap.get_all_instances()
instances_ap = [x for x in  sorted(tuple(x.instances[0] for x in reservations_ap) , key=lambda tup: tup.tags.get('Name'))]


instances = instances_east + instances_west + instances_eu + instances_ap

noneString = lambda s: s or ''

def aws_reload() :
    global conn_east
    global reservations_east
    global instances_east
    global conn_west
    global reservations_west
    global instances_west
    global conn_eu
    global reservations_eu
    global instances_eu
    global conn_ap
    global reservations_ap
    global instances_ap
    global instances

    reservations_east = conn_east.get_all_instances()
    instances_east = [x for x in  sorted(tuple(x.instances[0] for x in reservations_east) , key=lambda tup: tup.tags.get('Name'))]
    reservations_west = conn_west.get_all_instances()
    instances_west = [x for x in  sorted(tuple(x.instances[0] for x in reservations_west) , key=lambda tup: tup.tags.get('Name'))]
    reservations_eu = conn_eu.get_all_instances()
    instances_eu = [x for x in  sorted(tuple(x.instances[0] for x in reservations_eu) , key=lambda tup: tup.tags.get('Name'))]
    instances_ap = [x for x in  sorted(tuple(x.instances[0] for x in reservations_ap) , key=lambda tup: tup.tags.get('Name'))]
    instances_ap = [x for x in  sorted(tuple(x.instances[0] for x in reservations_ap) , key=lambda tup: tup.tags.get('Name'))]
    instances = instances_east + instances_west + instances_eu + instances_ap



def aws_instance (input_string='no_matter', state='all', supress_output = False):
    if len(input_string) == 0:
        return

    list = [i for i in instances if (state=='all' or i.state == state) and (input_string in i.tags.get('Name', '') or i.id == input_string or i.private_ip_address == input_string or input_string == 'no_matter')]

    if not supress_output:
        for i in list:
            print i.id.rjust(10) , str(i.private_ip_address).rjust(12),  i.state.rjust(8),  i.tags.get('Name', '')

    if len(list) == 1:
        return list[0]
    else:
        return list


def aws_eips(connection, supress_output=False):
    list_eips = connection.get_all_addresses()
    tuple_eips = [(aws_instance(noneString(addr.instance_id), supress_output=True), addr) for addr in list_eips]
    if not supress_output:
        for tup in tuple_eips:
            if tup[0] is not None:
                print str(tup[0].id).rjust(10), str(tup[1].public_ip).rjust(16), tup[0].tags.get('Name', '') 



            else:
                print ''.rjust(10), str(tup[1].public_ip).rjust(16)


    return tuple_eips

type_t1_micro = 't1.micro'
type_m3_xlarge = 'm3.xlarge'
type_r3_2xlarge = 'r3.2xlarge'

"""
Stage_template
"""
template_stage_template = {
        'image_id' : 'ami-eb6b0182',
        'key_name' : 'operations',
        'instance_type' : 'm3.medium',
        'subnet_id' : 'subnet-362f021e',
        'security_group_ids' : ['sg-5935bd3c'],
        'connection' : conn_east,
        'region' : 'us-east-1c',
        }

"""
Mongo DB shard template
"""


template_mongo_shard_east_1a_paravirtual = {
        'image_id' : 'ami-82fd15ea',
        'key_name' : 'operations',
        'instance_type' : 't1.micro',
        'subnet_id' : 'subnet-ab4449ed',
        'security_group_ids' : ['sg-d6d542b3'],
        'connection' : conn_east,
        'region' : 'us-east-1a',
        }

# mongo_shard_east_1c_paravirtual 

template_mongo_shard_east_1c_paravirtual = template_mongo_shard_east_1a_paravirtual 
template_mongo_shard_east_1c_paravirtual['subnet_id'] = 'subnet-c0d6f9e8'
template_mongo_shard_east_1c_paravirtual['region'] = 'us-east-1c'


# mongo_shard_east_1a_hvn 

template_mongo_shard_east_1a_hvn = template_mongo_shard_east_1a_paravirtual 
template_mongo_shard_east_1a_hvn['image_id'] =  'ami-8afa12e2'
template_mongo_shard_east_1a_hvn['instance_type'] =  'r3.2xlarge'


# mongo_shard_east_1c_hvn 

template_mongo_shard_east_1c_hvn = template_mongo_shard_east_1a_hvn 
template_mongo_shard_east_1c_hvn['subnet_id'] = 'subnet-c0d6f9e8'
template_mongo_shard_east_1c_hvn['region'] = 'us-east-1c'

"""
# LB templates
"""

interface_1c = boto.ec2.networkinterface.NetworkInterfaceSpecification(subnet_id='subnet-362f021e',groups=['sg-e1335784'], associate_public_ip_address=True)
interfaces_1c = boto.ec2.networkinterface.NetworkInterfaceCollection(interface_1c)


template_lb_east_1c = {
        'image_id' : 'ami-c2c93baa',
        'key_name' : 'operations',
        'instance_type' : 'm1.xlarge',
        'subnet_id' : 'subnet-362f021e',
        'security_group_ids' : ['sg-e1335784'],
        'connection' : conn_east,
        'region' : 'us-east-1c',
        'interfaces' : interfaces_1c
        }

interface_1a = boto.ec2.networkinterface.NetworkInterfaceSpecification(subnet_id='subnet-06f3e440',groups=['sg-e1335784'], associate_public_ip_address=True)
interfaces_1a = boto.ec2.networkinterface.NetworkInterfaceCollection(interface_1a)

template_lb_east_1a = template_lb_east_1c 
template_lb_east_1a['interfaces'] = interfaces_1a
template_lb_east_1a['region'] = 'us-east-1a'

"""
Applications
"""

template_application_east_1a = {
        'image_id' : 'ami-c2c93baa',
        'key_name' : 'operations',
        'instance_type' : 'c3.2xlarge',
        'subnet_id' : 'subnet-ab4449ed',
        'security_group_ids' : ['sg-74016511'],
        'connection' : conn_east,
        'region' : 'us-east-1a'
        }
template_application_east_1c = template_application_east_1a
template_application_east_1c['subnet_id'] = 'subnet-c0d6f9e8'
template_application_east_1c['region'] = 'us-east-1c'


def aws_launch (template, name, instance_type=None, region=None):
    region = template['region'] if region is None else region
    instance_size = template['instance_type'] if instance_type is None else instance_type
    if not 'interfaces' in template :
        template['interfaces']=None
    else :
        template['subnet_id']=None
        template['security_group_ids']=None

    if 'us-east-1' in region:
        connection = conn_east
    elif 'us-west-2' in region:
        connection = conn_west
    elif 'eu-west-1' in region:
        connection = conn_eu
    elif 'ap-southeast-1' in region:
        connection = conn_ap
    else:
        print 'Unkown region'
        return 

    
    print "run_instances(image_id=" + template['image_id'] + ", key_name=" + template['key_name'] + ", instance_type=" + instance_size + ", placement="+ region + ", subnet_id=" + template['subnet_id'] + ", disable_api_termination=True)"
    r = template['connection'].run_instances(image_id=template['image_id'], key_name=template['key_name'], instance_type=instance_size, placement=region, subnet_id=template['subnet_id'], disable_api_termination=True, security_group_ids=template['security_group_ids'], network_interfaces=template['interfaces'])
    instance = r.instances[0]
    instance.add_tag(key='Name', value=name)

    while instance.state == u'pending':
        print instance.state + "...."
        instance.update()
        time.sleep(15)
    instance.update()
    print instance.state
    time.sleep(15)

    user_data = "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /Volumes/untitled/SongHi/operations.pem root@" + instance.private_ip_address + " 'curl --connect-timeout 10 -u operations:smothcooperat0r http://10.0.0.74:801/hosts.php?hostname=" + name + " | bash '" 
    print user_data
    os.system(user_data)

    print "Instance created: " + r.instances[0].id
    print "private IP : :"
    print "\t" + instance.private_ip_address + "\t" + name 


