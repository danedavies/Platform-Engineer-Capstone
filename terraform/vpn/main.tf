resource "aws_vpn_gateway" "app" {
  vpc_id          = var.app_vpc_id
  amazon_side_asn = var.aws_bgp_asn

  tags = {
    Name = "${var.project_name}-app-vpn-gateway"
  }
}

resource "aws_vpn_connection" "app" {
  vpn_gateway_id = aws_vpn_gateway.app.id
  customer_gateway_id = aws_customer_gateway.router.id

  type = "ipsec.1"

  static_routes_only = false

  tags = {
    Name = "${var.project_name}-app-vpn"
  }
}

resource "aws_vpn_gateway_route_propagation" "app" {
  vpn_gateway_id = aws_vpn_gateway.app.id
  route_table_id = var.app_private_route_table_id
}
