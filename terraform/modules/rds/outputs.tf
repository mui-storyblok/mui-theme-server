output "db_endpoint" {
  value = "${aws_db_instance.db.endpoint}"
}

output "hosted_zone_id" {
  value = "${aws_db_instance.db.hosted_zone_id}"
}

output "address" {
  value = "${aws_db_instance.db.address}"
}
