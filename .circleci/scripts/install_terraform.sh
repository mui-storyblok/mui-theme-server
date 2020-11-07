#!/bin/sh

set -eux

if [ ! -e terraform/terraform ]; then
  wget https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip
  unzip terraform_0.13.5_linux_amd64.zip -d ~/bin
fi