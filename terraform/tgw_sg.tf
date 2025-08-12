# NOTE: TGW attachments are regional. You cannot attach a Singapore VPC directly to a Sydney TGW.
# For cross-region connectivity, create a TGW in each region and peer them.

locals {
  tgw_sg_name = "matt-tgw-poc-tgw-sg"
}

resource "aws_ec2_transit_gateway" "sg" {
  provider                                   = aws.sg
  description                                = local.tgw_sg_name
  default_route_table_association             = "enable"
  default_route_table_propagation             = "enable"
  dns_support                                = "enable"
  vpn_ecmp_support                            = "enable"

  tags = {
    Name        = local.tgw_sg_name
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}

resource "aws_ec2_transit_gateway_route_table" "sg" {
  provider           = aws.sg
  transit_gateway_id = aws_ec2_transit_gateway.sg.id
  tags = {
    Name        = "matt-tgw-poc-tgw-rt-sg"
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}


