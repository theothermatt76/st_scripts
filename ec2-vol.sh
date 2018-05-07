#!/bin/bash

#usage: ./ec2-vol.sh <region>

#input test
region=$1
if [ "$region" = "" ]; then echo "Missing Region. Try again, the right way."
else

#create an array of all our volumes
mapfile -t RESOURCES < <(/usr/local/bin/aws --region $region ec2 describe-volumes | grep vol- | awk {'print $2'} | sed s/"\""//g | sed s/,//g | sort | uniq)

#Let's put the report together
#loop through the instances and get a count of how many there are
numall=$(echo ${RESOURCES[@]} | wc | awk {'print $2'} | uniq -u)
#How many volumes have the st:application tag?
numgood=$(/usr/local/bin/aws --region $region ec2 describe-tags --filters "Name=resource-type,Values=volume" | grep st:application | wc | awk {'print $1'})
#create an array of the volume IDs that have
mapfile -t good < <(/usr/local/bin/aws --region $region ec2 describe-tags --filters {"Name=resource-type,Values=volume","Name=key,Values=st:application"}| grep vol- | awk {'print $2'} | sort | sed s/"\""//g | sed s/","//g | uniq -u)
#find out who our baddies are
mapfile -t bad < <(echo ${RESOURCES[@]} ${good[@]} | tr ' ' ',' | sort -r | uniq -u)

#time to paint the fence
echo "##########"
echo "In region $region, we have $numall volumes, of which $numgood have the st:application tag."
echo "##########"
echo "these volumes do not have an st:application tag:"
for i in ${bad[@]}; do echo $i; done
echo "##########"
#loop through the instances and actually get the st:application tag value
for i in ${RESOURCES[@]}; do /usr/local/bin/aws --region $region ec2 describe-tags --filters "Name=resource-id,Values=$i" --output text | grep st:application | awk {'print $2 " tag for " $3 " is " $5'}; done
fi
