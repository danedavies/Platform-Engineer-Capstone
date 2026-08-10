resource "aws_instance" "bastion" {
  ami           = var.ami
  instance_type = "t3.medium"

  key_name = "capstonekey"

  subnet_id     = var.app_public_subnet
  tags = { Name = "${var.project_name}-bastion" }
}

resource "aws_instance" "app1" {
  ami           = var.ami
  instance_type = "t3.medium"
  subnet_id     = var.app_private_1
  tags = { Name = "${var.project_name}-app1" }
}

resource "aws_instance" "app2" {
  ami           = var.ami
  instance_type = "t3.medium"
  subnet_id     = var.app_private_2
  tags = { Name = "${var.project_name}-app2" }
}

resource "aws_instance" "grafana" {
  ami           = var.ami
  instance_type = "t3.medium"
  subnet_id     = var.obs_public_subnet
  tags = { Name = "${var.project_name}-grafana" }
}

resource "aws_instance" "prometheus" {
  ami           = var.ami
  instance_type = "t3.medium"
  subnet_id     = var.obs_private_subnet
  tags = { Name = "${var.project_name}-prometheus" }
}

resource "aws_instance" "router_placeholder" {
  ami           = var.ami
  instance_type = "t3.medium"
  subnet_id     = var.router_public_subnet
  tags = { Name = "${var.project_name}-router" }
}
