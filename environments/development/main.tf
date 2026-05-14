terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Call each module
module "networking" {
  source     = "../../modules/networking"
  project_id = var.project_id
  region     = var.region
}

module "secrets" {
  source      = "../../modules/secrets"
  project_id  = var.project_id
  db_password = var.db_password
}

module "database" {
  source        = "../../modules/database"
  project_id    = var.project_id
  region        = var.region
  db_password   = var.db_password
  vpc_self_link = module.networking.vpc_self_link
  vpc_connection = module.networking.vpc_connection 
}

module "compute" {
  source     = "../../modules/compute"
  project_id = var.project_id
  zone       = var.zone
  subnet_id  = module.networking.subnet_id
}