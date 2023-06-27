provider "aws" {
}

resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    "Name" = "dev-vpc"
  }
}

resource "aws_internet_gateway" "dev-igw" {
    vpc_id = aws_vpc.dev-vpc.id
    tags = {
    "Name" = "dev-igw"
  }
}

resource "aws_subnet" "dev-public-subnet1" {
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.dev-vpc.id
  map_public_ip_on_launch = true
  tags = {
    "Name" = "dev-public-subnet1"
  }
}

resource "aws_subnet" "dev-public-subnet2" {
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  vpc_id = aws_vpc.dev-vpc.id
  map_public_ip_on_launch = true
  tags = {
    "Name" = "dev-public-subnet2"
  }
}

resource "aws_subnet" "dev-private-subnet1" {
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.dev-vpc.id
  tags = {
    "Name" = "dev-private-subnet1"
  }
}

resource "aws_subnet" "dev-private-subnet2" {
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  vpc_id = aws_vpc.dev-vpc.id
  tags = {
    "Name" = "dev-private-subnet2"
  }
}

resource "aws_eip" "dev-eip1" {
  tags = {
    "Name" = "dev-eip1"
  }
}

resource "aws_eip" "dev-eip2" {
  tags = {
    "Name" = "dev-eip2"
  }
}



