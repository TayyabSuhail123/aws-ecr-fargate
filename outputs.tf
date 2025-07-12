output "ecr_url" {
  value = module.ecr.repository_url
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "alb_url" {
  value = module.alb.alb_dns
}