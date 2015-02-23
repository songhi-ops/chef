
from boto.ec2.connection import EC2Connection
from boto.ec2.blockdevicemapping import BlockDeviceType, BlockDeviceMapping
import boto.ec2

pem_key='diamond-prod.pem'

type_t1_micro = 't1.micro'
type_m3_xlarge = 'm3.xlarge'
type_r3_2xlarge = 'r3.2xlarge'
type_r3_xlarge = 'r3.xlarge'
type_c3_xlarge = 'c3.xlarge'

interface_1c = boto.ec2.networkinterface.NetworkInterfaceSpecification(subnet_id='subnet-96815dcf',groups=['sg-f638db92'], associate_public_ip_address=True)
interfaces_1c = boto.ec2.networkinterface.NetworkInterfaceCollection(interface_1c)

interface_1a = boto.ec2.networkinterface.NetworkInterfaceSpecification(subnet_id='subnet-cb609fe0',groups=['sg-f638db92'], associate_public_ip_address=True)
interfaces_1a = boto.ec2.networkinterface.NetworkInterfaceCollection(interface_1a)

region_us_east_1c_public = {
                            'connection': conn_east, 
                            'interfaces': interfaces_1c, 
                            'region': 'us-east-1c', 
                            'subnet_id': 'subnet-96815dcf'
}


region_us_east_1a_public = {
                            'connection': conn_east, 
                            'interfaces': interfaces_1a, 
                            'region': 'us-east-1a', 
                            'subnet_id': 'subnet-cb609fe0'
}

region_us_east_1c_private = {
                            'connection': conn_east, 
                            'region': 'us-east-1c', 
                            'subnet_id': 'subnet-c7815d9e'
                            }

region_us_east_1a_private = {
                            'connection': conn_east, 
                            'region': 'us-east-1a', 
                            'subnet_id': 'subnet-ff609fd4'
                            }

"""
Stage_template
"""
template_stage_template = {
        'image_id' : 'ami-a4f56acc',
        'key_name' : 'diamond-prod',
        'instance_type' : 'm3.medium',
        'security_group_ids' : ['sg-9d06e5f9'],
        'region' : region_us_east_1c_public,
        'ebs_optimized' : False
        }

"""
Mongo DB shard template
"""



"""
WONT WORK AS IMAGE DOESNT EXISTS
BUT HELPS TO INHERIT VALUES
"""

template_mongo_shard_east_1a_paravirtual_3500iops = {
        'image_id' : 'ami-82fd15ea',
        'key_name' : 'diamond-prod',
        'instance_type' : 'r3.xlarge',
        'security_group_ids' : ['sg-5515f631'],
        'region' : region_us_east_1a_private,
        'ebs_optimized' : True
        }

# mongo_shard_east_1c_paravirtual 

"""
WONT WORK AS IMAGE DOESNT EXISTS
BUT HELPS TO INHERIT VALUES
"""
template_mongo_shard_east_1c_paravirtual_3500iops = deepcopy(template_mongo_shard_east_1a_paravirtual_3500iops)
template_mongo_shard_east_1c_paravirtual_3500iops['region'] = region_us_east_1c_private



# mongo_shard_east_1a_hvm 


"""
WONT WORK AS IMAGE DOESNT EXISTS
BUT HELPS TO INHERIT VALUES
"""
template_mongo_shard_east_1a_hvm_3500iops = deepcopy(template_mongo_shard_east_1a_paravirtual_3500iops)
template_mongo_shard_east_1a_hvm_3500iops['image_id'] =  'ami-8afa12e2'
template_mongo_shard_east_1a_hvm_3500iops['instance_type'] =  'r3.xlarge'


"""
THIS ONE SHOULD WORK
"""
template_mongo_shard_east_1a_hvm_750iops = deepcopy(template_mongo_shard_east_1a_hvm_3500iops)
template_mongo_shard_east_1a_hvm_750iops['image_id'] = 'ami-0e9f0066' 


