### Provider
variable "adminregion" {}

variable "adminprofile" {}

variable "key_name" {}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

### VPC module

#VPC Networking
variable "vpc_cidr" {}

# 2 Private CIDRs
variable "private1_cidr" {}

variable "private2_cidr" {}

# 2 Public CIDRs
variable "public1_cidr" {}

variable "public2_cidr" {}

# Subnet Availability zones

variable "subnetaz1" {
  type = "map"
}

variable "subnetaz2" {
  type = "map"
}

### SG module

variable "iplock" {}
