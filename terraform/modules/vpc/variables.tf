variable "resource_name_prefix" {
  description = "Name prefix for all VPC resources (e.g., matt-tgw-poc-syd)"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC (e.g., 10.10.0.0/16)"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for a single private subnet (e.g., 10.10.1.0/24)"
  type        = string
}

variable "availability_zone_index" {
  description = "Index into the region's availability zones to place the subnet"
  type        = number
  default     = 0
}

variable "common_tags" {
  description = "Tags applied to all created resources"
  type        = map(string)
  default     = {}
}


