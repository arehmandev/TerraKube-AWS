## Etcd EBS volumes
resource "aws_ebs_volume" "etcd_volumes" {
  count = "${length(var.etcd_nodes)}"

  availability_zone = "${lookup(var.secure_nodes_zones, "node${count.index}_zone")}"
  encrypted         = "${var.secure_data_encrypted}"
  size              = "${var.secure_data_volume}"
  type              = "${var.secure_data_volume_type}"

  tags {
    Role              = "etcd-data"
    Env               = "${var.environment}"
    KubernetesCluster = "${var.environment}"
    Name              = "${var.environment}-etcd-node${count.index}"
    NodeID            = "${count.index}"
  }
}
