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
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}
