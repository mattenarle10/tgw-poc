variable "tgw_id" {
  description = "Transit Gateway ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to attach"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the attachment"
  type        = list(string)
}

variable "attachment_name" {
  description = "Name for the TGW VPC attachment"
  type        = string
}

variable "common_tags" {
  description = "Tags applied to attachment"
  type        = map(string)
  default     = {}
}


