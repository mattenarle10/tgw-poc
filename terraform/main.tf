locals {
  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Next steps (will be added incrementally):
# - Create VPC A in ap-southeast-2 and VPC B in ap-southeast-1
# - Create Transit Gateway (TGW) in ap-southeast-2
# - Use AWS RAM to share TGW for cross-region attachment
# - Attach both VPCs to TGW and configure routes


