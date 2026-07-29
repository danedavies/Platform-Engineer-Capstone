resource "aws_vpc_peering_connection" "app_obs" {
  vpc_id      = var.app_vpc_id
  peer_vpc_id = var.obs_vpc_id
  auto_accept = true
}

resource "aws_vpc_peering_connection" "app_router" {
  vpc_id      = var.app_vpc_id
  peer_vpc_id = var.router_vpc_id
  auto_accept = true
}
