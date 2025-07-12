project_name = "agent-runner"
aws_region   = "eu-central-1"
ecs_cpu      = 256
ecs_memory   = 512

vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
