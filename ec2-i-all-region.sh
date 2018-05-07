#!/bin/bash

##
#v2. (all regions in one report)
#usage: ./ec2-tags.sh (preferably cron)


#create array of instance IDs for each region
mapfile -t USW1RESOURCES < <(/usr/local/bin/aws --region "us-west-1" ec2 describe-instances | grep InstanceId | awk {'print $2'} | sed s/"\""//g | sed s/,//g)
mapfile -t USW2RESOURCES < <(/usr/local/bin/aws --region "us-west-2" ec2 describe-instances | grep InstanceId | awk {'print $2'} | sed s/"\""//g | sed s/,//g)
mapfile -t USE1RESOURCES < <(/usr/local/bin/aws --region "us-east-1" ec2 describe-instances | grep InstanceId | awk {'print $2'} | sed s/"\""//g | sed s/,//g)
mapfile -t USE2RESOURCES < <(/usr/local/bin/aws --region "us-east-2" ec2 describe-instances | grep InstanceId | awk {'print $2'} | sed s/"\""//g | sed s/,//g)
mapfile -t USCA1RESOURCES < <(/usr/local/bin/aws --region "ca-central-1" ec2 describe-instances | grep InstanceId | awk {'print $2'} | sed s/"\""//g | sed s/,//g)

#Let's put the report together
#loop through the instances and get a count of how many there are vs how many have the st:application tag
numall1=$(echo ${USW1RESOURCES[@]} | wc | awk {'print $2'})
numall2=$(echo ${USW2RESOURCES[@]} | wc | awk {'print $2'})
numall3=$(echo ${USE1RESOURCES[@]} | wc | awk {'print $2'})
numall4=$(echo ${USE2RESOURCES[@]} | wc | awk {'print $2'})
numall5=$(echo ${USCA1RESOURCES[@]} | wc | awk {'print $2'})
numgood1=$(/usr/local/bin/aws ec2 --region "us-west-1" describe-tags --filters {"Name=resource-type,Values=instance","Name=key,Values=st:application"} | grep i- | sort | uniq -u | wc | awk {'print $1'})
numgood2=$(/usr/local/bin/aws ec2 --region "us-west-2" describe-tags --filters {"Name=resource-type,Values=instance","Name=key,Values=st:application"} | grep i- | sort | uniq -u | wc | awk {'print $1'})
numgood3=$(/usr/local/bin/aws ec2 --region "us-east-1" describe-tags --filters {"Name=resource-type,Values=instance","Name=key,Values=st:application"} | grep i- | sort | uniq -u | wc | awk {'print $1'})
numgood4=$(/usr/local/bin/aws ec2 --region "us-east-2" describe-tags --filters {"Name=resource-type,Values=instance","Name=key,Values=st:application"} | grep i- | sort | uniq -u | wc | awk {'print $1'})
numgood5=$(/usr/local/bin/aws ec2 --region "ca-central-1" describe-tags --filters {"Name=resource-type,Values=instance","Name=key,Values=st:application"} | grep i- | sort | uniq -u | wc | awk {'print $1'})
mapfile -t good1 < <(/usr/local/bin/aws --region "us-west-1" ec2 describe-tags --filters {"Name=resource-type,Values=instance","Name=key,Values=st:application"} | grep i- | awk {'print $2'} | sort | sed s/"\""//g | sed s/","//g)
mapfile -t good2 < <(/usr/local/bin/aws --region "us-west-2" ec2 describe-tags --filters {"Name=resource-type,Values=instance","Name=key,Values=st:application"} | grep i- | awk {'print $2'} | sort | sed s/"\""//g | sed s/","//g)
mapfile -t good3 < <(/usr/local/bin/aws --region "us-east-1" ec2 describe-tags --filters {"Name=resource-type,Values=instance","Name=key,Values=st:application"} | grep i- | awk {'print $2'} | sort | sed s/"\""//g | sed s/","//g)
mapfile -t good4 < <(/usr/local/bin/aws --region "us-east-2" ec2 describe-tags --filters {"Name=resource-type,Values=instance","Name=key,Values=st:application"} | grep i- | awk {'print $2'} | sort | sed s/"\""//g | sed s/","//g)
mapfile -t good5 < <(/usr/local/bin/aws --region "ca-central-1" ec2 describe-tags --filters {"Name=resource-type,Values=instance","Name=key,Values=st:application"} | grep i- | awk {'print $2'} | sort | sed s/"\""//g | sed s/","//g)
mapfile -t bad1 < <(echo ${USW1RESOURCES[@]} ${good1[@]} | tr ' ' ',' | sort -r | uniq -u)
mapfile -t bad2 < <(echo ${USW2RESOURCES[@]} ${good2[@]} | tr ' ' ',' | sort -r | uniq -u)
mapfile -t bad3 < <(echo ${USE1RESOURCES[@]} ${good3[@]} | tr ' ' ',' | sort -r | uniq -u)
mapfile -t bad4 < <(echo ${USE2RESOURCES[@]} ${good4[@]} | tr ' ' ',' | sort -r | uniq -u)
mapfile -t bad5 < <(echo ${USCA1RESOURCES[@]} ${good5[@]} | tr ' ' ',' | sort -r | uniq -u)
echo "##########"
echo "In region US-WEST-1, we have $numall1 instances, of which $numgood1 have the st:application tag."
echo "In region US-WEST-2, we have $numall2 instances, of which $numgood2 have the st:application tag."
echo "In region US-EAST-1, we have $numall3 instances, of which $numgood3 have the st:application tag."
echo "In region US-EAST-2, we have $numall4 instances, of which $numgood4 have the st:application tag."
echo "In region CA-CENTRAL-1, we have $numall5 instances, of which $numgood5 have the st:application tag."
echo "##########"
echo "##########"
echo "These instances do not have an st:application tag:"
echo "##"
echo "US-WEST-1"
for i in ${bad1[@]}; do echo $i; done
echo "##"
echo "US-WEST-2"
for i in ${bad2[@]}; do echo $i; done
echo "##"
echo "US-EAST-1"
for i in ${bad3[@]}; do echo $i; done
echo "##"
echo "US-EAST-2"
for i in ${bad4[@]}; do echo $i; done
echo "##"
echo "CA-CENTRAL-1"
for i in ${bad5[@]}; do echo $i; done
echo "##########"
echo "##########"
#loop through the instances and actually get the st:application tag value
for i in ${USW1RESOURCES[@]}; do /usr/local/bin/aws --region "us-west-1" ec2 describe-tags --filters "Name=resource-id,Values=$i" --output text | grep st:application | awk {'print $2 " tag for " $3 " is " $5'}; done
for i in ${USW2RESOURCES[@]}; do /usr/local/bin/aws --region "us-west-2" ec2 describe-tags --filters "Name=resource-id,Values=$i" --output text | grep st:application | awk {'print $2 " tag for " $3 " is " $5'}; done
for i in ${USE1RESOURCES[@]}; do /usr/local/bin/aws --region "us-east-1" ec2 describe-tags --filters "Name=resource-id,Values=$i" --output text | grep st:application | awk {'print $2 " tag for " $3 " is " $5'}; done
for i in ${USE2RESOURCES[@]}; do /usr/local/bin/aws --region "us-east-2" ec2 describe-tags --filters "Name=resource-id,Values=$i" --output text | grep st:application | awk {'print $2 " tag for " $3 " is " $5'}; done
for i in ${USCA1RESOURCES[@]}; do /usr/local/bin/aws --region "ca-central-1" ec2 describe-tags --filters "Name=resource-id,Values=$i" --output text | grep st:application | awk {'print $2 " tag for " $3 " is " $5'}; done
