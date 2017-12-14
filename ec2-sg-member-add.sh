#!/bin/bash
#
#Add ip ranges to security groups
#matt brister, 10/7/2016
#

#add port 80 to dev-tw-web-traffic-only
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 80 --cidr 144.202.243.10/31
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 80 --cidr 144.202.243.12/30
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 80 --cidr 144.202.243.16/28
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 80 --cidr 144.202.243.32/27
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 80 --cidr 144.202.243.64/26
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 80 --cidr 144.202.243.128/26
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 80 --cidr 144.202.243.192/27
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 80 --cidr 144.202.243.224/28
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 80 --cidr 144.202.243.240/30
#add port 443 to dev-tw-web-traffic-only
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 443 --cidr 144.202.243.10/31
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 443 --cidr 144.202.243.12/30
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 443 --cidr 144.202.243.16/28
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 443 --cidr 144.202.243.32/27
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 443 --cidr 144.202.243.64/26
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 443 --cidr 144.202.243.128/26
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 443 --cidr 144.202.243.192/27
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 443 --cidr 144.202.243.224/28
aws ec2 authorize-security-group-ingress --group-id sg-b50535d2 --protocol tcp --port 443 --cidr 144.202.243.240/30
#add port 22 to dev-tw-foundation
aws ec2 authorize-security-group-ingress --group-id sg-30b3f057 --protocol tcp --port 22 --cidr 144.202.243.10/31
aws ec2 authorize-security-group-ingress --group-id sg-30b3f057 --protocol tcp --port 22 --cidr 144.202.243.12/30
aws ec2 authorize-security-group-ingress --group-id sg-30b3f057 --protocol tcp --port 22 --cidr 144.202.243.16/28
aws ec2 authorize-security-group-ingress --group-id sg-30b3f057 --protocol tcp --port 22 --cidr 144.202.243.32/27
aws ec2 authorize-security-group-ingress --group-id sg-30b3f057 --protocol tcp --port 22 --cidr 144.202.243.64/26
aws ec2 authorize-security-group-ingress --group-id sg-30b3f057 --protocol tcp --port 22 --cidr 144.202.243.128/26
aws ec2 authorize-security-group-ingress --group-id sg-30b3f057 --protocol tcp --port 22 --cidr 144.202.243.192/27
aws ec2 authorize-security-group-ingress --group-id sg-30b3f057 --protocol tcp --port 22 --cidr 144.202.243.224/28
aws ec2 authorize-security-group-ingress --group-id sg-30b3f057 --protocol tcp --port 22 --cidr 144.202.243.240/30
