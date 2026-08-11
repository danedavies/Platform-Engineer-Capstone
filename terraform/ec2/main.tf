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
    Name    = "${var.project_name}-bastion-sg"
    Project = "capstone"
    Role    = "bastion_sg"
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
    Name    = "${var.project_name}-bastion"
    Project = "capstone"
    Role    = "bastion"
  }
}

############################################
# App Servers (Private)
############################################
resource "aws_instance" "app1" {
  ami                    = var.ami
  instance_type          = "t3.medium"
  subnet_id              = var.app_private_1
  vpc_security_group_ids = [aws_security_group.private_app.id]

  tags = {
    Name    = "${var.project_name}-app1"
    Project = "capstone"
    Role    = "private_app"
  }
}

resource "aws_instance" "app2" {
  ami                    = var.ami
  instance_type          = "t3.medium"
  subnet_id              = var.app_private_2
  vpc_security_group_ids = [aws_security_group.private_app.id]

  tags = {
    Name    = "${var.project_name}-app2"
    Project = "capstone"
    Role    = "private_app"
  }
}

############################################
# Observability Stack
############################################
resource "aws_instance" "grafana" {
  ami                    = var.ami
  instance_type          = "t3.medium"
  subnet_id              = var.obs_public_subnet
  vpc_security_group_ids = [aws_security_group.grafana.id]

  tags = {
    Name    = "${var.project_name}-grafana"
    Project = "capstone"
    Role    = "grafana"
  }
}

resource "aws_instance" "prometheus" {
  ami                    = var.ami
  instance_type          = "t3.medium"
  subnet_id              = var.obs_private_subnet
  vpc_security_group_ids = [aws_security_group.prometheus.id]

  tags = {
    Name    = "${var.project_name}-prometheus"
    Project = "capstone"
    Role    = "prometheus"
  }
}

############################################
# Router Placeholder (Corrected)
############################################
resource "aws_instance" "router_placeholder" {
  ami                    = var.ami
  instance_type          = "t3.medium"
  subnet_id              = var.router_public_subnet
  vpc_security_group_ids = [aws_security_group.router.id]

  # Router needs a public IP for SSH + Ansible access
  associate_public_ip_address = true

  # Required for any EC2 acting as a router
  source_dest_check = false

  tags = {
    Name    = "${var.project_name}-router"
    Project = "capstone"
    Role    = "router"
  }
}
