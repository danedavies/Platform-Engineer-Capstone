module "vpc_app" {
  source = "./vpc_app"

  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidr    = "10.0.1.0/24"
  private_1_subnet_cidr = "10.0.2.0/24"
  private_2_subnet_cidr = "10.0.3.0/24"
}

module "vpc_obs" {
  source = "./vpc_obs"

  vpc_cidr            = "10.1.0.0/16"
  public_subnet_cidr  = "10.1.1.0/24"
  private_subnet_cidr = "10.1.2.0/24"
}

module "vpc_router" {
  source = "./vpc_router"

  vpc_cidr           = "10.2.0.0/16"
  public_subnet_cidr = "10.2.1.0/24"
}

module "peering" {
  source = "./peering"

  app_vpc_id    = module.vpc_app.vpc_id
  obs_vpc_id    = module.vpc_obs.vpc_id
  router_vpc_id = module.vpc_router.vpc_id

  app_private_rt_id   = module.vpc_app.private_rt_id
  obs_private_rt_id   = module.vpc_obs.private_rt_id
  router_public_rt_id = module.vpc_router.public_rt_id

  app_public_rt_id = module.vpc_app.public_rt_id

  app_cidr    = module.vpc_app.vpc_cidr
  obs_cidr    = module.vpc_obs.vpc_cidr
  router_cidr = module.vpc_router.vpc_cidr
}


module "ec2" {
  source = "./ec2"

  project_name = var.project_name
  ami          = var.ami

  # VPC IDs
  app_vpc_id    = module.vpc_app.vpc_id
  obs_vpc_id    = module.vpc_obs.vpc_id
  router_vpc_id = module.vpc_router.vpc_id

  # App VPC subnets
  app_public_subnet = module.vpc_app.public_subnet_id
  app_private_1     = module.vpc_app.private_1_id
  app_private_2     = module.vpc_app.private_2_id

  # Observability VPC subnets
  obs_public_subnet  = module.vpc_obs.public_subnet_id
  obs_private_subnet = module.vpc_obs.private_subnet_id

  # Router VPC subnet
  router_public_subnet = module.vpc_router.public_subnet_id
}

module "vpn" {
  source = "./vpn"

  app_vpc_id                 = module.vpc_app.vpc_id
  app_private_route_table_id = module.vpc_app.private_rt_id
  router_public_ip           = module.ec2.router_public_ip

  router_bgp_asn = 65001
  aws_bgp_asn    = 64512

  project_name = var.project_name
}
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
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "app_inbound_ssh_intra_vpc" {
  network_acl_id = aws_network_acl.app_acl.id
  rule_number    = 140
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = module.vpc_app.vpc_cidr
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "app_inbound_ephemeral_intra_vpc" {
  network_acl_id = aws_network_acl.app_acl.id
  rule_number    = 150
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = module.vpc_app.vpc_cidr
  from_port      = 1024
  to_port        = 65535
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

# Inbound SSH from CI
resource "aws_network_acl_rule" "app_inbound_ssh_from_ci" {
  network_acl_id = aws_network_acl.app_acl.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

# Outbound ephemeral return traffic to CI runner
resource "aws_network_acl_rule" "app_outbound_ephemeral_to_ci" {
  network_acl_id = aws_network_acl.app_acl.id
  rule_number    = 130
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Outbound SSH within APP VPC (bastion -> app_staging private hosts)
resource "aws_network_acl_rule" "app_outbound_ssh_intra_vpc" {
  network_acl_id = aws_network_acl.app_acl.id
  rule_number    = 140
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = module.vpc_app.vpc_cidr
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "app_outbound_ephemeral_intra_vpc" {
  network_acl_id = aws_network_acl.app_acl.id
  rule_number    = 150
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = module.vpc_app.vpc_cidr
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "app_outbound_https" {
  network_acl_id = aws_network_acl.app_acl.id
  rule_number    = 160
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "app_outbound_http" {
  network_acl_id = aws_network_acl.app_acl.id
  rule_number    = 170
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "app_outbound_dns" {
  network_acl_id = aws_network_acl.app_acl.id
  rule_number    = 180
  egress         = true
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "app_inbound_ephemeral_internet" {
  network_acl_id = aws_network_acl.app_acl.id
  rule_number    = 190
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "app_inbound_ephemeral_udp_internet" {
  network_acl_id = aws_network_acl.app_acl.id
  rule_number    = 200
  egress         = false
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Outbound SSH to OBS
resource "aws_network_acl_rule" "app_outbound_ssh_to_obs" {
  network_acl_id = aws_network_acl.app_acl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = module.vpc_obs.vpc_cidr
  from_port      = 1024
  to_port        = 65535
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
  from_port      = 21024
  to_port        = 65535
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
  from_port      = 1024
  to_port        = 65535
}
