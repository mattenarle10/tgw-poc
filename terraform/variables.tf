variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "tgw-poc"
}

variable "environment" {
  description = "Environment name (e.g., poc, dev, prod)"
  type        = string
  default     = "poc"
}

variable "region_primary" {
  description = "Primary AWS region (Sydney)"
  type        = string
  default     = "ap-southeast-2"
}

variable "region_secondary" {
  description = "Secondary AWS region (Singapore)"
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_a_cidr" {
  description = "CIDR block for VPC A (Sydney)"
  type        = string
  default     = "10.10.0.0/16"
}

variable "vpc_b_cidr" {
  description = "CIDR block for VPC B (Singapore)"
  type        = string
  default     = "10.20.0.0/16"
}


