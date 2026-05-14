resource "google_compute_instance" "app_vm" {
  name         = "app-server"
  machine_type = "e2-micro"
  zone         = var.zone
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = var.subnet_id

  }

  tags = ["private-vm"]
}