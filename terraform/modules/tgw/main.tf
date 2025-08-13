terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_ec2_transit_gateway" "this" {
  description                     = var.tgw_name
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
  tags                            = merge(var.common_tags, { Name = var.tgw_name })
}

resource "aws_ec2_transit_gateway_route_table" "this" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  tags               = merge(var.common_tags, { Name = "${var.tgw_name}-rt" })
}

output "tgw_id" {
  value = aws_ec2_transit_gateway.this.id
}

output "tgw_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.this.id
}


