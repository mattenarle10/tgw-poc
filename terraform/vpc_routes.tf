# Step 4: VPC route tables to send inter-VPC traffic to the local TGW
# - eu-west-2 VPC routes 10.20.0.0/16 via eu-west-2 TGW
# - eu-west-3 VPC routes 10.10.0.0/16 via eu-west-3 TGW

# eu-west-2 VPC rt
resource "aws_route_table" "syd" {
  vpc_id = module.vpc_a.vpc_id
  tags = {
    Name        = "matt-tgw-poc-euw2-rt"
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}

resource "aws_route_table_association" "syd_subnet_assoc" {
  subnet_id      = module.vpc_a.private_subnet_id
  route_table_id = aws_route_table.syd.id
}

resource "aws_route" "euw2_to_vpc_b" {
  route_table_id         = aws_route_table.syd.id
  destination_cidr_block = module.vpc_b.vpc_cidr
  transit_gateway_id     = module.tgw_euw2.tgw_id
}

# eu-west-3 VPC rt
resource "aws_route_table" "sg" {
  provider = aws.sg
  vpc_id   = module.vpc_b.vpc_id
  tags = {
    Name        = "matt-tgw-poc-euw3-rt"
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}

resource "aws_route_table_association" "sg_subnet_assoc" {
  provider       = aws.sg
  subnet_id      = module.vpc_b.private_subnet_id
  route_table_id = aws_route_table.sg.id
}

resource "aws_route" "euw3_to_vpc_a" {
  provider               = aws.sg
  route_table_id         = aws_route_table.sg.id
  destination_cidr_block = module.vpc_a.vpc_cidr
  transit_gateway_id     = module.tgw_euw3.tgw_id
}


