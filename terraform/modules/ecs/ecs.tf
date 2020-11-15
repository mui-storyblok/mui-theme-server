resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

data "template_file" "app" {
  template = file(var.template_path)

  vars = {
    app_image      = var.app_image
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    container_name = var.container_name
    awslogs_group  = var.awslogs_group
    aws_region     = var.aws_region
    app_port       = var.app_port
    hash           = var.hash
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = var.task_family
  execution_role_arn       = var.ecs_task_execution_role
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.app.rendered
}

resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = var.security_groups
    subnets          = var.private_subnets_ids
    assign_public_ip = true
  }

    load_balancer {
      target_group_arn = var.aws_alb_target_group_arn
      container_name   = var.container_name
      container_port   = var.app_port
    }

}
