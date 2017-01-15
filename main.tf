provider "aws" {
  region  = "${var.adminregion}"
  profile = "${var.adminprofile}"
}

module "s3" {
  source = "./modules/s3"
}

module "tls" {
  source = "./modules/tls"
}

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

module "security" {
  depends-on = "module.vpc.dependency"
  source     = "./modules/security"
  vpcid      = "module.VPC.aws_vpc.id"
  iplock     = "${var.iplock}"
}

module "route53" {
  source = "./modules/route53"
}

module "iam" {
  source = "./modules/iam"
}

module "etcd" {
  source = "./modules/kubernetes/etcd"
}

module "kubemaster" {
  source = "./modules/kubernetes/kubemaster"
}

module "kubenode" {
  source = "./modules/kubernetes/kubenode"
}

module "kubeadmin" {
  source = "./modules/kubernetes/kubeadmin"
}
