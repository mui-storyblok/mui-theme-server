#!/bin/sh

REMOTE=413774799288.dkr.ecr.us-west-2.amazonaws.com
REPO=mui-theme-server

docker build \
 --build-arg MUI_THEME_ENV_API_DB_HOST=$MUI_THEME_ENV_API_DB_HOST \
 --build-arg MUI_THEME_ENV_API_DB_PORT=$MUI_THEME_ENV_API_DB_PORT \
 --build-arg MUI_THEME_ENV_API_DB_NAME=$MUI_THEME_ENV_API_DB_NAME \
 --build-arg MUI_THEME_ENV_API_DB_USER=$MUI_THEME_ENV_API_DB_USER \
 --build-arg MUI_THEME_ENV_API_SSL_MODE=$MUI_THEME_ENV_API_SSL_MODE \
  -f Dockerfile -t $REMOTE/$REPO:latest .