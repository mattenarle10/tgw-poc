# Routes: each side routes to the opposite VPC CIDR via the peering attachment
resource "aws_ec2_transit_gateway_route" "euw2_to_vpc_b" {
  destination_cidr_block         = module.vpc_b.vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.euw2_to_euw3.id
  transit_gateway_route_table_id = module.tgw_euw2.tgw_association_default_rt_id
}

resource "aws_ec2_transit_gateway_route" "euw3_to_vpc_a" {
  provider                       = aws.sg
  destination_cidr_block         = module.vpc_a.vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.euw3_accept.id
  transit_gateway_route_table_id = module.tgw_euw3.tgw_association_default_rt_id
}
