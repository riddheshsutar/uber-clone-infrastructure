# Root main.tf - Orchestrates all modules

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block       = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  project_name         = var.project_name
  environment          = var.environment
  aws_region           = var.aws_region
  tags                 = local.common_tags
}

# Subnets Module
module "subnets" {
  source = "./modules/subnets"

  vpc_id               = module.vpc.vpc_id
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  db_subnet_cidrs      = var.db_subnet_cidrs
  availability_zones   = var.availability_zones
  project_name         = var.project_name
  environment          = var.environment
  tags                 = local.common_tags
}

# Gateways Module
module "gateways" {
  source = "./modules/gateways"

  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.subnets.public_subnet_ids
  availability_zones = var.availability_zones
  single_nat_gateway = var.single_nat_gateway
  project_name       = var.project_name
  environment        = var.environment
  tags               = local.common_tags
}

# Routing Module
module "routing" {
  source = "./modules/routing"

  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.subnets.public_subnet_ids
  private_subnet_ids   = module.subnets.private_subnet_ids
  db_subnet_ids        = module.subnets.db_subnet_ids
  internet_gateway_id  = module.gateways.internet_gateway_id
  nat_gateway_ids      = module.gateways.nat_gateway_ids
  s3_endpoint_id       = module.vpc.s3_endpoint_id
  dynamodb_endpoint_id = module.vpc.dynamodb_endpoint_id
  availability_zones   = var.availability_zones
  single_nat_gateway   = var.single_nat_gateway
  project_name         = var.project_name
  environment          = var.environment
  tags                 = local.common_tags
}

# Security Module
module "security" {
  source = "./modules/security"

  vpc_id             = module.vpc.vpc_id
  vpc_cidr_block     = var.vpc_cidr_block
  project_name       = var.project_name
  environment        = var.environment
  app_port           = 8080
  cache_port         = 6379
  db_port            = 3306
  bastion_cidr_block = "0.0.0.0/0"
  tags               = local.common_tags
}

# RDS Module
module "rds" {
  source = "./modules/rds"

  db_subnet_group_name         = module.subnets.db_subnet_group_name
  database_security_group_id   = module.security.database_security_group_id
  project_name                 = var.project_name
  environment                  = var.environment
  engine                       = "mysql"
  engine_version               = "8.0.43"
  instance_class               = var.db_instance_class
  allocated_storage            = var.db_storage
  db_name                      = var.db_name
  db_username                  = var.db_username
  db_password                  = var.db_password
  backup_retention_period      = var.db_backup_retention
  multi_az                     = true
  auto_minor_version_upgrade   = true
  performance_insights_enabled = false
  deletion_protection          = var.environment != "dev" ? true : false
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]
  read_replica_az2             = var.availability_zones[1]
  read_replica_az3             = var.availability_zones[2]
  tags                         = local.common_tags

  depends_on = [module.security]
}

