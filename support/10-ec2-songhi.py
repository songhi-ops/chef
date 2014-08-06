# Instructions:
# 1. Create an ipython profile
# 2. Create a file in ~/.ipython/profile_default/startup/00-start.py
#    with this content:
#    e = {
#       AWS_ACCESS_KEY: 'your access key',
#       AWS_SECRET_KEY: 'your access secret key'
#    }
# 3. symlink this file to the path: ~/.ipython/profile_default/startup/10-start.py
from __future__ import division
from boto.ec2.connection import EC2Connection
from boto.ec2.blockdevicemapping import BlockDeviceType, BlockDeviceMapping
import boto.ec2
import time
import os
from copy import deepcopy

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
            print i.id.rjust(10) , str(i.private_ip_address).ljust(12), str(i.ip_address).ljust(12),  i.state.rjust(8), i.placement.ljust(12), i.instance_type.ljust(12), i.tags.get('Name', '').ljust(20)

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
type_r3_xlarge = 'r3.xlarge'
type_c3_xlarge = 'c3.xlarge'

interface_1c = boto.ec2.networkinterface.NetworkInterfaceSpecification(subnet_id='subnet-362f021e',groups=['sg-e1335784'], associate_public_ip_address=True)
interfaces_1c = boto.ec2.networkinterface.NetworkInterfaceCollection(interface_1c)

interface_1a = boto.ec2.networkinterface.NetworkInterfaceSpecification(subnet_id='subnet-06f3e440',groups=['sg-e1335784'], associate_public_ip_address=True)
interfaces_1a = boto.ec2.networkinterface.NetworkInterfaceCollection(interface_1a)

region_us_east_1c_public = {
                            'connection': conn_east, 
                            'interfaces': interfaces_1c, 
                            'region': 'us-east-1c', 
                            'subnet_id': 'subnet-362f021e'
}


region_us_east_1a_public = {
                            'connection': conn_east, 
                            'interfaces': interfaces_1a, 
                            'region': 'us-east-1a', 
                            'subnet_id': 'subnet-06f3e440'
}

region_us_east_1c_private = {
                            'connection': conn_east, 
                            'region': 'us-east-1c', 
                            'subnet_id': 'subnet-c0d6f9e8'
                            }

region_us_east_1a_private = {
                            'connection': conn_east, 
                            'region': 'us-east-1a', 
                            'subnet_id': 'subnet-ab4449ed'
                            }

"""
Stage_template
"""
template_stage_template = {
        'image_id' : 'ami-eb6b0182',
        'key_name' : 'operations',
        'instance_type' : 'm3.medium',
        'security_group_ids' : ['sg-5935bd3c'],
        'region' : region_us_east_1c_public,
        'ebs_optimized' : False
        }

"""
Mongo DB shard template
"""


template_mongo_shard_east_1a_paravirtual_3500iops = {
        'image_id' : 'ami-82fd15ea',
        'key_name' : 'operations',
        'instance_type' : 'r3.xlarge',
        'security_group_ids' : ['sg-d6d542b3'],
        'region' : region_us_east_1a_private,
        'ebs_optimized' : True
        }

# mongo_shard_east_1c_paravirtual 

template_mongo_shard_east_1c_paravirtual_3500iops = deepcopy(template_mongo_shard_east_1a_paravirtual_3500iops)
template_mongo_shard_east_1c_paravirtual_3500iops['region'] = region_us_east_1c_private



# mongo_shard_east_1a_hvm 

template_mongo_shard_east_1a_hvm_3500iops = deepcopy(template_mongo_shard_east_1a_paravirtual_3500iops)
template_mongo_shard_east_1a_hvm_3500iops['image_id'] =  'ami-8afa12e2'
template_mongo_shard_east_1a_hvm_3500iops['instance_type'] =  'r3.xlarge'

template_mongo_shard_east_1a_hvm_750iops = deepcopy(template_mongo_shard_east_1a_hvm_3500iops)
template_mongo_shard_east_1a_hvm_750iops['image_id'] = 'ami-1416c07c' 


template_mongo_shard_east_1a_hvm_1500iops = deepcopy(template_mongo_shard_east_1a_hvm_3500iops)
template_mongo_shard_east_1a_hvm_1500iops['image_id'] = 'ami-ac1ae7c4'

