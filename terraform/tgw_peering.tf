# Cross-region connectivity between TGWs (Sydney ↔ Singapore)
# This enables traffic between VPC A and VPC B via their regional TGWs.

resource "aws_ec2_transit_gateway_peering_attachment" "syd_to_sg" {
  transit_gateway_id      = module.tgw_syd.tgw_id
  peer_transit_gateway_id = module.tgw_sg.tgw_id
  peer_region             = var.region_secondary

  tags = {
    Name        = "matt-tgw-poc-euw2-to-euw3-peering"
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "sg_accept" {
  provider                      = aws.sg
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.syd_to_sg.id

  tags = {
    Name        = "matt-tgw-poc-euw3-accept-peering"
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}


