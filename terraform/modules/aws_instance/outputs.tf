output "public_ip" {
  value = "${aws_instance.ec2.public_ip}"
}

output "private_ip" {
  value = "${aws_instance.ec2.private_ip}"
}

output "id" {
  value = "${aws_instance.ec2.id}"
}
