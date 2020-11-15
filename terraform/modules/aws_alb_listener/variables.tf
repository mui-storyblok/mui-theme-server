variable "load_balancer_arn" {
  description = "load_balancer_arn"
}

variable "port" {
  description = "port"
  default     = "443"
}

variable "protocol" {
  description = "protocol"
  default     = "HTTPS"
}

variable "target_group_arn" {
  description = "target_group_arn"
}

variable "type" {
  description = "type"
  default     = "forward"
}
