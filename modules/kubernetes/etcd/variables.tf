### Module etcd

variable "depends-on" {}

# template variables
variable "cluster-domain" {}

variable "cluster-name" {}

variable "dns-service-ip" {}

variable "internal-tld" {}

variable "hyperkube-image" {}

variable "hyperkube-tag" {}

variable "pod-ip-range" {}

variable "service-cluster-ip-range" {}

variable "adminregion" {}

variable "bucketname" {}

variable "cacertobject" {}

variable "etcdcertobject" {}

variable "etcdkeyobject" {}

### ASG variables

variable "lc_name" {}

variable "instance_type" {}

variable "iam_instance_profile" {}

variable "userdata" {}

variable "key_name" {}

variable "ownerid" {}

variable "ami_name" {}

variable "channel" {}

variable "virtualization_type" {}

variable "security_group" {
  description = "The security group the instances to use"
}

variable "asg_name" {}

variable "asg_number_of_instances" {
  description = "The number of instances we want in the ASG"
}

variable "asg_minimum_number_of_instances" {
  description = "The minimum number of instances the ASG should maintain"
  default     = 1
}

variable "health_check_grace_period" {
  description = "Number of seconds for a health check to time out"
  default     = 300
}

variable "health_check_type" {
  default = "EC2"
}

variable "subnet_azs" {
  description = "The VPC subnet IDs"
  type        = "list"

  // comma separated list
}

variable "azs" {
  description = "Availability Zones"
  type        = "list"

  // comma separated list
}
