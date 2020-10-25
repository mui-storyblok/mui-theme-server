resource "aws_cloudwatch_log_group" "log_group" {
  name              = var.cloudwatch_group_name
  retention_in_days = ceil(var.retention_in_days)

  tags = {
    Name = var.cloudwatch_group_tag_name
  }
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = var.cloudwatch_stream_name
  log_group_name = aws_cloudwatch_log_group.log_group.name
}