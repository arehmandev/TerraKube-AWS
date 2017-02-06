data "template_file" "kubeetcd" {
  template = "${file("${path.module}/${var.userdata}")}"

  vars {
    internal-tld   = "${ var.internal-tld }"
    region         = "${ var.adminregion }"
    bucket         = "${ var.bucketname }"
    cacertobject   = "${var.capem}"
    etcdcertobject = "${var.etcdpem}"
    etcdkeyobject  = "${var.etcdkey}"
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
