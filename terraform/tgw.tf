locals {
  tgw_name = "matt-tgw-poc-tgw"
}

resource "aws_ec2_transit_gateway" "this" {
  description                               = local.tgw_name
  default_route_table_association            = "enable"
  default_route_table_propagation            = "enable"
  dns_support                               = "enable"
  vpn_ecmp_support                           = "enable"

  tags = {
    Name        = local.tgw_name
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}

resource "aws_ec2_transit_gateway_route_table" "this" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  tags = {
    Name        = "matt-tgw-poc-tgw-rt"
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}


