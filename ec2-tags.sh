#!/bin/bash

##
#v1. (single region)
#usage: ./ec2-tags.sh <region>

#input test
region=$1
if [ "$region" = "" ]; then echo "Missing Region. Try again, the right way."
else

#create array of all the instance IDs in our region
mapfile -t RESOURCES < <(/usr/local/bin/aws --region $region ec2 describe-instances | grep InstanceId | awk {'print $2'} | sed s/"\""//g | sed s/,//g)

#Let's put a report together
#loop through our instances and get a count of how many there are vs how many have the st:application tag

#how many are there total?
numall=$(echo ${RESOURCES[@]} | wc | awk {'print $2'})
#how many have an st:application tag?
numgood=$(/usr/local/bin/aws ec2 --region $region describe-tags --filters {"Name=resource-type,Values=instance","Name=key,Values=st:application"} | grep i- | sort | uniq -u | wc | awk {'print $1'})
#Create an  array of instance IDs that *have* an st:application tag
mapfile -t good < <(/usr/local/bin/aws --region $region ec2 describe-tags --filters {"Name=resource-type,Values=instance","Name=key,Values=st:application"} | grep i- | awk {'print $2'} | sort | sed s/"\""//g | sed s/","//g)
#create an array of the IDs that dont...
mapfile -t bad < <(echo ${RESOURCES[@]} ${good[@]} | tr ' ' ',' | sort -r | uniq -u)

#time to paint the fence
echo "##########"
echo "In region $region, we have $numall instances, of which $numgood have the st:application tag."
echo "##########"
echo "##########"
echo "These instances do not have an st:application tag:"
for i in ${bad[@]}; do echo $i; done
echo "##########"
echo "##########"
#loop through the instances and actually get the st:application tag value
for i in ${RESOURCES[@]}; do /usr/local/bin/aws --region $region ec2 describe-tags --filters "Name=resource-id,Values=$i" --output text | grep st:application | awk {'print $2 " tag for " $3 " is " $5'}; done
fi
