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

###############################################################################
############################## AWS ECR  ###################################
###############################################################################

resource "aws_ecr_repository" "image" {
  name                 = "mui-theme-server"
}

###############################################################################
############################## ECS security ###################################
###############################################################################

module "ecs_security" {
  source              = "./modules/security"
  name                = "theme-server-security"
  vpc_id              = module.network.vpc_id
  protocol            = "tcp"
  ingress_from_port   = 3333
  ingress_to_port     = 3333
  ingress_cidr_blocks = []
  egress_from_port    = 0
  egress_to_port      = 0
  egress_cidr_blocks  = ["0.0.0.0/0"]
  security_groups     = [module.alb_security.aws_security_group_id]
}

###############################################################################
############################## ECS ############################################
###############################################################################

module "ecs" {
  source                   = "./modules/ecs"
  cluster_name             = "mui-theme-server"
  template_path            = "templates/ecs_template.json.tpl"
  app_image                = aws_ecr_repository.image.repository_url
  app_port                 = 3333
  task_family              = "mui-theme-server"
  ecs_task_execution_role  = "arn:aws:iam::413774799288:role/ecsTaskExecutionRole"
  service_name             = "mui-theme-server"
  security_groups          = [module.ecs_security.aws_security_group_id]
  private_subnets_ids      = data.aws_subnet_ids.private_subnets.ids
  aws_alb_target_group_arn = module.alb.aws_alb_target_group_arn
  container_name           = "mui-theme-server"
  awslogs_group            = "/ecs/mui-theme-server"
  hash                     = var.image_hash
  fargate_cpu              = "256"
  fargate_memory           = "512"
}

module "logs" {
  source                    = "./modules/logs"
  cloudwatch_group_name     = "/ecs/mui-theme-server"
  cloudwatch_group_tag_name = "mui-theme-server-log-group"
  cloudwatch_stream_name    = "mui-theme-server-log-stream"
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

module "aws_instance" {
  source           = "./modules/aws_instance"
  key_name         = "mui-theme-server"
  image_ami        = var.image_ami
  instance_type    = "t2.micro"
  security_groups  = [module.aws_instance_security.aws_security_group_id]
  subnet           = element(tolist(data.aws_subnet_ids.public_subnets.ids), 0)
  ec2_name         = "aws_instance"
}

################################################################################
#################################### RDS  ######################################
################################################################################

module "rds_security" {
  source              = "./modules/security"
  name                = "rds-ecs-security-group-mui-theme-server"
  vpc_id              = module.network.vpc_id
  protocol            = "tcp"
  ingress_from_port   = 5432
  ingress_to_port     = 5432
  ingress_cidr_blocks = []
  egress_from_port    = 0
  egress_to_port      = 0
  egress_cidr_blocks  = ["0.0.0.0/0"]
  security_groups     = [
                          module.ecs_security.aws_security_group_id, 
                          module.aws_instance_security.aws_security_group_id, 
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