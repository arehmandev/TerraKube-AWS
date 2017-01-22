resource "aws_security_group_rule" "mastertoetcd" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.kubemaster.id}"
  security_group_id        = "${aws_security_group.etcd.id}"
}

resource "aws_security_group_rule" "etcdtomaster" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.etcd.id}"
  security_group_id        = "${aws_security_group.kubemaster.id}"
}

resource "aws_security_group_rule" "mastertonode" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.kubemaster.id}"
  security_group_id        = "${aws_security_group.kubenode.id}"
}

resource "aws_security_group_rule" "nodetomaster" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.kubenode.id}"
  security_group_id        = "${aws_security_group.kubemaster.id}"
}

resource "aws_security_group_rule" "nodetoetcd" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.kubenode.id}"
  security_group_id        = "${aws_security_group.etcd.id}"
}

resource "aws_security_group_rule" "etcdtonode" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.etcd.id}"
  security_group_id        = "${aws_security_group.kubenode.id}"
}
