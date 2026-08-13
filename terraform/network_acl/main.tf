resource "aws_network_acl" "app_acl" {
  vpc_id = module.vpc_app.vpc_id

  subnet_ids = [
    module.vpc_app.public_subnet_id,
    module.vpc_app.private_1_id,
    module.vpc_app.private_2_id
  ]

  tags = {
    Name = "${var.project_name}-app-acl"
  }
}

# Inbound SSH from OBS
resource "aws_network_acl_rule" "app_inbound_ssh_from_obs" {
  network_acl_id = aws_network_acl.app_acl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = module.vpc_obs.vpc_cidr
  from_port      = 22
  to_port        = 22
}

# Inbound SSH from ROUTER
resource "aws_network_acl_rule" "app_inbound_ssh_from_router" {
  network_acl_id = aws_network_acl.app_acl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = module.vpc_router.vpc_cidr
  from_port      = 22
  to_port        = 22
}

# Outbound SSH to OBS
resource "aws_network_acl_rule" "app_outbound_ssh_to_obs" {
  network_acl_id = aws_network_acl.app_acl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = module.vpc_obs.vpc_cidr
  from_port      = 22
  to_port        = 22
}

# Outbound SSH to ROUTER
resource "aws_network_acl_rule" "app_outbound_ssh_to_router" {
  network_acl_id = aws_network_acl.app_acl.id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = module.vpc_router.vpc_cidr
  from_port      = 22
  to_port        = 22
}
resource "aws_network_acl" "obs_acl" {
  vpc_id = module.vpc_obs.vpc_id

  subnet_ids = [
    module.vpc_obs.public_subnet_id,
    module.vpc_obs.private_subnet_id
  ]

  tags = {
    Name = "${var.project_name}-obs-acl"
  }
}

# Inbound SSH from APP
resource "aws_network_acl_rule" "obs_inbound_ssh_from_app" {
  network_acl_id = aws_network_acl.obs_acl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = module.vpc_app.vpc_cidr
  from_port      = 22
  to_port        = 22
}

# Outbound SSH to APP
resource "aws_network_acl_rule" "obs_outbound_ssh_to_app" {
  network_acl_id = aws_network_acl.obs_acl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = module.vpc_app.vpc_cidr
  from_port      = 22
  to_port        = 22
}
resource "aws_network_acl" "router_acl" {
  vpc_id = module.vpc_router.vpc_id

  subnet_ids = [
    module.vpc_router.public_subnet_id
  ]

  tags = {
    Name = "${var.project_name}-router-acl"
  }
}

# Inbound SSH from APP
resource "aws_network_acl_rule" "router_inbound_ssh_from_app" {
  network_acl_id = aws_network_acl.router_acl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = module.vpc_app.vpc_cidr
  from_port      = 22
  to_port        = 22
}

# Outbound SSH to APP
resource "aws_network_acl_rule" "router_outbound_ssh_to_app" {
  network_acl_id = aws_network_acl.router_acl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = module.vpc_app.vpc_cidr
  from_port      = 22
  to_port        = 22
}
