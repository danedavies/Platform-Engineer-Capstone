module "vpc_app" {
  source = "./vpc_app"
<<<<<<< HEAD

  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidr    = "10.0.1.0/24"
  private_1_subnet_cidr = "10.0.2.0/24"
  private_2_subnet_cidr = "10.0.3.0/24"
=======
>>>>>>> 6b0e8065f2843ecac089ddc6f14f97a8ed5557ef
}

module "vpc_obs" {
  source = "./vpc_obs"
<<<<<<< HEAD

  vpc_cidr            = "10.1.0.0/16"
  public_subnet_cidr  = "10.1.1.0/24"
  private_subnet_cidr = "10.1.2.0/24"
=======
>>>>>>> 6b0e8065f2843ecac089ddc6f14f97a8ed5557ef
}

module "vpc_router" {
  source = "./vpc_router"
<<<<<<< HEAD

  vpc_cidr           = "10.2.0.0/16"
  public_subnet_cidr = "10.2.1.0/24"
=======
>>>>>>> 6b0e8065f2843ecac089ddc6f14f97a8ed5557ef
}

module "peering" {
  source = "./peering"

<<<<<<< HEAD
  app_vpc_id    = module.vpc_app.vpc_id
  obs_vpc_id    = module.vpc_obs.vpc_id
  router_vpc_id = module.vpc_router.vpc_id

  app_cidr      = module.vpc_app.vpc_cidr
  obs_cidr      = module.vpc_obs.vpc_cidr
  router_cidr   = module.vpc_router.vpc_cidr
=======
  app_vpc_id     = module.vpc_app.vpc_id
  obs_vpc_id     = module.vpc_obs.vpc_id
  router_vpc_id  = module.vpc_router.vpc_id

  app_cidr       = module.vpc_app.vpc_cidr
  obs_cidr       = module.vpc_obs.vpc_cidr
  router_cidr    = module.vpc_router.vpc_cidr
>>>>>>> 6b0e8065f2843ecac089ddc6f14f97a8ed5557ef
}

module "ec2" {
  source = "./ec2"

<<<<<<< HEAD
  ami = "ami-0f9fc25dd2506cf6d" # Amazon Linux 2 AMI

=======
>>>>>>> 6b0e8065f2843ecac089ddc6f14f97a8ed5557ef
  app_public_subnet   = module.vpc_app.public_subnet_id
  app_private_1       = module.vpc_app.private_1_id
  app_private_2       = module.vpc_app.private_2_id

  obs_public_subnet   = module.vpc_obs.public_subnet_id
  obs_private_subnet  = module.vpc_obs.private_subnet_id

  router_public_subnet = module.vpc_router.public_subnet_id
}
