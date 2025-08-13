terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id = var.tgw_id
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  tags               = merge(var.common_tags, { Name = var.attachment_name })
}

output "attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.this.id
}


