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

### security module

variable "iplock" {}

### route53 module

variable "internal-tld" {}

variable "cluster-name" {}

# names of the pem files generated defined when the module is called and the IP settings for CA

variable "capem" {}

variable "cakey" {}

variable "etcdpem" {}

variable "etcdkey" {}

variable "masterpem" {}

variable "masterkey" {}

variable "kubenodepem" {}

variable "kubenodekey" {}

variable "adminpem" {}

variable "adminkey" {}

variable "bucketname" {}

## IAM module

variable "master_role_name" {}

variable "worker_role_name" {}

###### Etcd module

## Launch config
variable "lc_name" {}

variable "coresize" {}

variable "ownerid" {}

variable "ami_name" {}

variable "channel" {}

variable "virtualization_type" {}

## Autoscaling groups

variable "asg_name" {}

variable "asg_number_of_instances" {}

variable "asg_minimum_number_of_instances" {}

## Template variables
variable "cluster-domain" {}

variable "dns-service-ip" {}

variable "hyperkube-image" {}

variable "hyperkube-tag" {}

variable "pod-ip-range" {}

variable "service-cluster-ip-range" {}
