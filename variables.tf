variable "aws_region" {
  description = "AWS region"
  default     = "us-east-2"
}

variable "aws_instance_type" {
  description = "AWS instance type for nodes"
  default     = "t3.nano"
}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "ssh_keypair_name" {
  default = "haproxy_demo"
}

variable "my_source_ip" {}