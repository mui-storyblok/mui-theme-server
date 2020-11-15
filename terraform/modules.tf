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
  name = "mui-theme-server"
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

###############################################################################
############################## AWS ECR  ###################################
###############################################################################

resource "aws_ecr_repository" "image" {
  name                 = "mui-theme-server"
}

################################################################################
#################################### aws_instance EC2  ##############################
################################################################################

module "aws_instance_security" {
  source              = "./modules/security"
  name                = "aws-instance-security-group"
  vpc_id              = module.network.vpc_id
  protocol            = "tcp"
  ingress_from_port   = 22
  ingress_to_port     = 22
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_from_port    = 0
  egress_to_port      = 0
  egress_cidr_blocks  = ["0.0.0.0/0"]
}


module "aws_instance_http_security" {
  source              = "./modules/security"
  name                = "aws-instance-http-security-group"
  vpc_id              = module.network.vpc_id
  protocol            = "tcp"
  ingress_from_port   = 80
  ingress_to_port     = 80
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_from_port    = 0
  egress_to_port      = 0
  egress_cidr_blocks  = ["0.0.0.0/0"]
}

data "template_file" "app" {
  template = file("./scripts/user_data.sh.tpl")

  vars = {
    aws_access_key_id      = var.aws_access_key_id
    aws_secret_access_key    = var.aws_secret_access_key
    aws_region = var.aws_region
  }
}

module "aws_instance" {
  source           = "./modules/aws_instance"
  key_name         = "mui-theme-server"
  image_ami        = var.image_ami
  instance_type    = "t2.micro"
  security_groups  = [
                    module.aws_instance_security.aws_security_group_id,
                    module.aws_instance_http_security.aws_security_group_id
                    ]
  subnet           = element(tolist(data.aws_subnet_ids.public_subnets.ids), 0)
  ec2_name         = "aws_instance"
  user_data        = data.template_file.app.rendered
}

################################################################################
#################################### RDS  ######################################
################################################################################

module "rds_security" {
  source              = "./modules/security"
  name                = "rds-security-group-mui-theme-server"
  vpc_id              = module.network.vpc_id
  protocol            = "tcp"
  ingress_from_port   = 5432
  ingress_to_port     = 5432
  ingress_cidr_blocks = []
  egress_from_port    = 0
  egress_to_port      = 0
  egress_cidr_blocks  = ["0.0.0.0/0"]
  security_groups     = [
                          module.aws_instance_security.aws_security_group_id, 
                          module.aws_instance_http_security.aws_security_group_id
                        ]
}

module "rds" {
  source                   = "./modules/rds"
  name                     = "db-mui-theme-servers"
  snapshot_identifier_name = var.db_snapshot
  public_subnets_ids       = data.aws_subnet_ids.public_subnets.ids
  vpc_security_group_ids   = [module.rds_security.aws_security_group_id]
  instance_class           = "db.t2.micro"
}
