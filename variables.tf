variable "aws_region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "ecs_cpu" {
  type        = number
  default     = 256
  description = "Fargate CPU units"
}

variable "ecs_memory" {
  type        = number
  default     = 512
  description = "Fargate memory in MiB"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
}


