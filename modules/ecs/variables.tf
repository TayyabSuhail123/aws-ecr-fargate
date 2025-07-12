variable "name" {
  type        = string
  description = "Base name for ECS and IAM resources"
}

variable "container_image_url" {
  type        = string
  description = "ECR image URL for the Fargate container"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "cpu" {
  type    = number
  default = 256
}

variable "memory" {
  type    = number
  default = 512
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the security group"
}

variable "alb_target_group_arn" {
  description = "Target group ARN to attach ECS service to"
  type        = string
}

