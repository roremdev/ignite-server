# ℹ️ Description
# AWS Providers used by this project:
# - Secrets Manager
#   - Provider linked to Doppler
# - VPC settings
# - IAM Policy and Role as ECS resource
# - ECS Cluster

provider "aws" {
  region = var.region

  default_tags {
    tags = var.tags
  }
}

provider "doppler" {
  doppler_token = var.doppler_token
}

data "doppler_secrets" "ignite" {}

#module "secrets" {
#  source = "./modules/secrets"
#}
#
module "repository" {
  source  = "./modules/repository"
  project = var.project
}

module "security" {
  source  = "./modules/security"
  project = var.project
}

module "network" {
  source  = "./modules/network"
  project = var.project
}

module "ecs" {
  source     = "./modules/ecs"
  project    = var.project
  secrets    = data.doppler_secrets.ignite.map
  repository = module.repository.docker
  security   = module.security.server
  network    = module.network.server
}
