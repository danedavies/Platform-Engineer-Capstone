########################################
# VPC 3 – ROUTER
########################################

resource "aws_vpc" "router" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc-router"
  }
}

########################################
# Public Subnet
########################################

resource "aws_subnet" "public" {
  cidr_block              = var.public_subnet_cidr
  vpc_id                  = aws_vpc.router.id
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-router-public"
  }
}

########################################
# Internet Gateway
########################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.router.id

  tags = {
    Name = "${var.project_name}-router-igw"
  }
}

########################################
# Route Table
########################################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.router.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-router-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}
