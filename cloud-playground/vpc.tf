
# Internet accessible VPC
resource "aws_vpc" "kata-vpc" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "kata-vpc"
  }
}

# VPC subnets
resource "aws_subnet" "kata-sn-public-1" {
  vpc_id                  = "${aws_vpc.kata-vpc.id}"
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "kata-sn-public-1"
  }
}

resource "aws_subnet" "kata-sn-public-2" {
  vpc_id                  = "${aws_vpc.kata-vpc.id}"
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1b"

  tags = {
    Name = "kata-sn-public-2"
  }
}

resource "aws_subnet" "kata-sn-public-3" {
  vpc_id                  = "${aws_vpc.kata-vpc.id}"
  cidr_block              = "10.1.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1c"

  tags = {
    Name = "kata-sn-public-3"
  }
}

resource "aws_subnet" "kata-sn-private-1" {
  vpc_id                  = "${aws_vpc.kata-vpc.id}"
  cidr_block              = "10.1.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "main-private-1"
  }
}

resource "aws_subnet" "kata-sn-private-2" {
  vpc_id                  = "${aws_vpc.kata-vpc.id}"
  cidr_block              = "10.1.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1b"

  tags = {
    Name = "main-private-2"
  }
}

resource "aws_subnet" "kata-sn-private-3" {
  vpc_id                  = "${aws_vpc.kata-vpc.id}"
  cidr_block              = "10.1.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1c"

  tags = {
    Name = "main-private-3"
  }
}

# Internet GW
resource "aws_internet_gateway" "kata-main-gw" {
  vpc_id = "${aws_vpc.kata-vpc.id}"

  tags = {
    Name = "kata-main-gw"
  }
}

# route tables
resource "aws_route_table" "kata-rt-public" {
  vpc_id = "${aws_vpc.kata-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.kata-main-gw.id}"
  }

  tags = {
    Name = "kata-rt-public"
  }
}

# route associations public
resource "aws_route_table_association" "kata-sn-public-1-a" {
  subnet_id      = "${aws_subnet.kata-sn-public-1.id}"
  route_table_id = "${aws_route_table.kata-rt-public.id}"
}

resource "aws_route_table_association" "kata-sn-public-2-a" {
  subnet_id      = "${aws_subnet.kata-sn-public-2.id}"
  route_table_id = "${aws_route_table.kata-rt-public.id}"
}

resource "aws_route_table_association" "kata-sn-public-3-a" {
  subnet_id      = "${aws_subnet.kata-sn-public-3.id}"
  route_table_id = "${aws_route_table.kata-rt-public.id}"
}