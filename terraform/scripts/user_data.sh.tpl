#!/bin/bash
TIMESTAMP=`date +%Y-%m-%d.%H:%M:%S`

exec > /tmp/part-$TIMESTAMP.log 2>&1

aws configure set aws_access_key_id ${aws_access_key_id}
aws configure set aws_secret_access_key ${aws_secret_access_key}
aws configure set default.region ${aws_region}

REMOTE=413774799288.dkr.ecr.us-west-2.amazonaws.com
REPO=mui-theme-server

AWSLOGIN=$(aws ecr get-login --no-include-email)
LOGINCMD="sudo $AWSLOGIN"
OUTPUT=$(eval "$LOGINCMD")

docker pull $REMOTE/$REPO:latest
docker run -d -p 80:3333 $REMOTE/$REPO:latest

echo yes | rm /var/lib/cloud/instances/*/sem/config_scripts_user
