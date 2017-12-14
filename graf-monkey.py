from __future__ import print_function

import json
import boto3
import logging

#setup simple logging for INFO
logger = logging.getLogger()
logger.setLevel(logging.ERROR)

#define the connection region
ec2 = boto3.resource('ec2', region_name="us-west-2")

#Set this to True if you don't want the function to perform any actions
debugMode = False

def lambda_handler(event, context):
    #List all EC2 instances
    base = ec2.instances.all()

    #loop through by running instances
    for instance in base:

        #Tag the Volumes
        for vol in instance.volumes.all():
            try:
                if debugMode == True:
                    print("[DEBUG] " + str(vol))
                    tag_cleanup(instance, vol.attachments[0]['Device'])
                else:
                    tag = vol.create_tags(Tags=tag_cleanup(instance, vol.attachments[0]['Device']))
                    print("[INFO]: " + str(tag))
            except:
                pass

def tag_cleanup(instance, detail):
    tempTags=[]
    v={}

    for t in instance.tags:
        #pull the name tag
        if t['Key'] == 'Name':
            v['Value'] = t['Value'] + " - " + str(detail)
            v['Key'] = 'Name'
            tempTags.append(v)
        #Set the important tags that should be written here
        elif t['Key'] == 'st:owner':
            print("[INFO]: Application Owner " + str(t))
            tempTags.append(t)
        elif t['Key'] == 'st:application':
            print("[INFO]: Function " + str(t))
            tempTags.append(t)
        elif t['Key'] == 'Lifecycle':
            print("[INFO]: Lifecycle " + str(t))
            tempTags.append(t)
        elif t:
            pass
        else:
            print("[INFO]: Skip Tag - " + str(t))
    print("[INFO] " + str(tempTags))
    return(tempTags)
