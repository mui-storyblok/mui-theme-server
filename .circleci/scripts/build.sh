#!/bin/sh

REMOTE=413774799288.dkr.ecr.us-west-2.amazonaws.com
REPO=mui-theme-server

docker build -f Dockerfile -t $REMOTE/$REPO:latest .