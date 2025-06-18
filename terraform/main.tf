module "vpc" {
  source = "./modules/vpc"
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "load_balancer" {
  source            = "./modules/load_balancer"
  vpc_id            = module.vpc.vpc_id
  security_group_id = module.security_groups.app_sg_id
  public_subnet_ids = [module.vpc.public_subnet_1_id, module.vpc.public_subnet_2_id]
}

module "rds" {
  source            = "./modules/rds"
  db_username       = var.db_user
  db_password       = var.db_password
  #private_subnet_ids = [
  private_subnet_ids = module.vpc.private_subnet_ids
    #module.vpc.private_subnet_id,
    #module.vpc.public_subnet_2_id 
  #]
  security_group_id = module.security_groups.app_sg_id
}

module "ecs" {
  source             = "./modules/ecs"
  docker_image       = var.docker_image
  db_host            = module.rds.endpoint
  db_user            = var.db_user
  db_password        = var.db_password
  #public_subnet_ids  = [module.vpc.public_subnet_1_id, module.vpc.public_subnet_2_id]
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_id  = module.security_groups.app_sg_id
  target_group_arn   = module.load_balancer.target_group_arn
  depends_on         = [module.rds]
}
