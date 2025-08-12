variable "tgw_name" {
  description = "Name tag for the Transit Gateway"
  type        = string
}

variable "common_tags" {
  description = "Tags applied to TGW resources"
  type        = map(string)
  default     = {}
}


