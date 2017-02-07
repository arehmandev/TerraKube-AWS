data "template_file" "kubeetcd" {
  template = "${file("${path.module}/${var.userdata}")}"

  vars {
    internal-tld         = "${ var.internal-tld }"
    region               = "${ var.adminregion }"
    bucket               = "${ var.bucketname }"
    cacertobject         = "${var.capem}"
    etcdcertobject       = "${var.etcdpem}"
    etcdkeyobject        = "${var.etcdkey}"
    etcd_memberlist      = "${join(",", formatlist("%s=https://%s:2380", concat(keys(var.etcd_nodes_az1), keys(var.etcd_nodes_az2), keys(var.etcd_nodes_az3)), concat(values(var.etcd_nodes_az1), values(var.etcd_nodes_az2), values(var.etcd_nodes_az3))))}"
    smilodon_release_md5 = "${var.smilodon_release_md5}"
    smilodon_release_url = "${var.smilodon_release_url}"
    environment          = "${var.environment}"
  }
}

data "aws_ami" "coreos_etcd" {
  most_recent = true

  owners = ["${var.ownerid}"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["${var.virtualization_type}"]
  }

  filter {
    name   = "name"
    values = ["${var.ami_name}-${var.channel}-*"]
  }
}
