variable "image_hash" {
  description = "hash for image"
  default     = "latest"
}

variable "db_snapshot" {
  description = "db shapshot name"
  default     = "mui-theme-db"
}

variable "image_ami" {
  description = "base image"
  default     = "ami-0a88f0aa47bb1e604"
}


variable "aws_access_key_id" {
  description = "aws_access_key_id"
}

variable "aws_secret_access_key" {
  description = "aws_secret_access_key"
}

variable "aws_region" {
  description = "aws_region"
}