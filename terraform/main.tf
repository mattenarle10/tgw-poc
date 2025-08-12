locals {
  name_prefix = "matt-tgw-poc"
  tags = {
    Project     = local.name_prefix
    Environment = "poc"
  }
}

# VPC A (Sydney)
resource "aws_vpc" "vpc_a" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(local.tags, { Name = "${local.name_prefix}-vpc-a" })
}

data "aws_availability_zones" "syd" {}

resource "aws_subnet" "vpc_a_private_az1" {
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = data.aws_availability_zones.syd.names[0]
  map_public_ip_on_launch = false
  tags = merge(local.tags, { Name = "${local.name_prefix}-vpc-a-priv-az1" })
}

# VPC B (Singapore)
resource "aws_vpc" "vpc_b" {
  provider              = aws.sg
  cidr_block            = "10.20.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  tags                  = merge(local.tags, { Name = "${local.name_prefix}-vpc-b" })
}

data "aws_availability_zones" "sg" {
  provider = aws.sg
}

resource "aws_subnet" "vpc_b_private_az1" {
  provider                = aws.sg
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = data.aws_availability_zones.sg.names[0]
  map_public_ip_on_launch = false
  tags = merge(local.tags, { Name = "${local.name_prefix}-vpc-b-priv-az1" })
}

output "vpc_a_id" {
  value       = aws_vpc.vpc_a.id
  description = "VPC A ID (Sydney)"
}

output "vpc_b_id" {
  value       = aws_vpc.vpc_b.id
  description = "VPC B ID (Singapore)"
}

locals {
  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Next steps (will be added incrementally):
# - Create VPC A in ap-southeast-2 and VPC B in ap-southeast-1
# - Create Transit Gateway (TGW) in ap-southeast-2
# - Use AWS RAM to share TGW for cross-region attachment
# - Attach both VPCs to TGW and configure routes


