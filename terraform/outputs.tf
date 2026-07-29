output "app_vpc_id" {
  value = module.vpc_app.vpc_id
}

output "obs_vpc_id" {
  value = module.vpc_obs.vpc_id
}

output "router_vpc_id" {
  value = module.vpc_router.vpc_id
}
