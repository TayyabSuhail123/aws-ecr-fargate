variable "aws_region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}