resource "aws_alb" "alb_main" {
  name            = var.alb_main_name
  subnets         = var.public_subnets_ids
  security_groups = var.security_groups
  internal        = var.internal
}

resource "aws_alb_target_group" "alb_app" {
  name        = var.alb_target_group
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}
