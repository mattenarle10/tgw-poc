terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }

  required_version = ">= 1.2.0"
}

variable "region_primary" {
  description = "Primary AWS region (eu-west-2)"
  type        = string
  default     = "eu-west-2"
}

variable "region_secondary" {
  description = "Secondary AWS region (eu-west-3)"
  type        = string
  default     = "eu-west-3"
}

provider "aws" {
  region = var.region_primary

  default_tags {
    tags = {
      Project     = "TerraformPractice"
      Environment = "Dev"
      ManagedBy   = "Terraform"
    }
  }
}

provider "aws" {
  alias  = "sg"
  region = var.region_secondary

  default_tags {
    tags = {
      Project     = "TerraformPractice"
      Environment = "Dev"
      ManagedBy   = "Terraform"
    }
  }
}


