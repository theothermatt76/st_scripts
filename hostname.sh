#!/bin/bash
#hostname.sh: set the hostname at first boot

#set some Variables
#Since this is going in /etc/rc.local, lets set a flag so this only runs at first boot, and not at every reboot
FLAG="/usr/local/src/hostname.flag"

#get the IP
IP=$(ip addr show eth0 | grep inet[^0-9] | awk '{print $2}' | cut -d'/' -s -f1)

#Set the hostname Variable
HOSTNAME=ip-$IP

#Make the sausage
if [ ! -f $FLAG ]; then
	hostname $HOSTNAME
	echo $HOSTNAME > /etc/hostname
	touch $FLAG
else
	echo "No soup for you"
fi