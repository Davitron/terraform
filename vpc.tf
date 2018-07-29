# Database VPC 

resource "aws_vpc" "checkpoint_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags {
    Name = "db-vpc"
  }
}

# Subnets 

// public eu-west-1a zone
resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.checkpoint_vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1a"

  tags {
    Name = "private-subnet"
  }
}

// Private eu-west-1a zone
resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.checkpoint_vpc.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1a"

  tags {
    Name = "public-subnet"
  }
}

// public eu-west-1b zone
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = "${aws_vpc.checkpoint_vpc.id}"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1b"

  tags {
    Name = "public-subnet-2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "checkpoint-gw" {
  vpc_id = "${aws_vpc.checkpoint_vpc.id}"

  tags {
    Name = "checkpoint-gw"
  }
}

# route tables for public & Private Subnet
resource "aws_route_table" "rt_public_subnet" {
  vpc_id = "${aws_vpc.checkpoint_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.checkpoint-gw.id}"
  }

  tags {
    Name = "route-table-public"
  }
}

resource "aws_route_table" "rt_private_subnet" {
  vpc_id = "${aws_vpc.checkpoint_vpc.id}"

  route {
    instance_id = "${aws_instance.nat_instance.id}"
    cidr_block  = "0.0.0.0/0"
  }

  tags {
    Name = "route-table-private"
  }
}

# Route table association
resource "aws_route_table_association" "cp_public" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.rt_public_subnet.id}"
}

resource "aws_route_table_association" "cp_private" {
  subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.rt_private_subnet.id}"
}
