# Step 4: VPC route tables to send inter-VPC traffic to the local TGW
# - Sydney VPC routes 10.20.0.0/16 via Sydney TGW
# - Singapore VPC routes 10.10.0.0/16 via Singapore TGW

# Sydney VPC route table and association
resource "aws_route_table" "syd" {
  vpc_id = module.vpc_a.vpc_id
  tags = {
    Name        = "matt-tgw-poc-syd-rt"
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}

resource "aws_route_table_association" "syd_subnet_assoc" {
  subnet_id      = module.vpc_a.private_subnet_id
  route_table_id = aws_route_table.syd.id
}

resource "aws_route" "syd_to_vpc_b" {
  route_table_id         = aws_route_table.syd.id
  destination_cidr_block = module.vpc_b.vpc_cidr
  transit_gateway_id     = module.tgw_syd.tgw_id
}

# Singapore VPC route table and association
resource "aws_route_table" "sg" {
  provider = aws.sg
  vpc_id   = module.vpc_b.vpc_id
  tags = {
    Name        = "matt-tgw-poc-sg-rt"
    Project     = "matt-tgw-poc"
    Environment = "poc"
  }
}

resource "aws_route_table_association" "sg_subnet_assoc" {
  provider       = aws.sg
  subnet_id      = module.vpc_b.private_subnet_id
  route_table_id = aws_route_table.sg.id
}

resource "aws_route" "sg_to_vpc_a" {
  provider               = aws.sg
  route_table_id         = aws_route_table.sg.id
  destination_cidr_block = module.vpc_a.vpc_cidr
  transit_gateway_id     = module.tgw_sg.tgw_id
}


