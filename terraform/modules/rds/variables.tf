variable "public_subnets_ids" {
  type         = list(string)
  description  = "public_subnets_ids"
}

variable "snapshot_identifier_name" {
  description = "snapshot_identifier for the database"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "vpc_security_group_ids"
}

variable "instance_class" {
  description = "instance_class"
  default     = "db.t2.medium"
}

variable "records" {
  type        = list(string)
  default     = []
}

variable "name" {
  description = "db name"
}