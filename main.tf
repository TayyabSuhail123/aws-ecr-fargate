
module "ecr" {
  source = "./modules/ecr"
  name = "agent-runner"
}

module "network" {
  source = "./modules/network"

  name                 = "agent-runner"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24"]
  availability_zones   = ["eu-central-1a"]
}