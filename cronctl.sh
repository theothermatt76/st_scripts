#!/bin/bash

###
#Cronctl: start/stop cron service with runcommand (EC2-SSM)
###
#Usage: using runcommand: /root/scripts/cronctl.sh start/stop
###

###
#V1: 2/2/2017 Matt Brister (matt.brister@sterlingts.com)
###

if [ "$1" = "" ]; then
	echo "Missing command. Usage: cronctl.sh start/stop" 2>&1
	exit 1
fi

if [ "$(id -u)" != "0" ]; then
	echo "You must run this script as root!" 2>&1
	exit 1
else
service cron $1
fi