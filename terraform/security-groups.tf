resource "aws_security_group" "router" {
  name        = "${var.project_name}-router-sg"
  description = "Allow SSH and routing traffic"
  vpc_id      = module.vpc_router.vpc_id # ← THIS IS THE FIX

  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [module.bastion.bastion_sg_id]
  }

  ingress {
    description = "SSH from bastion Public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${module.bastion.bastion_public_ip}/32"]
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
