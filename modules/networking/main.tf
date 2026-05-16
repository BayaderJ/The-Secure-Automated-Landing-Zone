# Creating a custom VPC
resource "google_compute_network" "vpc" {
  name                    = "landing-zone-vpc"
  auto_create_subnetworks = false  # we control subnets manually
  project                 = var.project_id
}

# Creating a private subnet
resource "google_compute_subnetwork" "private" {
  name                     = "private-subnet"
  ip_cidr_range            = "10.0.1.0/24"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  project                  = var.project_id
  private_ip_google_access = true  # allows reaching Google APIs without internet
}

# Firewall with blocking all external traffic and allowing only internal
resource "google_compute_firewall" "deny_external" {
  name    = "deny-external-ingress"
  network = google_compute_network.vpc.name
  project = var.project_id

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  priority      = 1000
}

resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal"
  network = google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "all"
  }

  source_ranges = ["10.0.1.0/24"]
  priority      = 999
}

# Reserving a private IP range for Google services peering
resource "google_compute_global_address" "private_ip_range" {
  name          = "google-managed-services-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
  project       = var.project_id
}

# peering between my VPC and Google's network
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]
}