resource "aws_instance" "bastion" {
  ami           = var.ami
  instance_type = "t3.micro"
  subnet_id     = var.app_public_subnet
}

resource "aws_instance" "app1" {
  ami           = var.ami
  instance_type = "t3.micro"
  subnet_id     = var.app_private_1
}

resource "aws_instance" "app2" {
  ami           = var.ami
  instance_type = "t3.micro"
  subnet_id     = var.app_private_2
}

resource "aws_instance" "grafana" {
  ami           = var.ami
  instance_type = "t3.micro"
  subnet_id     = var.obs_public_subnet
}

resource "aws_instance" "prometheus" {
  ami           = var.ami
  instance_type = "t3.micro"
  subnet_id     = var.obs_private_subnet
}

resource "aws_instance" "router_placeholder" {
  ami           = var.ami
  instance_type = "t3.micro"
  subnet_id     = var.router_public_subnet
}
