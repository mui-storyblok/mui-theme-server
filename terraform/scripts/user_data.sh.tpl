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
docker run -d $REMOTE/$REPO:latest


echo "
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] \"$request\" '
                      '$status $body_bytes_sent \"$http_referer\" '
                      '\"$http_user_agent\" \"$http_x_forwarded_for\"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        include /etc/nginx/default.d/*.conf;

        location / {
          proxy_pass http://localhost:3333/
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
}
" > /etc/nginx/nginx.conf

systemctl restart nginx

echo yes | rm /var/lib/cloud/instances/*/sem/config_scripts_user
