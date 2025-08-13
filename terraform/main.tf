locals {
  common_tags = {
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}

# VPC A in eu-west-2 (module)
module "vpc_a" {
  source                  = "./modules/vpc"
  resource_name_prefix    = "matt-tgw-poc-euw2"
  cidr_block              = "10.10.0.0/16"
  private_subnet_cidr     = "10.10.1.0/24"
  availability_zone_index = 0
  common_tags             = local.common_tags
}

# VPC B in eu-west-3 (module, aliased provider)
module "vpc_b" {
  source                  = "./modules/vpc"
  providers               = { aws = aws.sg }
  resource_name_prefix    = "matt-tgw-poc-euw3"
  cidr_block              = "10.20.0.0/16"
  private_subnet_cidr     = "10.20.1.0/24"
  availability_zone_index = 0
  common_tags             = local.common_tags
}

# TGW in eu-west-2 (module)
module "tgw_syd" {
  source      = "./modules/tgw"
  tgw_name    = "matt-tgw-poc-tgw-euw2"
  common_tags = local.common_tags
}

# TGW in eu-west-3 (module)
module "tgw_sg" {
  source      = "./modules/tgw"
  providers   = { aws = aws.sg }
  tgw_name    = "matt-tgw-poc-tgw-euw3"
  common_tags = local.common_tags
}

# Attach VPC A to eu-west-2 TGW (module)
module "attach_syd_vpc_a" {
  source          = "./modules/tgw-attach"
  tgw_id          = module.tgw_syd.tgw_id
  vpc_id          = module.vpc_a.vpc_id
  subnet_ids      = [module.vpc_a.private_subnet_id]
  attachment_name = "matt-tgw-poc-euw2-vpc-a-attach"
  common_tags     = local.common_tags
}

# Attach VPC B to eu-west-3 TGW (module)
module "attach_sg_vpc_b" {
  source          = "./modules/tgw-attach"
  providers       = { aws = aws.sg }
  tgw_id          = module.tgw_sg.tgw_id
  vpc_id          = module.vpc_b.vpc_id
  subnet_ids      = [module.vpc_b.private_subnet_id]
  attachment_name = "matt-tgw-poc-euw3-vpc-b-attach"
  common_tags     = local.common_tags
}

output "vpc_a_id" {
  value       = module.vpc_a.vpc_id
  description = "VPC A ID (Sydney)"
}

output "vpc_b_id" {
  value       = module.vpc_b.vpc_id
  description = "VPC B ID (Singapore)"
}
