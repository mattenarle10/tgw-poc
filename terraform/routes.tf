# Route propagation/associations so VPCs can communicate across regions via TGW peering

## Rely on default associations for VPC attachments

## Rely on default association for peering attachments as well

## Rely on default associations for VPC attachments

# Routes: each side routes to the opposite VPC CIDR via the peering attachment
resource "aws_ec2_transit_gateway_route" "syd_to_vpc_b" {
  destination_cidr_block         = module.vpc_b.vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.syd_to_sg.id
  transit_gateway_route_table_id = module.tgw_syd.tgw_association_default_rt_id
}

resource "aws_ec2_transit_gateway_route" "sg_to_vpc_a" {
  provider                       = aws.sg
  destination_cidr_block         = module.vpc_a.vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.sg_accept.id
  transit_gateway_route_table_id = module.tgw_sg.tgw_association_default_rt_id
}


