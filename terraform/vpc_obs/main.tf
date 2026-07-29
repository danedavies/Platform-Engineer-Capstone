########################################
<<<<<<< HEAD
# VPC 2 – OBSERVABILITY
=======
# VPC 2 – Observability
>>>>>>> 6b0e8065f2843ecac089ddc6f14f97a8ed5557ef
########################################

resource "aws_vpc" "obs" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc-obs"
  }
}

########################################
# Subnets
########################################

resource "aws_subnet" "public" {
<<<<<<< HEAD
  cidr_block              = var.public_subnet_cidr
  vpc_id                  = aws_vpc.obs.id
  availability_zone       = "us-east-1b"
=======
  vpc_id                  = aws_vpc.obs.id
  cidr_block              = var.public_subnet_cidr
>>>>>>> 6b0e8065f2843ecac089ddc6f14f97a8ed5557ef
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-obs-public"
  }
}

resource "aws_subnet" "private" {
<<<<<<< HEAD
  cidr_block        = var.private_subnet_cidr
  vpc_id            = aws_vpc.obs.id
  availability_zone = "us-east-1b"
=======
  vpc_id     = aws_vpc.obs.id
  cidr_block = var.private_subnet_cidr
>>>>>>> 6b0e8065f2843ecac089ddc6f14f97a8ed5557ef

  tags = {
    Name = "${var.project_name}-obs-private"
  }
}

########################################
# Internet Gateway
########################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.obs.id

  tags = {
    Name = "${var.project_name}-obs-igw"
  }
}

########################################
# Route Tables
########################################

<<<<<<< HEAD
=======
# Public RT
>>>>>>> 6b0e8065f2843ecac089ddc6f14f97a8ed5557ef
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.obs.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-obs-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

<<<<<<< HEAD
=======
# Private RT (no NAT)
>>>>>>> 6b0e8065f2843ecac089ddc6f14f97a8ed5557ef
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.obs.id

  tags = {
    Name = "${var.project_name}-obs-private-rt"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
