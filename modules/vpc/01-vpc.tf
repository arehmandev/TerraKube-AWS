resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "TerraKubeVPC"
  }
}

#Internet gateway for public access/internet access
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "TerraKubeInternetGateway"
  }
}

# Create the public route tables
resource "aws_route_table" "public1_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "TerraKube Public1 route table"
  }
}

resource "aws_route_table" "public2_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "TerraKube Public2 route table"
  }
}

#Create public routes - links to internet gateway for internet access
resource "aws_route" "public1_route" {
  route_table_id         = "${aws_route_table.public1_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet-gateway.id}"
}

resource "aws_route" "public2_route" {
  route_table_id         = "${aws_route_table.public2_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet-gateway.id}"
}

# Create the private route tables
resource "aws_route_table" "private1_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "Kube Private1 route table"
  }
}

resource "aws_route_table" "private2_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "Kube Private2 route table"
  }
}

# Create private routes - links to NAT gateway for 1 way internet access
resource "aws_route" "private1_route" {
  route_table_id         = "${aws_route_table.private1_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat1.id}"
}

resource "aws_route" "private2_route" {
  route_table_id         = "${aws_route_table.private2_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat2.id}"
}

# Create 2 Elastic IPs for the natgateways
resource "aws_eip" "nat1" {
  vpc        = true
  depends_on = ["aws_internet_gateway.internet-gateway"]
}

resource "aws_eip" "nat2" {
  vpc        = true
  depends_on = ["aws_internet_gateway.internet-gateway"]
}

#Create 2 NAT gateways for each AZ and it will depend on the internet gateway creation
resource "aws_nat_gateway" "nat1" {
  allocation_id = "${aws_eip.nat1.id}"
  subnet_id     = "${aws_subnet.public1.id}"
  depends_on    = ["aws_internet_gateway.internet-gateway"]
}

resource "aws_nat_gateway" "nat2" {
  allocation_id = "${aws_eip.nat2.id}"
  subnet_id     = "${aws_subnet.public2.id}"
  depends_on    = ["aws_internet_gateway.internet-gateway"]
}
