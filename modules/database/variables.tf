variable "project_id" {}
variable "region"     { default = "us-central1" }
variable "db_password" { sensitive = true }
variable "vpc_self_link" {}
variable "vpc_connection" {}