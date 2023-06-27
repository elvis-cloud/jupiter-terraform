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

resource "aws_nat_gateway" "dev-ngw1" {
  allocation_id = aws_eip.dev-eip1.id
  subnet_id = aws_subnet.dev-public-subnet1.id

  tags = {
    "Name" = "dev-ngw1"
  }
  depends_on = [ aws_internet_gateway.dev-igw ]
}

resource "aws_nat_gateway" "dev-ngw2" {
  allocation_id = aws_eip.dev-eip2.id
  subnet_id = aws_subnet.dev-public-subnet2.id

  tags = {
    "Name" = "dev-ngw2"
  }
  depends_on = [ aws_internet_gateway.dev-igw ]
}

resource "aws_route_table" "dev-public-rt" {
  vpc_id = aws_vpc.dev-vpc.id
  tags = {
    "Name" = "dev-public-rt"
  }
}

resource "aws_route" "public-internet-route" {
  route_table_id = aws_route_table.dev-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.dev-igw.id
}

resource "aws_route_table_association" "public-rt-assoc1" {
  route_table_id = aws_route_table.dev-public-rt.id
  subnet_id = aws_subnet.dev-public-subnet1.id
}

resource "aws_route_table_association" "public-rt-assoc2" {
  route_table_id = aws_route_table.dev-public-rt.id
  subnet_id = aws_subnet.dev-public-subnet2.id
}

resource "aws_route_table" "dev-private-rt1" {
  vpc_id = aws_vpc.dev-vpc.id
  tags = {
    "Name" = "dev-private-rt1"
  }
}

resource "aws_route_table" "dev-private-rt2" {
  vpc_id = aws_vpc.dev-vpc.id
  tags = {
    "Name" = "dev-private-rt2"
  }
}

resource "aws_route" "private-internet-rt1" {
  route_table_id = aws_route_table.dev-private-rt1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.dev-ngw1.id
}

resource "aws_route" "private-internet-rt2" {
  route_table_id = aws_route_table.dev-private-rt2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.dev-ngw2.id
}