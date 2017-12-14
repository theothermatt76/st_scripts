#!/bin/bash

#splunk forwarder cobble script
#Matt Brister, 11/17/2016
#
#steps required:
#
#unzip tgz to /opt/
#copy config file to /opt/splunkforwarder/etc/system/local
#edit serverName variable in config
####################################

#unzip
tar -xzf splunkforwarder-6.4.0-f2c836328108-Linux-x86_64.tgz -C /opt/

#copy config file
#unknown how codedeploy will do this, assuming a simple cp will do it.
#No idea of source, also assuming it is location script is running from.
cp ./server.conf /opt/splunkforwarder/etc/system/local/

#fix the config
sed -i "s/www1.dal/%HOSTNAME/" /opt/splunkforwarder/etc/system/local/server.conf
