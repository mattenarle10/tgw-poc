


resource "aws_ec2_transit_gateway_peering_attachment" "euw2_to_euw3" {
  transit_gateway_id      = module.tgw_syd.tgw_id
  peer_transit_gateway_id = module.tgw_sg.tgw_id
  peer_region             = var.region_secondary

  tags = {
    Name        = "matt-tgw-poc-euw2-to-euw3-peering"
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "euw3_accept" {
  provider                      = aws.sg
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.euw2_to_euw3.id

  tags = {
    Name        = "matt-tgw-poc-euw3-accept-peering"
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}


