variable "organization" {
  default = "terrakube"
}

# valid for 1000 days
variable "validity_period_hours" {
  default = 24000
}

variable "early_renewal_hours" {
  default = 720
}

variable "is_ca_certificate" {
  default = true
}

variable "common_name" {
  default = "kube-ca"
}

variable "internal-tld" {}

variable "adminregion" {}

variable "k8s-serviceip" {}

# names of the pem files generated defined when the module is called and the IP settings for CA

variable "capem" {
  default = "ca.pem"
}

variable "cakey" {
  default = "cakey.pem"
}

variable "etcdpem" {
  default = "etcd.pem"
}

variable "etcdkey" {
  default = "etcdkey.pem"
}

variable "masterpem" {
  default = "master.pem"
}

variable "masterkey" {
  default = "masterkey.pem"
}

variable "kubenodepem" {
  default = "master.pem"
}

variable "kubenodekey" {
  default = "masterkey.pem"
}
