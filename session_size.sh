#!/bin/bash

#session_size.sh: Matt Brister (matt.brister@sterlingts.com)
#v1.0 12/13/2017 - Initial release
###
#What it be:
#Cron job to poll specified information about php5 sessions on the S1 Trans and Admin stacks.
#REQUIRES: 2 flat txt files, containing IP addresses of your stacks, one machine per line. s1-trans.txt and s1-admmin.txt, must be located in same directory as this script
#suggested crontab usage: 0 5,11,17,23 * * * /path/to/script/session_size.sh | mail -s session_info <your email or DL>
###

#Create arrays for our source IPs
mapfile -t trans < <(cat /home/ec2-user/scripts/s1-trans.txt)
mapfile -t admin < <(cat /home/ec2-user/scripts/s1-admin.txt)

#Source Array debug break
#echo "tarray"
#echo ${trans[@]}
#echo "#####"
#echo "aarray"
#echo ${admin[@]}
#fi

#Get the count of sessions files per machine, arrayed by stack
mapfile -t tcount < <(for e in ${trans[@]}; do ssh -i /home/ec2-user/.ssh/s1-app-prod-v2.pem root@$e 'ls -h1 /var/lib/php5/sessions| wc -l'; done)
mapfile -t acount < <(for e in ${admin[@]}; do ssh -i /home/ec2-user/.ssh/s1-app-prod-v2.pem root@$e 'ls -h1 /var/lib/php5/sessions| wc -l'; done)
mapfile -t tsize < <(for e in ${trans[@]}; do ssh -i /home/ec2-user/.ssh/s1-app-prod-v2.pem root@$e 'du -sh /var/lib/php5/sessions | tr "\t" " " | tr "/" " "' | tr -d "M" | awk '{print $1}'; done)
mapfile -t asize < <(for e in ${admin[@]}; do ssh -i /home/ec2-user/.ssh/s1-app-prod-v2.pem root@$e 'du -sh /var/lib/php5/sessions | tr "\t" " " | tr "/" " "' | tr -d "M" | awk '{print $1}'; done)

#Average (mean) of our counts
IFS='+' tcavg=$(echo "scale=1;(${tcount[*]})/${#tcount[@]}"|bc)
IFS='+' acavg=$(echo "scale=1;(${acount[*]})/${#acount[@]}"|bc)
IFS='+' tsavg=$(echo "scale=1;(${tsize[*]})/${#tsize[@]}"|bc)
IFS='+' asavg=$(echo "scale=1;(${asize[*]})/${#asize[@]}"|bc)

#Aggregate of our counts (sum)
IFS='+' tcsum=$(echo "scale=1;${tcount[*]}"|bc)
IFS='+' acsum=$(echo "scale=1;${acount[*]}"|bc)
IFS='+' tssum=$(echo "scale=1;${tsize[*]}"|bc)
IFS='+' assum=$(echo "scale=1;${asize[*]}"|bc)

#Output the totals for our email (STDOUT)
echo "PER MACHINE"
echo "#####"
echo "Number of sessions on trans (per machine)"
echo ${tcount[@]}
echo "#####"
echo "Number of sessions on admin (per machine)"
echo ${acount[@]}
echo "#####"
echo "Sessions size on disk for trans (per machine, in MB)"
echo ${tsize[@]}
echo "#####"
echo "Sessions size on disk for admin (per machine, in MB)"
echo ${asize[@]}
echo ""
echo ""
echo "AVERAGES"
echo "#####"
echo "Average number of sessions on trans (mean)"
echo ${tcavg[@]}
echo "#####"
echo "Average number of sessions on admin (mean)"
echo ${acavg[@]}
echo "#####"
echo "Average sessions size on disk for trans (mean, in MB)"
echo ${tsavg[@]}
echo "#####"
echo "Average sessions size on disk for admin (mean, in MB)"
echo ${asavg[@]}
echo ""
echo ""
echo "AGGREGATE"
echo "#####"
echo "Aggregate number of sessions on trans (sum total)"
echo ${tcsum[@]}
echo "#####"
echo "Aggregate number of sessions on admin (sum total)"
echo ${acsum[@]}
echo "#####"
echo "Aggregate sessions size on disk for trans (sum total, in MB)"
echo ${tssum[@]}
echo "#####"
echo "Aggregate sessions size on disk for admin (sum total, in MB)"
echo ${assum[@]}
