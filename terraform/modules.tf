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

################################################################################
############################### ALB ############################################
################################################################################

module "alb_security" {
  source              = "./modules/security"
  name                = "alb-theme-server"
  vpc_id              = module.network.vpc_id
  protocol            = "tcp"
  ingress_from_port   = 80
  ingress_to_port     = 80
  ingress_cidr_blocks = ["0.0.0.0/0"]
  security_groups     = []
  egress_from_port    = 0
  egress_to_port      = 0
  egress_cidr_blocks  = ["0.0.0.0/0"]
}

module "alb" {
  source             = "./modules/alb"
  alb_main_name      = "alb-theme-server"
  public_subnets_ids = data.aws_subnet_ids.public_subnets.ids
  security_groups    = [module.alb_security.aws_security_group_id]
  alb_target_group   = "target-group-theme-server"
  app_port           = 3333
  vpc_id             = module.network.vpc_id
  health_check_path  = "/api/v1/ping"
}

module "aws_alb_listener_api" {
  source            = "./modules/aws_alb_listener"
  load_balancer_arn = module.alb.arn
  target_group_arn  = module.alb.aws_alb_target_group_arn
  protocol          = "HTTP"
}
