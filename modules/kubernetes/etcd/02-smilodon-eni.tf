## Etcd ENI Interfaces
resource "aws_network_interface" "etcd_eni_az1" {
  count = "${var.asg_maxsize_az1}"

  private_ips       = ["${lookup(var.etcd_nodes_az1, "node${count.index}")}"]
  security_groups   = ["${var.security_group}"]
  source_dest_check = false
  subnet_id         = "${var.subnet_in_az1}"

  tags {
    Env     = "${var.environment}"
    Name    = "${var.environment}-etcd-data"
    NodeID  = "${count.index}"
    Role    = "etcd-eni"
    Service = "etcd"
  }
}

## Etcd ENI Interfaces
resource "aws_network_interface" "etcd_eni_az2" {
  count = "${var.asg_maxsize_az2}"

  private_ips       = ["${lookup(var.etcd_nodes_az2, "node${count.index}")}"]
  security_groups   = ["${var.security_group}"]
  source_dest_check = false
  subnet_id         = "${var.subnet_in_az2}"

  tags {
    Env     = "${var.environment}"
    Name    = "${var.environment}-etcd-data"
    NodeID  = "${count.index} + ${aws_network_interface.etcd_eni_az1.count}"
    Role    = "etcd-eni"
    Service = "etcd"
  }
}

## Etcd ENI Interfaces
resource "aws_network_interface" "etcd_eni_az3" {
  count = "${var.asg_maxsize_az3}"

  private_ips       = ["${lookup(var.etcd_nodes_az3, "node${count.index}")}"]
  security_groups   = ["${var.security_group}"]
  source_dest_check = false
  subnet_id         = "${var.subnet_in_az3}"

  tags {
    Env     = "${var.environment}"
    Name    = "${var.environment}-etcd-data"
    NodeID  = "${count.index} + ${aws_network_interface.etcd_eni_az1.count} + ${aws_network_interface.etcd_eni_az2.count}"
    Role    = "etcd-eni"
    Service = "etcd"
  }
}
