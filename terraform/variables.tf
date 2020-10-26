variable "image_hash" {
  description = "hash for image"
  default     = "latest"
}

variable "db_snapshot" {
  description = "db shapshot name"
  default     = "mui-theme-db-snapshot"
}

variable "image_ami" {
  description = "base image"
  default     = "ami-0a88f0aa47bb1e604"
}