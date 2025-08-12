# Step 3: Attach each regional VPC to its local TGW
# Why: A TGW VPC attachment must be in the SAME region as the TGW.
# Cross-region connectivity is achieved via TGW peering (added separately).

# Sydney: attach VPC A to the Sydney TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "syd_vpc_a" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = aws_vpc.vpc_a.id
  subnet_ids         = [aws_subnet.vpc_a_private_az1.id]

  tags = {
    Name        = "matt-tgw-poc-syd-vpc-a-attach"
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}

# Singapore: attach VPC B to the Singapore TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "sg_vpc_b" {
  provider           = aws.sg
  transit_gateway_id = aws_ec2_transit_gateway.sg.id
  vpc_id             = aws_vpc.vpc_b.id
  subnet_ids         = [aws_subnet.vpc_b_private_az1.id]

  tags = {
    Name        = "matt-tgw-poc-sg-vpc-b-attach"
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}

output "syd_vpc_a_tgw_attachment_id" {
  value       = aws_ec2_transit_gateway_vpc_attachment.syd_vpc_a.id
  description = "TGW attachment ID for VPC A in Sydney"
}

output "sg_vpc_b_tgw_attachment_id" {
  value       = aws_ec2_transit_gateway_vpc_attachment.sg_vpc_b.id
  description = "TGW attachment ID for VPC B in Singapore"
}


