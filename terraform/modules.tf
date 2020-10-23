################################################################################
############################### SETUP ##########################################
################################################################################

# Specify the provider and access details
provider "aws" {
  version = "~> 2.15.0"

  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "alex_aws"
  region                  = "us-west-2"
}

################################################################################
############################### AWS S3 BACKEND #################################
################################################################################

terraform {
  backend "s3" {
    bucket = "mui-theme-server-terraform-state"
    key    = "terraformstate"
    region = "us-west-2"
  }
}

################################################################################
############################### NETWORK ########################################
################################################################################

module "network" {
  source   = "./modules/network"
  az_count = 3
  vpc_name = "mui-theme-vpc"
}

data "aws_subnet_ids" "public_subnets" {
  vpc_id = module.network.vpc_id
  tags = {
    Tier = "Public"
  }
}

data "aws_subnet_ids" "private_subnets" {
  vpc_id = module.network.vpc_id

  tags = {
    Tier = "Private"
  }
}