resource "google_sql_database_instance" "main" {
  name             = "landing-zone-db"
  database_version = "MYSQL_8_0"
  region           = var.region
  project          = var.project_id

    depends_on = [var.vpc_connection]

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_self_link
    }
  }

  deletion_protection = false
}

resource "google_sql_database" "app_db" {
  name     = "appdb"
  instance = google_sql_database_instance.main.name
  project  = var.project_id
}

resource "google_sql_user" "app_user" {
  name     = "appuser"
  instance = google_sql_database_instance.main.name
  password = var.db_password
  project  = var.project_id
}