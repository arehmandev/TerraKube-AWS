provider "aws" {
  region  = "${var.adminregion}"
  profile = "${var.adminprofile}"
}

#1
module "tls" {
  source         = "./modules/tls"
  internal-tld   = "${var.internal-tld}"
  k8s-serviceip  = "${var.k8s-serviceip}"
  adminregion    = "${var.adminregion}"
  capem          = "${var.capem}"
  cakey          = "${var.cakey}"
  etcdpem        = "${var.etcdpem}"
  etcdkey        = "${var.etcdkey}"
  masterpem      = "${var.masterpem}"
  masterkey      = "${var.masterkey}"
  kubenodepem    = "${var.kubenodepem}"
  kubenodekey    = "${var.kubenodekey}"
  adminpem       = "${var.adminpem}"
  adminkey       = "${var.adminkey}"
  etcd_nodes_az1 = "${var.etcd_nodes_az1}"
  etcd_nodes_az2 = "${var.etcd_nodes_az2}"
  etcd_nodes_az3 = "${var.etcd_nodes_az3}"
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
  private3_cidr   = "${var.private3_cidr}"
  public1_cidr    = "${var.public1_cidr}"
  public2_cidr    = "${var.public2_cidr}"
  public3_cidr    = "${var.public3_cidr}"
  subnetaz1       = "${var.subnetaz1}"
  subnetaz2       = "${var.subnetaz2}"
  subnetaz3       = "${var.subnetaz3}"
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
  security_groups = "${module.security.aws_security_group.kubemaster}"
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
  zonename     = "${module.route53.internal-zone-id}"

  etcd_nodes_az1 = "${var.etcd_nodes_az1}"
  etcd_nodes_az2 = "${var.etcd_nodes_az2}"
  etcd_nodes_az3 = "${var.etcd_nodes_az3}"

  lc_name              = "${var.etcdlc_name}"
  ownerid              = "${var.ownerid}"
  ami_name             = "${var.ami_name}"
  channel              = "${var.channel}"
  virtualization_type  = "${var.virtualization_type}"
  instance_type        = "${var.coresize}"
  iam_instance_profile = "${module.iam.master_profile_name}"
  key_name             = "${var.key_name}"
  security_group       = "${module.security.aws_security_group.etcd}"
  userdata             = "Files/kubeetcd.yml"

  asg_name_az1     = "${var.etcd_asg_name_az1}"
  asg_maxsize_az1  = "${var.etcd_asg_maxsize_az1}"
  asg_minsize_az1  = "${var.etcd_asg_minsize_az1}"
  asg_normsize_az1 = "${var.etcd_asg_normsize_az1}"

  asg_name_az2     = "${var.etcd_asg_name_az2}"
  asg_maxsize_az2  = "${var.etcd_asg_maxsize_az2}"
  asg_minsize_az2  = "${var.etcd_asg_minsize_az2}"
  asg_normsize_az2 = "${var.etcd_asg_normsize_az2}"

  asg_name_az3     = "${var.etcd_asg_name_az3}"
  asg_maxsize_az3  = "${var.etcd_asg_maxsize_az3}"
  asg_minsize_az3  = "${var.etcd_asg_minsize_az3}"
  asg_normsize_az3 = "${var.etcd_asg_normsize_az3}"

  subnet_in_az1 = "${module.vpc.aws_subnet.private1.id}"
  subnet_in_az2 = "${module.vpc.aws_subnet.private2.id}"
  subnet_in_az3 = "${module.vpc.aws_subnet.private3.id}"

  az1 = "${lookup(var.subnetaz1, var.adminregion)}"
  az2 = "${lookup(var.subnetaz2, var.adminregion)}"
  az3 = "${lookup(var.subnetaz3, var.adminregion)}"
}

module "etcdbastion" {
  source = "./modules/kubernetes/etcd-bastion"

  #Template variables
  adminregion    = "${var.adminregion}"
  internal-tld   = "${var.internal-tld}"
  adminregion    = "${var.adminregion}"
  bucketname     = "${var.bucketname}"
  capem          = "${var.capem}"
  etcdpem        = "${var.etcdpem}"
  etcdkey        = "${var.etcdkey}"
  etcd_nodes_az1 = "${var.etcd_nodes_az1}"
  etcd_nodes_az2 = "${var.etcd_nodes_az2}"
  etcd_nodes_az3 = "${var.etcd_nodes_az3}"

  lc_name              = "${var.bastion_lc_name}"
  ownerid              = "${var.ownerid}"
  ami_name             = "${var.ami_name}"
  channel              = "${var.channel}"
  virtualization_type  = "${var.virtualization_type}"
  instance_type        = "${var.coresize}"
  iam_instance_profile = "${module.iam.worker_profile_name}"
  key_name             = "${var.key_name}"
  security_group       = "${module.security.aws_security_group.bastion}"
  userdata             = "Files/bastion.yml"

  asg_name                        = "${var.bastion_asg_name}"
  asg_number_of_instances         = "${var.bastion_asg_number_of_instances}"
  asg_minimum_number_of_instances = "${var.bastion_asg_minimum_number_of_instances}"

  azs        = ["${lookup(var.subnetaz1, var.adminregion)}", "${lookup(var.subnetaz2, var.adminregion)}", "${lookup(var.subnetaz3, var.adminregion)}"]
  subnet_azs = ["${module.vpc.aws_subnet.public1.id}", "${module.vpc.aws_subnet.public2.id}", "${module.vpc.aws_subnet.public3.id}"]

  # The etcd bastion(s) is spread between the public subnets
}
