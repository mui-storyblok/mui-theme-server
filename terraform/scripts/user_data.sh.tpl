#!/bin/bash
TIMESTAMP=`date +%Y-%m-%d.%H:%M:%S`

exec > /tmp/part-$TIMESTAMP.log 2>&1
# install and turn nginx on
amazon-linux-extras install nginx1.12
chkconfig nginx on

aws configure set aws_access_key_id ${aws_access_key_id}
aws configure set aws_secret_access_key ${aws_secret_access_key}
aws configure set default.region ${aws_region}

REMOTE=413774799288.dkr.ecr.us-west-2.amazonaws.com
REPO=mui-theme-server

AWSLOGIN=$(aws ecr get-login --no-include-email)
LOGINCMD="sudo $AWSLOGIN"
OUTPUT=$(eval "$LOGINCMD")

docker pull $REMOTE/$REPO:latest
docker run -d -p 3333:80 $REMOTE/$REPO:latest

# echo "
#     #user  nobody;
#     worker_processes  1;
#     events {
#         worker_connections  1024;
#     }

#     http {
#         include       mime.types;
#         default_type  application/octet-stream;
#         sendfile        on;
#         #tcp_nopush     on;
#         #keepalive_timeout  0;
#         keepalive_timeout  65;
#         #gzip  on;
#         server {
#             listen       80;
#             server_name  localhost;
#             #charset koi8-r;
#             #access_log  logs/host.access.log  main;
#             location / {
#                 proxy_pass http://localhost:3333/;
#             }
#             #error_page  404              /404.html;
#             # redirect server error pages to the static page /50x.html
#             #
#             error_page   500 502 503 504  /50x.html;
#             location = /50x.html {
#                 root   html;
#             }
#         }
#     }
# " > /etc/nginx/nginx.conf.default

# systemctl restart nginx

echo yes | rm /var/lib/cloud/instances/*/sem/config_scripts_user
