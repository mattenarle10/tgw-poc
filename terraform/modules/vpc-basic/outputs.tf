output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}


