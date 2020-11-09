#!/bin/bash
# set -euo pipefail
# IFS=$'\n\t'

REMOTE=413774799288.dkr.ecr.us-west-2.amazonaws.com
REPO=mui-theme-server

AWSLOGIN=$(aws ecr get-login --no-include-email);
LOGINCMD="sudo $AWSLOGIN"
OUTPUT=$(eval "$LOGINCMD")

GIT_HASH="$(git rev-parse HEAD)"

# Push same image twice, once with the commit hash as the tag, and once with
# 'latest' as the tag. 'latest' will always refer to the last image that was
# built, since the next time this script is run, it'll get overridden. The
# commit hash, however, is a constant reference to this image.

sudo docker tag $REMOTE/$REPO $REMOTE/$REPO:$GIT_HASH
sudo docker push $REMOTE/$REPO:$GIT_HASH

sudo docker tag $REMOTE/$REPO $REMOTE/$REPO:latest
sudo docker push $REMOTE/$REPO:latest
