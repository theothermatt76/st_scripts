#!/bin/bash
#
#deploy_machine.sh - Deploy new instances in EC2 based on our gold DVM AMI
#Matt Brister, 10/10/2016
#
#Updated 8/20/2017, now requires AWS CLI version greater than March 2017 release. Adds IAM profile and tags automatically
###

if [ "$1" = "" ]; then echo "Missing Count. No soup for you!"
else
aws ec2 run-instances --count $1 --image-id ami- --instance-type t2.medium --subnet-id subnet- --iam-instance-profile Name="EC2BoxProfile" --security-group-ids --tag-specifications 'ResourceType=instance,Tags=[{Key='st:owner',Value=" Kothari"},{Key='st:application',Value="Development"},{Key='Lifecycle',Value="05-18-2020"}]' 'ResourceType=volume,Tags=[{Key='st:owner',Value=" Kothari"},{Key='st:application',Value="Development"},{Key='Lifecycle',Value="05-18-2020"}]' 2>/dev/null
fi
