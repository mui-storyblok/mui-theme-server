variable "cluster_name" {
  description = "name of cluster"
}

variable "container_name" {
  description = "name of container"
}

variable "template_path" {
  description = "template_path"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
}

variable "awslogs_group" {
  description = "awslogs_group"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-west-2"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
}

variable "hash" {
  description = "tag for ecr"
  default     = "latest"
}

variable "task_family" {
  description = "family of task"
}

variable "ecs_task_execution_role" {
  description = "Role arn for the ecsTaskExecutionRole"
}

variable "service_name" {
  description = "name of service"
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 2
}

variable "security_groups" {
  type        = list(string)
  description = "sg_lb_ecs_tasks_dev_id"
}

variable "private_subnets_ids" {
   type        = list(string)
  description  = "private_subnets_ids"
}

variable "aws_alb_target_group_arn" {
  description = "aws_alb_target_group_arn"
}