# mongo_shard_east_1c_hvm 

template_mongo_shard_east_1c_hvm_3500iops = deepcopy(template_mongo_shard_east_1a_hvm_3500iops)
template_mongo_shard_east_1c_hvm_3500iops['region'] = region_us_east_1c_private


template_mongo_shard_east_1c_hvm_750iops = deepcopy(template_mongo_shard_east_1c_hvm_3500iops)
template_mongo_shard_east_1c_hvm_750iops['image_id'] = 'ami-1416c07c' 

template_mongo_shard_east_1c_hvm_1500iops = deepcopy(template_mongo_shard_east_1c_hvm_3500iops)
template_mongo_shard_east_1c_hvm_1500iops['image_id'] = 'ami-ac1ae7c4'


"""
Mongo Config template
"""

template_mongo_config_east_1a_paravirtual_3500iops = {
        'image_id' : 'ami-82fd15ea',
        'key_name' : 'operations',
        'instance_type' : 't1.micro',
        'security_group_ids' : ['sg-d6d542b3'],
        'region' : region_us_east_1a_private,
        'ebs_optimized' : False
        }


template_mongo_config_east_1a_paravirtual_1500iops  = deepcopy(template_mongo_config_east_1a_paravirtual_3500iops)
template_mongo_config_east_1a_paravirtual_1500iops['image_id'] = 'ami-5a17ea32'


template_mongo_config_east_1a_paravirtual_no_iops  = deepcopy(template_mongo_config_east_1a_paravirtual_3500iops)
template_mongo_config_east_1a_paravirtual_no_iops['image_id'] = 'ami-2c9b5644'

"""
# LB templates
"""



template_lb_east_1c = {
        'image_id' : 'ami-c2c93baa',
        'key_name' : 'operations',
        'instance_type' : 'm1.xlarge',
        'security_group_ids' : ['sg-e1335784'],
        'region' : region_us_east_1c_public,
        'ebs_optimized' : False
        }


template_lb_east_1a = deepcopy(template_lb_east_1c)
template_lb_east_1a['region'] = region_us_east_1a_public


"""
Applications
"""

template_application_east_1a = {
        'image_id' : 'ami-c2c93baa',
        'key_name' : 'operations',
        'instance_type' : 'c3.xlarge',
        'security_group_ids' : ['sg-74016511'],
        'region' : region_us_east_1a_private,
        'ebs_optimized' : False
        }

template_application_east_1c = deepcopy(template_application_east_1a)
template_application_east_1c['region'] = region_us_east_1c_private


def aws_launch (template_original, name, instance_type=None, region=None):
    template = deepcopy(template_original)
    region = template['region'] if region is None else region
    instance_size = template['instance_type'] if instance_type is None else instance_type
    if not 'interfaces' in region :
        region['interfaces']=None
    else :
        region['subnet_id']=None
        region['security_group_ids']=None


    connection = region['connection']


    #if 'us-east-1' in region:
    #    connection = conn_east
    #elif 'us-west-2' in region:
    #    connection = conn_west
    #elif 'eu-west-1' in region:
    #    connection = conn_eu
    #elif 'ap-southeast-1' in region:
    #    connection = conn_ap
    #else:
    #    print 'Unkown region'
    #    return 

    command = "run_instances(image_id=" + template['image_id']
    command = command + ", key_name=" + template['key_name']
    command = command + ", instance_type=" + instance_size
    command = command + ", placement=" + region['region']
    if not (region['subnet_id'] is None) :
        command = command + ", subnet_id=" + region['subnet_id']

    command = command + ", disable_api_termination=True"
    command = command + ", security_group_id=["

    if not (template['security_group_ids'] is None):
        for sg in template['security_group_ids'] :
            command = command + ' ' + sg
    command = command + ']'
    command = command + ', ebs_optimized=' + str(template['ebs_optimized'])
    command = command + ')'


    print command    
    r = connection.run_instances(image_id=template['image_id'], key_name=template['key_name'], instance_type=instance_size, placement=region['region'], subnet_id=region['subnet_id'], disable_api_termination=True, security_group_ids=template['security_group_ids'], network_interfaces=region['interfaces'], ebs_optimized=template['ebs_optimized'])
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


