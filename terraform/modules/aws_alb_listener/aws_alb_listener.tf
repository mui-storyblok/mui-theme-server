resource "aws_alb_listener" "listener" {
	load_balancer_arn	=	var.load_balancer_arn
	port			    		=	var.port
	protocol		    =	var.protocol

	default_action {
    target_group_arn	=	var.target_group_arn
		type			=	var.type
	}
}
