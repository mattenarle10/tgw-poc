provider "aws" {
  region = var.region_primary
}

provider "aws" {
  alias  = "sg"
  region = var.region_secondary
}


