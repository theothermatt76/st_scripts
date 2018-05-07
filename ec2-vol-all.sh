#!/bin/bash

##
#v2. (all regions in one report)
#usage: ./ec2-vol-all.sh (preferably cron)

#create an array of all our volumes for each region
mapfile -t RESOURCES1 < <(/usr/local/bin/aws --region "us-west-1" ec2 describe-volumes | grep vol- | awk {'print $2'} | sed s/"\""//g | sed s/,//g | sort | uniq)
mapfile -t RESOURCES2 < <(/usr/local/bin/aws --region "us-west-2" ec2 describe-volumes | grep vol- | awk {'print $2'} | sed s/"\""//g | sed s/,//g | sort | uniq)
mapfile -t RESOURCES3 < <(/usr/local/bin/aws --region "us-east-1" ec2 describe-volumes | grep vol- | awk {'print $2'} | sed s/"\""//g | sed s/,//g | sort | uniq)
mapfile -t RESOURCES4 < <(/usr/local/bin/aws --region "us-east-2" ec2 describe-volumes | grep vol- | awk {'print $2'} | sed s/"\""//g | sed s/,//g | sort | uniq)
mapfile -t RESOURCES5 < <(/usr/local/bin/aws --region "ca-central-1" ec2 describe-volumes | grep vol- | awk {'print $2'} | sed s/"\""//g | sed s/,//g | sort | uniq)

#Let's put the report together
#loop through the instances and get a count of how many there are
numall1=$(echo ${RESOURCES1[@]} | wc | awk {'print $2'} | uniq -u)
numall2=$(echo ${RESOURCES2[@]} | wc | awk {'print $2'} | uniq -u)
numall3=$(echo ${RESOURCES3[@]} | wc | awk {'print $2'} | uniq -u)
numall4=$(echo ${RESOURCES4[@]} | wc | awk {'print $2'} | uniq -u)
numall5=$(echo ${RESOURCES5[@]} | wc | awk {'print $2'} | uniq -u)

#How many volumes have the st:application tag?
numgood1=$(/usr/local/bin/aws --region "us-west-1" ec2 describe-tags --filters "Name=resource-type,Values=volume" | grep st:application | wc | awk {'print $1'})
numgood2=$(/usr/local/bin/aws --region "us-west-2" ec2 describe-tags --filters "Name=resource-type,Values=volume" | grep st:application | wc | awk {'print $1'})
numgood3=$(/usr/local/bin/aws --region "us-east-1" ec2 describe-tags --filters "Name=resource-type,Values=volume" | grep st:application | wc | awk {'print $1'})
numgood4=$(/usr/local/bin/aws --region "us-east-2" ec2 describe-tags --filters "Name=resource-type,Values=volume" | grep st:application | wc | awk {'print $1'})
numgood4=$(/usr/local/bin/aws --region "ca-central-1" ec2 describe-tags --filters "Name=resource-type,Values=volume" | grep st:application | wc | awk {'print $1'})

#create an array of the volume IDs that have
mapfile -t good1 < <(/usr/local/bin/aws --region "us-west-1" ec2 describe-tags --filters {"Name=resource-type,Values=volume","Name=key,Values=st:application"}| grep vol- | awk {'print $2'} | sort | sed s/"\""//g | sed s/","//g | uniq -u)
mapfile -t good2 < <(/usr/local/bin/aws --region "us-west-2" ec2 describe-tags --filters {"Name=resource-type,Values=volume","Name=key,Values=st:application"}| grep vol- | awk {'print $2'} | sort | sed s/"\""//g | sed s/","//g | uniq -u)
mapfile -t good3 < <(/usr/local/bin/aws --region "us-east-1" ec2 describe-tags --filters {"Name=resource-type,Values=volume","Name=key,Values=st:application"}| grep vol- | awk {'print $2'} | sort | sed s/"\""//g | sed s/","//g | uniq -u)
mapfile -t good4 < <(/usr/local/bin/aws --region "us-east-2" ec2 describe-tags --filters {"Name=resource-type,Values=volume","Name=key,Values=st:application"}| grep vol- | awk {'print $2'} | sort | sed s/"\""//g | sed s/","//g | uniq -u)
mapfile -t good5 < <(/usr/local/bin/aws --region "ca-central-1" ec2 describe-tags --filters {"Name=resource-type,Values=volume","Name=key,Values=st:application"}| grep vol- | awk {'print $2'} | sort | sed s/"\""//g | sed s/","//g | uniq -u)

#find out who our baddies are
mapfile -t bad1 < <(echo ${RESOURCES1[@]} ${good1[@]} | tr ' ' ',' | sort -r | uniq -u)
mapfile -t bad2 < <(echo ${RESOURCES2[@]} ${good2[@]} | tr ' ' ',' | sort -r | uniq -u)
mapfile -t bad3 < <(echo ${RESOURCES3[@]} ${good3[@]} | tr ' ' ',' | sort -r | uniq -u)
mapfile -t bad4 < <(echo ${RESOURCES4[@]} ${good4[@]} | tr ' ' ',' | sort -r | uniq -u)
mapfile -t bad5 < <(echo ${RESOURCES5[@]} ${good5[@]} | tr ' ' ',' | sort -r | uniq -u)

#time to paint the fence
echo "##########"
echo "In region US-WEST-1, we have $numall1 volumes, of which $numgood1 have the st:application tag."
echo "In region US-WEST-2, we have $numall2 volumes, of which $numgood2 have the st:application tag."
echo "In region US-EAST-1, we have $numall3 volumes, of which $numgood3 have the st:application tag."
echo "In region US-EAST-2, we have $numall4 volumes, of which $numgood4 have the st:application tag."
echo "In region CA-CENTRAL-1, we have $numall5 volumes, of which $numgood5 have the st:application tag."
echo "##########"
echo "##########"
echo "these volumes do not have an st:application tag:"
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
for i in ${RESOURCES1[@]}; do /usr/local/bin/aws --region "us-west-1" ec2 describe-tags --filters "Name=resource-id,Values=$i" --output text | grep st:application | awk {'print $2 " tag for " $3 " is " $5'}; done
for i in ${RESOURCES2[@]}; do /usr/local/bin/aws --region "us-west-2" ec2 describe-tags --filters "Name=resource-id,Values=$i" --output text | grep st:application | awk {'print $2 " tag for " $3 " is " $5'}; done
for i in ${RESOURCES3[@]}; do /usr/local/bin/aws --region "us-east-1" ec2 describe-tags --filters "Name=resource-id,Values=$i" --output text | grep st:application | awk {'print $2 " tag for " $3 " is " $5'}; done
for i in ${RESOURCES4[@]}; do /usr/local/bin/aws --region "us-east-2" ec2 describe-tags --filters "Name=resource-id,Values=$i" --output text | grep st:application | awk {'print $2 " tag for " $3 " is " $5'}; done
for i in ${RESOURCES5[@]}; do /usr/local/bin/aws --region "ca-central-1" ec2 describe-tags --filters "Name=resource-id,Values=$i" --output text | grep st:application | awk {'print $2 " tag for " $3 " is " $5'}; done
