output "vpc_id" {
  value = aws_vpc.main.id
}
output "aws_eip" {
  value = aws_eip.eip[0].id
}
output "public_ip" {
  value = aws_eip.eip[0].public_ip
}

output "private_ip" {
  value = aws_eip.eip[0].private_ip
}

output "aws_vpc_main_cidr_block" {
  value = aws_vpc.main.cidr_block
}