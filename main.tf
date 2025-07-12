data "aws_availability_zones" "available" {}

module "ecr" {
  source = "./modules/ecr"
  name   = "agent-runner"
}

module "network" {
  source             = "./modules/network"
  name               = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zones = data.aws_availability_zones.available.names
}

module "ecs" {
  source               = "./modules/ecs"
  name                 = var.project_name
  aws_region           = var.aws_region
  container_image_url  = "${module.ecr.repository_url}:latest"
  cpu                  = 256
  memory               = 512
  subnet_ids           = module.network.public_subnet_ids
  vpc_id               = module.network.vpc_id
  alb_target_group_arn = module.alb.target_group_arn
}

module "alb" {
  source            = "./modules/alb"
  name              = var.project_name
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  target_group_port = 8000
}
