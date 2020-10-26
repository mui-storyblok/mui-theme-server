resource "aws_instance" "ec2" {
  key_name                    = var.key_name
  associate_public_ip_address = true
  ami           = var.image_ami
  instance_type = var.instance_type
  subnet_id     = var.subnet
  vpc_security_group_ids = var.security_groups
  
  tags = {
    Name = var.ec2_name
  }
}