variable "alb_main_name" {
  description = "alb_main_name"
}

variable "public_subnets_ids" {
  type        = list(string)
  description = "public_subnets_ids"
}

variable "security_groups" {
  type        = list(string)
  description = "security_groups"
}

variable "alb_target_group" {
  description = "alb_target_group"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
}

variable "vpc_id" {
  description = "vpc_id"
}

variable "target_type" {
  description = "protocol"
  default     = "ip"
}

variable "health_check_path" {
  description = "health_check_path"
}

variable "protocol" {
  description = "protocol"
  default     = "HTTP"
}

variable "internal" {
  description = "internal"
  default     = "false"
}