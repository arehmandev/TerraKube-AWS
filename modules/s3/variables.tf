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

variable "service-cluster-ip-range" {}

variable "etcd_nodes_az1" {
  type = "map"
}

variable "etcd_nodes_az2" {
  type = "map"
}

variable "etcd_nodes_az3" {
  type = "map"
}
