############################################
# Bastion Security Group
############################################
resource "aws_security_group" "bastion_sg" {
  name        = "${var.project_name}-bastion-sg"
  description = "Allow SSH to bastion host"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-bastion-sg"
  }
}

############################################
# Bastion Host
############################################
resource "aws_instance" "bastion" {
  ami                    = var.ami
  instance_type          = "t3.medium"
  key_name               = "capstonekey"

  subnet_id              = var.app_public_subnet
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-bastion"
  }
}

############################################
# App Servers (Private)
############################################
resource "aws_instance" "app1" {
  ami           = var.ami
  instance_type = "t3.medium"
  subnet_id     = var.app_private_1

  tags = {
    Name = "${var.project_name}-app1"
  }
}

resource "aws_instance" "app2" {
  ami           = var.ami
  instance_type = "t3.medium"
  subnet_id     = var.app_private_2

  tags = {
    Name = "${var.project_name}-app2"
  }
}

############################################
# Observability Stack
############################################
resource "aws_instance" "grafana" {
  ami           = var.ami
  instance_type = "t3.medium"
  subnet_id     = var.obs_public_subnet

  tags = {
    Name = "${var.project_name}-grafana"
  }
}

resource "aws_instance" "prometheus" {
  ami           = var.ami
  instance_type = "t3.medium"
  subnet_id     = var.obs_private_subnet

  tags = {
    Name = "${var.project_name}-prometheus"
  }
}

############################################
# Router Placeholder
############################################
resource "aws_instance" "router_placeholder" {
  ami           = var.ami
  instance_type = "t3.medium"
  subnet_id     = var.router_public_subnet

  tags = {
    Name = "${var.project_name}-router"
  }
}
