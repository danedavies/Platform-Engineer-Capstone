output "app_obs_peering_id" {
  description = "Peering connection ID between VPC1 (app) and VPC2 (observability)"
  value       = aws_vpc_peering_connection.app_obs.id
}

output "app_router_peering_id" {
  description = "Peering connection ID between VPC1 (app) and VPC3 (router)"
  value       = aws_vpc_peering_connection.app_router.id
}

output "app_vpc_id" {
  value = var.app_vpc_id
}

output "obs_vpc_id" {
  value = var.obs_vpc_id
}

output "router_vpc_id" {
  value = var.router_vpc_id
}