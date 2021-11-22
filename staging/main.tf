provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    region  = "ap-southeast-1"
    bucket  = "gut-test-terraform-state-2"
    key     = "test-terraform-staging/state.tfstate"
    encrypt = true
  }

  required_providers {
    aws = ">= 3.48.0"
  }
}

module "vpc" {
  source = ".././modules/vpc"

  namespace   = var.app_name
  owner       = var.owner
  environment = var.environment
}

module "security_group" {
  source = ".././modules/security_group"

  namespace   = var.app_name
  vpc_id      = module.vpc.vpc_id
  owner       = var.owner
  environment = var.environment
}

module "alb" {
  source = ".././modules/alb"

  vpc_id             = module.vpc.vpc_id
  namespace          = var.app_name
  subnets            = module.vpc.public_subnet_ids
  security_group_ids = module.security_group.alb_security_group_ids
  owner              = var.owner
}

module "ecr" {
  source = ".././modules/ecr"

  namespace = var.app_name
  owner     = var.owner
}

module "ecs" {
  source = ".././modules/ecs"

  namespace              = var.app_name
  alb_target_group_arn   = module.alb.alb_target_group_arn
  aws_ecr_repository_url = module.ecr.repository_url
  desired_count          = var.ecs_desired_count
  cpu                    = var.ecs_cpu
  memory                 = var.ecs_memory
  owner                  = var.owner
}
