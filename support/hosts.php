<?php
$domain='.example.com';
$chef_subdomain='chef';
$net_regexp='192.168.0.[0-9]{1,3}';

if (!is_null($_GET['hostname'])) {
?>
	#!/bin/bash
	
	hostname=`hostname`
	if [ "$hostname" == "localhost.localdomain" ]
		then
	
		chef=<?php echo "{$_SERVER['SERVER_ADDR']}\n";?>
		ip=`ifconfig | grep -Pio '<?php echo $net_regexp; ?>' | head -n 1`
		hostname=<?php echo "{$_GET['hostname']}{$domain}\n";?> 
		hostname $hostname
		echo $ip $hostname >> /etc/hosts
		echo $chef <?php echo gethostname()?> >> /etc/hosts
cat > /etc/sysconfig/network << EOF
NETWORKING=yes
HOSTNAME=<?php echo "{$_GET['hostname']}{$domain}\n"; ?>
EOF
	fi
<?php
}
?>


