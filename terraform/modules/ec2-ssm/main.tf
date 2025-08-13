terraform { required_providers { aws = { source = "hashicorp/aws" } } }

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  metadata_options { http_tokens = "required" }
  tags = { Name = var.name }
}

output "private_ip" { value = aws_instance.this.private_ip }

