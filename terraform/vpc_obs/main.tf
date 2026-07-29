########################################
# VPC 2 – OBSERVABILITY
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
  cidr_block              = var.public_subnet_cidr
  vpc_id                  = aws_vpc.obs.id
  availability_zone       = "us-east-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-obs-public"
  }
}

resource "aws_subnet" "private" {
  cidr_block        = var.private_subnet_cidr
  vpc_id            = aws_vpc.obs.id
  availability_zone = "us-east-1b"

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

# Public RT
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

# Private RT (no NAT)
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
