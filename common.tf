provider "aws" {
  region     = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server*"]
  }

  owners = ["099720109477"]
}

data "aws_ami" "haproxy_enterprise" {
  most_recent = true

  filter {
    name = "product-code"
    values = ["483gxnuft87jy44d3q8n4kvt1"]
  }

  filter {
    name = "name"
    values = ["hapee-ubuntu-xenial-amd64-hvm-1.8*"]
  }

  owners = ["aws-marketplace"]
}

resource "aws_vpc" "haproxy_demo" {
  cidr_block           = "192.168.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
}

resource "aws_subnet" "haproxy_demo" {
  vpc_id                  = "${aws_vpc.haproxy_demo.id}"
  cidr_block              = "192.168.0.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "haproxy_demo" {
  vpc_id = "${aws_vpc.haproxy_demo.id}"
}

resource "aws_route_table" "haproxy_demo" {
  vpc_id = "${aws_vpc.haproxy_demo.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.haproxy_demo.id}"
  }
}

resource "aws_route_table_association" "haproxy_demo" {
  route_table_id = "${aws_route_table.haproxy_demo.id}"
  subnet_id      = "${aws_subnet.haproxy_demo.id}"
}

resource "aws_security_group" "haproxy_demo" {
  name        = "haproxy_demo"
  description = "Allow HTTP and SSH"
  vpc_id      = "${aws_vpc.haproxy_demo.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.my_source_ip}/32", "192.168.0.0/24"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.my_source_ip}/32", "192.168.0.0/24"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_source_ip}/32", "192.168.0.0/24"]
  }
}
