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

provider "aws" {
  region = var.region_primary
}

provider "aws" {
  alias  = "sg"
  region = var.region_secondary
}


