variable "name" {
  description = "Base name used for ALB resources (e.g., alb, target group, SG)"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the ALB and target group should be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB to use"
  type        = list(string)
}

variable "target_group_port" {
  description = "Port on which the target group forwards traffic to Fargate tasks"
  type        = number
  default     = 8000
}
