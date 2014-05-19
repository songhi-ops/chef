<?php
$domain='.example.com';
$chef_subdomain='chef';
$net_regexp='192.168.0.[0-9]{1,3}';
$chef_key='ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAtgegDkLavAydDBZGHErr6zqFAmRl2dO6lSZcN/0qsNTGks2XcN0Zr2Ife6uksTv5iBjdJHf6zeILOMguV/MliQxPIJ/5YyuSjEUimPbfijeqtNxUJxl0qhVZJmYBxpxFPel4FP5rJrpTy9XV33hlpIynREj7CIzpT6sGhaBJEGvvu+eXrQE4+71xEgJjzaWToyn1hXsr4dSi34NNh4oLRfMBqqHlL0xexK32xwH85t6CZvIIJAuoN87aS1N0f5yhLd7YtbDOHzTqCu1/SVEiNQXq5DARs5uukyH8n/ldJNumPCsc+Ro92oE7Y3VhCzX6FZmbBG5gNPW+HjYKkBlkaw== root@chef.songhi-ops.com';

if (!is_null($_GET['hostname'])) {
?>
	#!/bin/bash
	
	hostname=`hostname`
	
        chef=<?php echo "{$_SERVER['SERVER_ADDR']}\n";?>
        ip=`ifconfig | grep -Pio '<?php echo $net_regexp; ?>' | head -n 1`
        hostname=<?php echo "{$_GET['hostname']}{$domain}\n";?> 
        hostname $hostname
        echo $ip $hostname >> /etc/hosts
        echo $chef <?php echo gethostname()?> >> /etc/hosts
        grep '<?php echo $chef_key ?>' /root/.ssh/authorized_keys
        if [ "$?" == "1" ]
        then
            echo <?php echo $chef_key ?> >> /root/.ssh/authorized_keys
        fi
cat > /etc/sysconfig/network << EOF
NETWORKING=yes
HOSTNAME=<?php echo "{$_GET['hostname']}{$domain}\n"; ?>
EOF
<?php
}
?>


