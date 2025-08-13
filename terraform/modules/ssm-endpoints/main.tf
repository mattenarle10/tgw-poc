terraform {
  required_providers { aws = { source = "hashicorp/aws" } }
}

locals {
  services = [
    "ssm",
    "ssmmessages",
    "ec2messages",
  ]
}

resource "aws_vpc_endpoint" "this" {
  for_each            = toset(local.services)
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.${each.value}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.subnet_ids
  security_group_ids  = [var.security_group_id]
}


