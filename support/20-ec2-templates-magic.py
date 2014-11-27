
import boto.ec2

pem_key='operations.pem'

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
