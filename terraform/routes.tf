# Route propagation/associations so VPCs can communicate across regions via TGW peering

# Associate Sydney VPC attachment to Sydney TGW route table
resource "aws_ec2_transit_gateway_route_table_association" "syd_assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.syd_vpc_a.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}

# Associate peering attachment to both route tables
resource "aws_ec2_transit_gateway_route_table_association" "syd_peer_assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.syd_to_sg.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}

resource "aws_ec2_transit_gateway_route_table_association" "sg_peer_assoc" {
  provider                       = aws.sg
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.sg_accept.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.sg.id
}

# Associate Singapore VPC attachment to Singapore TGW route table
resource "aws_ec2_transit_gateway_route_table_association" "sg_assoc" {
  provider                       = aws.sg
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.sg_vpc_b.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.sg.id
}

# Routes: each side routes to the opposite VPC CIDR via the peering attachment
resource "aws_ec2_transit_gateway_route" "syd_to_vpc_b" {
  destination_cidr_block         = aws_vpc.vpc_b.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.syd_to_sg.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}

resource "aws_ec2_transit_gateway_route" "sg_to_vpc_a" {
  provider                       = aws.sg
  destination_cidr_block         = aws_vpc.vpc_a.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.sg_accept.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.sg.id
}


