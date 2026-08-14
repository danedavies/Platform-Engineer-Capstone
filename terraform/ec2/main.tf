############################################
# Bastion Security Group (APP VPC)
############################################
resource "aws_security_group" "bastion_sg" {
  name        = "${var.project_name}-bastion-sg"
  description = "Allow SSH to bastion host"
  vpc_id      = var.app_vpc_id

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
# Bastion Host (APP VPC)
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
# Private App Security Group (APP VPC)
############################################
resource "aws_security_group" "private_app" {
  name        = "${var.project_name}-private-app-sg"
  description = "Allow Prometheus and Bastion access to private app servers"
  vpc_id      = var.app_vpc_id

  # NEW: SSH from Bastion SG
  ingress {
    description = "SSH from bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  # Existing: Node Exporter
  ingress {
    description = "Node Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    security_groups = [aws_security_group.prometheus_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-private-app-sg"
    Project = "capstone"
    Role    = "private_app"
  }
}


############################################
# App Servers (APP VPC)
############################################
resource "aws_instance" "app1" {
  ami                    = var.ami
  instance_type          = "t3.medium"
  subnet_id              = var.app_private_1
  vpc_security_group_ids = [aws_security_group.private_app.id]
  key_name = "capstonekey"
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
  key_name = "capstonekey"
  tags = {
    Name    = "${var.project_name}-app2"
    Project = "capstone"
    Role    = "private_app"
  }
}

############################################
# Prometheus Security Group (OBS VPC)
############################################
resource "aws_security_group" "prometheus_sg" {
  name        = "${var.project_name}-prometheus-sg"
  description = "Allow bastion to access Prometheus UI"
  vpc_id      = var.obs_vpc_id

  ingress {
    description = "Prometheus UI"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description = "SSH from bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-prometheus-sg"
    Project = "capstone"
    Role    = "prometheus"
  }
}

############################################
# Grafana Security Group (OBS VPC)
############################################
resource "aws_security_group" "grafana_sg" {
  name        = "${var.project_name}-grafana-sg"
  description = "Allow bastion to access Grafana UI"
  vpc_id      = var.obs_vpc_id

  ingress {
    description = "Grafana UI"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description = "SSH from bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description = "SSH from bastion Public IP"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${aws_instance.bastion.public_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-grafana-sg"
    Project = "capstone"
    Role    = "grafana"
  }
}

############################################
# Router Security Group (ROUTER VPC)
############################################
resource "aws_security_group" "router" {
  name        = "${var.project_name}-router-sg"
  description = "Allow SSH and routing traffic"
  vpc_id      = var.router_vpc_id

  ingress {
    description = "SSH from bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description = "SSH from bastion Public IP"
    from_port = 22 
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${aws_instance.bastion.public_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-router-sg"
    Project = "capstone"
    Role    = "router_sg"
  }
}

############################################
# Observability Stack (OBS VPC)
############################################
resource "aws_instance" "grafana" {
  ami                    = var.ami
  instance_type          = "t3.medium"
  subnet_id              = var.obs_public_subnet
  vpc_security_group_ids = [aws_security_group.grafana_sg.id]
  key_name = "capstonekey"

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
  vpc_security_group_ids = [aws_security_group.prometheus_sg.id]
  key_name = "capstonekey"
  tags = {
    Name    = "${var.project_name}-prometheus"
    Project = "capstone"
    Role    = "prometheus"
  }
}

############################################
# Router Placeholder (ROUTER VPC)
############################################
resource "aws_instance" "router_placeholder" {
  ami                    = "ami-0279549f721af0ad1"
  instance_type          = "c5.large"
  subnet_id              = var.router_public_subnet
  vpc_security_group_ids = [aws_security_group.router.id]
  key_name = "capstonekey"
  associate_public_ip_address = true
  source_dest_check           = false
  
  root_block_device {
    volume_size = 16
    volume_type = "gp3"
  }
  
#  user_data = file("${path.module}/templates/router-day0.txt")

  tags = {
    Name    = "${var.project_name}-router"
    Project = "capstone"
    Role    = "router"
  }
}
/*
resource "aws_instance" "router" {
  ami           = "ami-0279549f721af0ad1"
  instance_type = "c5.large"

  subnet_id              = var.router_public_subnet
  security_groups = [aws_security_group.bastion_sg.id]

  associate_public_ip_address = false
  source_dest_check           = false

  tags = {
    Name    = "Cisco-C8K Router"
    Project = "capstone"
    Role    = "router"
  }
}
*/
