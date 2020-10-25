output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.alb_app.id
}

output "alb_main_id" {
  value = aws_alb.alb_main.id
}

output "alb_app_id" {
  value = aws_alb_target_group.alb_app.id
}

output "alb_hostname" {
  value = "http://${aws_alb.alb_main.dns_name}:${var.app_port}/api"
}

output "dns_name" {
  value = aws_alb.alb_main.dns_name
}

output "zone_id" {
  value = aws_alb.alb_main.zone_id
}

output "arn" {
  value = aws_alb.alb_main.arn
}