variable "security_groups" {
  description = "Id of security group allowing internal traffic"
  type        = "list"
}
variable "subnet" {
  description = "subnet to build ec2 in"
}

variable "image_ami" {
  description = "image_ami"
}

variable "key_name" {
  description = "key_name for aws_key_pair"
}

variable "ec2_name" {
  description = "ec2_name for aws_key_pair"
}

variable "instance_type" {
  description = "size of ec2"
  default = "t2.micro"
}

variable "user_data" {
  description = ""
  
}