terraform {
  backend "s3" {
    bucket = "aspecta-rudy-test10"
    key = "terraform.tfstate"
    region = "eu-central-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-057fa5aaedee74437"
  instance_type = "t2.micro"
  key_name= "aws_key"
  vpc_security_group_ids = [aws_security_group.main.id]
  
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("/home/rahul/Jhooq/keys/aws/aws_key")
    timeout     = "4m"
  }
  tags = {
    Name = "Rudy"
  }
}

data "aws_vpc" "selected" {
  id = "vpc-06452ea7aaa30459d"
}

data "aws_subnet_ids" "default_subnet" {
  vpc_id = data.aws_vpc.selected.id
}

resource "aws_security_group" "main" {
  name = "instance-security-group"
  egress = [
  {
    cidr_blocks      = [ "0.0.0.0/0", ]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
  ingress                = [
  {
    cidr_blocks      = [ "0.0.0.0/0", ]
    description      = ""
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
  }]
}

resource "aws_key_pair" "deployer" {
  key_name = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDD0uB3a0sQECOP3uOvHvXsOpmZxvS3E6vxVZdKFd/S11dVzQW/HukojpVQYDo18OWklSTsExOfHL0i152bRpHwvedE6PghLvge+ATeo6+Ns74lnzcdhEaK5xZ26tLJyIN7qGtK7uVz+HH3+lP043YgTmyvSfpvkiBkPHv0H6pxD7VrEgdlgl7m/2PXeNTzZCeCzX9QSJcv7u53yIdLGQWURA9mDfXE8umssS4zOZwl9Wv74bl2Jidm3sBU8OUQdSX7Njx7pZOTdDiRnbra5JhVvsiQrttp/Gig7Y01BfuMqgF+A0mg9oZNjulA4fiYPv8JwcXHn26KrxmxDEmHhLqJ rudy@Martins-MacBook-Pro.local"
}
