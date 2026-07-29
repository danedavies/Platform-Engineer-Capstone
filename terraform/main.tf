module "vpc_app" {
  source = "./vpc_app"
}

module "vpc_obs" {
  source = "./vpc_obs"
}

module "vpc_router" {
  source = "./vpc_router"
}

module "peering" {
  source = "./peering"

  app_vpc_id     = module.vpc_app.vpc_id
  obs_vpc_id     = module.vpc_obs.vpc_id
  router_vpc_id  = module.vpc_router.vpc_id

  app_cidr       = module.vpc_app.vpc_cidr
  obs_cidr       = module.vpc_obs.vpc_cidr
  router_cidr    = module.vpc_router.vpc_cidr
}

module "ec2" {
  source = "./ec2"

  app_public_subnet   = module.vpc_app.public_subnet_id
  app_private_1       = module.vpc_app.private_1_id
  app_private_2       = module.vpc_app.private_2_id

  obs_public_subnet   = module.vpc_obs.public_subnet_id
  obs_private_subnet  = module.vpc_obs.private_subnet_id

  router_public_subnet = module.vpc_router.public_subnet_id
}
