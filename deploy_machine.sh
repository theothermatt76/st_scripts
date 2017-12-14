#!/bin/bash

###
#deploy_machine.sh - Deploy new instances in EC2 based on our gold DVM AMI
#V1 Matt Brister (matt.brister@sterlingts.com), 10/10/2016
###
#Usage: ./deploy_machine.sh $number-of-machines $AWS-EC2-config-profile-name
###

if [ "$1" = "" ]; then
	echo "Missing Count. No soup for you!"
fi

if [ "$2" = "" ]; then
	echo "Missing your profile. Who are you?? Prank caller!!!."
fi

if [ "$1" = "" ] && [ "$2" = "" ]; then
	echo "USAGE: ./deploy_machine.sh <number of machines to launch> <your config profile name>"

else
aws ec2 run-instances --count $1 --profile $2 --image-id ami-16f50876 --instance-type t2.medium --subnet-id subnet-c0828099 --security-group-ids sg-30b3f057 2</dev/null
fi