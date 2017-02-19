### S3 bucket

variable "bucketname" {}

variable "worker-role" {}

### Bucket objects

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

variable "etcdproxykey" {}

variable "etcdproxypem" {}

variable "depends-on" {
  description = "allows module dependency"
}
