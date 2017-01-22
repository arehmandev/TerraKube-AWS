variable "elb_name" {
  default = "kube-master"
}

variable "health_check_target" {
  default = "HTTP:2379/health"
}

variable "subnets" {
  type = "list"
}

variable "security_groups" {}
