#!/bin/sh

GIT_HASH="$(git rev-parse HEAD)"
export TF_VAR_image_hash=${GIT_HASH}

cd ./terraform
terraform init .
terraform plan -out=tfplan -input=false .
terraform apply -input=false tfplan 