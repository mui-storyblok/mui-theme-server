#!/bin/sh

cd ./terraform

terraform init .

EC2_ID=$(eval "terraform output ec2_id")
aws ec2 reboot-instances --instance-ids ${EC2_ID}
