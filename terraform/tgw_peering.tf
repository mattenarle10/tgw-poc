# Cross-region connectivity between TGWs (Sydney ↔ Singapore)
# This enables traffic between VPC A and VPC B via their regional TGWs.

resource "aws_ec2_transit_gateway_peering_attachment" "syd_to_sg" {
  transit_gateway_id      = aws_ec2_transit_gateway.this.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.sg.id
  peer_region             = var.region_secondary

  tags = {
    Name        = "matt-tgw-poc-syd-to-sg-peering"
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "sg_accept" {
  provider                          = aws.sg
  transit_gateway_attachment_id     = aws_ec2_transit_gateway_peering_attachment.syd_to_sg.id

  tags = {
    Name        = "matt-tgw-poc-sg-accept-peering"
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}


