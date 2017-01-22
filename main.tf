provider "aws" {
  region  = "${var.adminregion}"
  profile = "${var.adminprofile}"
}

#1
module "tls" {
  source        = "./modules/tls"
  internal-tld  = "${var.internal-tld}"
  k8s-serviceip = "10.3.0.1"
  adminregion   = "${var.adminregion}"
  capem         = "${var.capem}"
  cakey         = "${var.cakey}"
  etcdpem       = "${var.etcdpem}"
  etcdkey       = "${var.etcdkey}"
  masterpem     = "${var.masterpem}"
  masterkey     = "${var.masterkey}"
  kubenodepem   = "${var.kubenodepem}"
  kubenodekey   = "${var.kubenodekey}"
  adminpem      = "${var.adminpem}"
  adminkey      = "${var.adminkey}"
}

#2
module "vpc" {
  source          = "./modules/vpc"
  adminregion     = "${var.adminregion}"
  key_name        = "${var.key_name}"
  public_key_path = "${var.public_key_path}"
  vpc_cidr        = "${var.vpc_cidr}"
  private1_cidr   = "${var.private1_cidr}"
  private2_cidr   = "${var.private2_cidr}"
  public1_cidr    = "${var.public1_cidr}"
  public2_cidr    = "${var.public2_cidr}"
  subnetaz1       = "${var.subnetaz1}"
  subnetaz2       = "${var.subnetaz2}"
}

#
module "security" {
  source     = "./modules/security"
  depends-on = "${module.vpc.dependency}"
  vpcid      = "${module.vpc.aws_vpc.id}"
  iplock     = "${var.iplock}"
}

module "elbcreate" {
  source          = "./modules/elb/elbcreate"
  security_groups = "${module.security.aws_security_group.etcd}"
  subnets         = ["${module.vpc.aws_subnet.private2.id}", "${module.vpc.aws_subnet.private1.id}"]
}

#3
module "route53" {
  source       = "./modules/route53"
  depends-on   = "${module.vpc.dependency}"
  internal-tld = "${var.internal-tld}"
  vpcid        = "${module.vpc.aws_vpc.id}"
  cluster-name = "${var.cluster-name}"
}

module "iam" {
  source           = "./modules/iam"
  depends-on       = "${module.route53.dependency}"
  kubebucket       = "${var.bucketname}"
  hostedzone       = "${module.route53.internal-zone-id}"
  master_role_name = "${var.master_role_name}"
  worker_role_name = "${var.worker_role_name}"
}

module "s3" {
  source      = "./modules/s3"
  depends-on  = "${module.iam.worker_profile_name}"
  bucketname  = "${var.bucketname}"
  worker-role = "${var.worker_role_name}"
  capem       = "${var.capem}"
  cakey       = "${var.cakey}"
  etcdpem     = "${var.etcdpem}"
  etcdkey     = "${var.etcdkey}"
  masterpem   = "${var.masterpem}"
  masterkey   = "${var.masterkey}"
  kubenodepem = "${var.kubenodepem}"
  kubenodekey = "${var.kubenodekey}"
  adminpem    = "${var.adminpem}"
  adminkey    = "${var.adminkey}"
}

module "etcd" {
  source     = "./modules/kubernetes/etcd"
  depends-on = "${module.s3.dependency}"

  #Template variables
  internal-tld = "${var.internal-tld}"
  adminregion  = "${var.adminregion}"
  bucketname   = "${var.bucketname}"
  capem        = "${var.capem}"
  etcdpem      = "${var.etcdpem}"
  etcdkey      = "${var.etcdkey}"

  lc_name              = "${var.etcdlc_name}"
  ownerid              = "${var.ownerid}"
  ami_name             = "${var.ami_name}"
  channel              = "${var.channel}"
  virtualization_type  = "${var.virtualization_type}"
  instance_type        = "${var.coresize}"
  iam_instance_profile = "${module.iam.worker_profile_name}"
  key_name             = "${var.key_name}"
  security_group       = "${module.security.aws_security_group.etcd}"
  userdata             = "Files/kubeetcd.yml"

  asg_name                        = "${var.etcd_asg_name}"
  asg_number_of_instances         = "${var.etcd_asg_number_of_instances}"
  asg_minimum_number_of_instances = "${var.etcd_asg_minimum_number_of_instances}"

  azs        = ["${lookup(var.subnetaz1, var.adminregion)}", "${lookup(var.subnetaz2, var.adminregion)}"]
  subnet_azs = ["${module.vpc.aws_subnet.private1.id}", "${module.vpc.aws_subnet.private2.id}"]

  # To have the etcd instances in public subnets:

  #subnet_azs = ["${module.vpc.aws_subnet.public1.id}", "${module.vpc.aws_subnet.public2.id}"]
}

module "kubemaster" {
  source     = "./modules/kubernetes/kubemaster"
  depends-on = "${module.s3.dependency}"

  #Template variables
  internal-tld = "${var.internal-tld}"
  adminregion  = "${var.adminregion}"
  bucketname   = "${var.bucketname}"
  capem        = "${var.capem}"
  etcdpem      = "${var.etcdpem}"
  etcdkey      = "${var.etcdkey}"

  lc_name              = "${var.kubemasterlc_name}"
  load_balancer_names  = "${module.elbcreate.elb_name}"
  ownerid              = "${var.ownerid}"
  ami_name             = "${var.ami_name}"
  channel              = "${var.channel}"
  virtualization_type  = "${var.virtualization_type}"
  instance_type        = "${var.coresize}"
  iam_instance_profile = "${module.iam.worker_profile_name}"
  key_name             = "${var.key_name}"
  security_group       = "${module.security.aws_security_group.kubemaster}"
  userdata             = "Files/kubemaster.yml"

  asg_name                        = "${var.kubemaster_asg_name}"
  asg_number_of_instances         = "${var.kubemaster_asg_number_of_instances}"
  asg_minimum_number_of_instances = "${var.kubemaster_asg_minimum_number_of_instances}"

  azs        = ["${lookup(var.subnetaz1, var.adminregion)}", "${lookup(var.subnetaz2, var.adminregion)}"]
  subnet_azs = ["${module.vpc.aws_subnet.private1.id}", "${module.vpc.aws_subnet.private2.id}"]

  # To have the master instances in public subnets:

  #subnet_azs = ["${module.vpc.aws_subnet.public1.id}", "${module.vpc.aws_subnet.public2.id}"]
}

module "kubenode" {
  source = "./modules/kubernetes/kubenode"
}

#module "kubeadmin" {


#  source = "./modules/kubernetes/kubeadmin"


#}

