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
  app_private_route_table_id = module.vpc_app.private_route_table_id
  router_public_ip           = module.ec2.router_public_ip

  router_bgp_asn = 65001
  aws_bgp_asn    = 64512

  project_name = var.project_name
}
