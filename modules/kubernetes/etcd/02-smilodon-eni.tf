## Etcd ENI Interfaces
resource "aws_network_interface" "etcd_eni" {
  count = "${length(var.etcd_nodes)}"

  private_ips       = ["${lookup(var.etcd_nodes, "node${count.index}")}"]
  security_groups   = ["${var.secure_sg}"]
  source_dest_check = false
  subnet_id         = "${lookup(var.secure_subnets, lookup(var.secure_nodes_zones, "node${count.index}_zone"))}"

  tags {
    Env     = "${var.environment}"
    Name    = "${var.environment}-etcd-data"
    NodeID  = "${count.index}"
    Role    = "etcd-eni"
    Service = "etcd"
  }
}
