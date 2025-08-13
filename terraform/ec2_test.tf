locals {
  test_tags = {
    Project     = "matt-tgw-poc"
    Environment = "poc"
    ManagedBy   = "Terraform"
  }
}

# IAM (shared)
module "ssm_iam" {
  source      = "./modules/ssm-iam"
  name_prefix = "matt-tgw-poc"
  tags        = local.test_tags
}

# AMIs
data "aws_ami" "al2023_euw2" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.*-x86_64"]
  }
}

data "aws_ami" "al2023_euw3" {
  provider    = aws.sg
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.*-x86_64"]
  }
}

# SGs for instances (ICMP allowed between VPCs)
resource "aws_security_group" "a" {
  name   = "matt-tgw-poc-a-ec2"
  vpc_id = module.vpc_a.vpc_id
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [module.vpc_b.vpc_cidr]
  }
  tags = local.test_tags
}

resource "aws_security_group" "b" {
  provider = aws.sg
  name     = "matt-tgw-poc-b-ec2"
  vpc_id   = module.vpc_b.vpc_id
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [module.vpc_a.vpc_cidr]
  }
  tags = local.test_tags
}

# VPC Endpoints SGs
resource "aws_security_group" "endpoints_a" {
  name   = "matt-tgw-poc-a-endpoints"
  vpc_id = module.vpc_a.vpc_id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc_a.vpc_cidr]
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.test_tags
}

resource "aws_security_group" "endpoints_b" {
  provider = aws.sg
  name   = "matt-tgw-poc-b-endpoints"
  vpc_id = module.vpc_b.vpc_id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc_b.vpc_cidr]
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.test_tags
}

# Endpoints per VPC (SSM, EC2Messages, SSMMessages)
module "endpoints_a" {
  source            = "./modules/ssm-endpoints"
  vpc_id            = module.vpc_a.vpc_id
  subnet_ids        = [module.vpc_a.private_subnet_id]
  security_group_id = aws_security_group.endpoints_a.id
  region            = var.region_primary
}

module "endpoints_b" {
  source            = "./modules/ssm-endpoints"
  providers         = { aws = aws.sg }
  vpc_id            = module.vpc_b.vpc_id
  subnet_ids        = [module.vpc_b.private_subnet_id]
  security_group_id = aws_security_group.endpoints_b.id
  region            = var.region_secondary
}

# Instances
module "ec2_a" {
  source               = "./modules/ec2-ssm"
  name                 = "matt-tgw-poc-a"
  ami_id               = data.aws_ami.al2023_euw2.id
  subnet_id            = module.vpc_a.private_subnet_id
  security_group_ids   = [aws_security_group.a.id]
  iam_instance_profile = module.ssm_iam.instance_profile_name
  user_data            = <<-EOT
    #!/bin/bash
    echo "Bootstrapping SSM agent check" > /var/log/ssm-bootstrap.log
    systemctl enable amazon-ssm-agent || true
    systemctl restart amazon-ssm-agent || true
  EOT
}

module "ec2_b" {
  source               = "./modules/ec2-ssm"
  providers            = { aws = aws.sg }
  name                 = "matt-tgw-poc-b"
  ami_id               = data.aws_ami.al2023_euw3.id
  subnet_id            = module.vpc_b.private_subnet_id
  security_group_ids   = [aws_security_group.b.id]
  iam_instance_profile = module.ssm_iam.instance_profile_name
  user_data            = <<-EOT
    #!/bin/bash
    echo "Bootstrapping SSM agent check" > /var/log/ssm-bootstrap.log
    systemctl enable amazon-ssm-agent || true
    systemctl restart amazon-ssm-agent || true
  EOT
}

output "ec2_a_private_ip" { value = module.ec2_a.private_ip }
output "ec2_b_private_ip" { value = module.ec2_b.private_ip }