"""
WONT WORK AS IMAGE DOESNT EXISTS
BUT HELPS TO INHERIT VALUES
"""
template_mongo_shard_east_1a_hvm_1500iops = deepcopy(template_mongo_shard_east_1a_hvm_3500iops)
template_mongo_shard_east_1a_hvm_1500iops['image_id'] = 'ami-ac1ae7c4'

# mongo_shard_east_1c_hvm 

"""
WONT WORK AS IMAGE DOESNT EXISTS
BUT HELPS TO INHERIT VALUES
"""
template_mongo_shard_east_1c_hvm_3500iops = deepcopy(template_mongo_shard_east_1a_hvm_3500iops)
template_mongo_shard_east_1c_hvm_3500iops['region'] = region_us_east_1c_private


"""
THIS ONE SHOULD WORK
"""
template_mongo_shard_east_1c_hvm_750iops = deepcopy(template_mongo_shard_east_1c_hvm_3500iops)
template_mongo_shard_east_1c_hvm_750iops['image_id'] = 'ami-0e9f0066' 


"""
WONT WORK AS IMAGE DOESNT EXISTS
BUT HELPS TO INHERIT VALUES
"""
template_mongo_shard_east_1c_hvm_1500iops = deepcopy(template_mongo_shard_east_1c_hvm_3500iops)
template_mongo_shard_east_1c_hvm_1500iops['image_id'] = 'ami-ac1ae7c4'


"""
Mongo Config template
"""


"""
WONT WORK AS IMAGE DOESNT EXISTS
BUT HELPS TO INHERIT VALUES
"""
template_mongo_config_east_1a_paravirtual_3500iops = {
        'image_id' : 'ami-82fd15ea',
        'key_name' : 'diamond-prod',
        'instance_type' : 't1.micro',
        'security_group_ids' : ['sg-5515f631'],
        'region' : region_us_east_1a_private,
        'ebs_optimized' : False
        }


"""
WONT WORK AS IMAGE DOESNT EXISTS
BUT HELPS TO INHERIT VALUES
"""
template_mongo_config_east_1a_paravirtual_1500iops  = deepcopy(template_mongo_config_east_1a_paravirtual_3500iops)
template_mongo_config_east_1a_paravirtual_1500iops['image_id'] = 'ami-5a17ea32'


"""
THIS ONE SHOULD WORK
"""
template_mongo_config_east_1a_paravirtual_no_iops  = deepcopy(template_mongo_config_east_1a_paravirtual_3500iops)
template_mongo_config_east_1a_paravirtual_no_iops['image_id'] = 'ami-4e910e26'
template_mongo_config_east_1a_paravirtual_no_iops['instance_type'] = 'm3.large'

"""
# LB templates
"""



template_lb_east_1c = {
        'image_id' : 'ami-d28e11ba',
        'key_name' : 'diamond-prod',
        'instance_type' : 'm1.xlarge',
        'security_group_ids' : ['sg-f638db92'],
        'region' : region_us_east_1c_public,
        'ebs_optimized' : False
        }


template_lb_east_1a = deepcopy(template_lb_east_1c)
template_lb_east_1a['region'] = region_us_east_1a_public


"""
Applications
"""

template_application_east_1a = {
        'image_id' : 'ami-d28e11ba',
        'key_name' : 'diamond-prod',
        'instance_type' : 'c3.xlarge',
        'security_group_ids' : ['sg-5d7f9c39'],
        'region' : region_us_east_1a_private,
        'ebs_optimized' : False
        }

template_application_east_1c = deepcopy(template_application_east_1a)
template_application_east_1c['region'] = region_us_east_1c_private

template_redis_east_1a = {
        'image_id' : 'ami-e64e308e',
        'key_name' : 'diamond-prod',
        'instance_type' : 'm3.large',
        'security_group_ids' : ['sg-0cbd6d68'],
        'region' : region_us_east_1a_private,
        'ebs_optimized' : False
        }

template_redis_east_1c = {
        'image_id' : 'ami-e64e308e',
        'key_name' : 'diamond-prod',
        'instance_type' : 'm3.large',
        'security_group_ids' : ['sg-0cbd6d68'],
        'region' : region_us_east_1c_private,
        'ebs_optimized' : False
        }
