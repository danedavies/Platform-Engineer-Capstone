<<<<<<< HEAD
########################################
# VPC 1 – APP
########################################

resource "aws_vpc" "app" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc-app"
  }
}

########################################
# Subnets
########################################

resource "aws_subnet" "public" {
  cidr_block              = var.public_subnet_cidr
  vpc_id                  = aws_vpc.app.id
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-app-public"
  }
}

resource "aws_subnet" "private_1" {
  cidr_block        = var.private_1_subnet_cidr
  vpc_id            = aws_vpc.app.id
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.project_name}-app-private-1"
  }
}

resource "aws_subnet" "private_2" {
  cidr_block        = var.private_2_subnet_cidr
  vpc_id            = aws_vpc.app.id
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.project_name}-app-private-2"
  }
}

########################################
# Internet Gateway
########################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app.id

  tags = {
    Name = "${var.project_name}-app-igw"
  }
}

########################################
# NAT Gateway
########################################

resource "aws_eip" "nat_eip" {
  domain = "vpc"
=======
resource "aws_vpc" "app" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.app.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_1" {
  cidr_block = "10.0.2.0/24"
  vpc_id     = aws_vpc.app.id
}

resource "aws_subnet" "private_2" {
  cidr_block = "10.0.3.0/24"
  vpc_id     = aws_vpc.app.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app.id
}

resource "aws_eip" "nat_eip" {
  vpc = true
>>>>>>> 6b0e8065f2843ecac089ddc6f14f97a8ed5557ef
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
<<<<<<< HEAD

  tags = {
    Name = "${var.project_name}-app-nat"
  }
}

########################################
# Route Tables
########################################

=======
}

>>>>>>> 6b0e8065f2843ecac089ddc6f14f97a8ed5557ef
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
<<<<<<< HEAD

  tags = {
    Name = "${var.project_name}-app-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
=======
>>>>>>> 6b0e8065f2843ecac089ddc6f14f97a8ed5557ef
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
<<<<<<< HEAD

  tags = {
    Name = "${var.project_name}-app-private-rt"
  }
}

resource "aws_route_table_association" "private_1_assoc" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_2_assoc" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
=======
>>>>>>> 6b0e8065f2843ecac089ddc6f14f97a8ed5557ef
}
