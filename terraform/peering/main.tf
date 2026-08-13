########################################
# VPC Peering Connections
########################################

resource "aws_vpc_peering_connection" "app_obs" {
  vpc_id      = var.app_vpc_id
  peer_vpc_id = var.obs_vpc_id
  auto_accept = true

  tags = {
    Project = "capstone"
    Name    = "app-to-obs"
  }
}

resource "aws_vpc_peering_connection" "app_router" {
  vpc_id      = var.app_vpc_id
  peer_vpc_id = var.router_vpc_id
  auto_accept = true

  tags = {
    Project = "capstone"
    Name    = "app-to-router"
  }
}

########################################
# Peering Routes: App <--> Obs
########################################

# App private → Obs
resource "aws_route" "app_private_to_obs" {
  route_table_id            = var.app_private_rt_id
  destination_cidr_block    = var.obs_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.app_obs.id
}

# Obs private → App
resource "aws_route" "obs_private_to_app" {
  route_table_id            = var.obs_private_rt_id
  destination_cidr_block    = var.app_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.app_obs.id
}

########################################
# Peering Routes: App <--> Router
########################################

# App private → Router
resource "aws_route" "app_private_to_router" {
  route_table_id            = var.app_private_rt_id
  destination_cidr_block    = var.router_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.app_router.id
}

# Router public → App
resource "aws_route" "router_public_to_app" {
  route_table_id            = var.router_public_rt_id
  destination_cidr_block    = var.app_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.app_router.id
}

########################################
# Bastion Peering Routes (App Public RT)
########################################

# Bastion → Obs
resource "aws_route" "bastion_to_obs" {
  route_table_id            = var.app_public_rt_id
  destination_cidr_block    = var.obs_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.app_obs.id
}

# Bastion → Router
resource "aws_route" "bastion_to_router" {
  route_table_id            = var.app_public_rt_id
  destination_cidr_block    = var.router_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.app_router.id
}
