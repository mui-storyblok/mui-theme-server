variable "name" {
  description = "name"
}

variable "vpc_id" {
  description = "vpc_id"
}

variable "protocol" {
}

variable "ingress_from_port" {
}

variable "ingress_to_port" {
}

variable "ingress_cidr_blocks" {
  type    = list(string) 
  default = []
}

variable "security_groups" {
  type        = list(string)
  description = "security_groups"
  default = []
}

variable "egress_from_port" {
}

variable "egress_to_port" {
}

variable "egress_cidr_blocks" {
  type        = list(string)
}
