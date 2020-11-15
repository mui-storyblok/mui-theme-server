variable "cloudwatch_group_name" {
  description = "cloudwatch_group_name"
  default     = ""
}

variable "retention_in_days" {
  description = "retention_in_days"
  default     = 30
}

variable "cloudwatch_group_tag_name" {
  description = "cloudwatch_group_tag_name"
}

variable "cloudwatch_stream_name" {
  description = "cloudwatch_stream_name"
}