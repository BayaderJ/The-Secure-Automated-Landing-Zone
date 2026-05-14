output "vpc_id"        { value = google_compute_network.vpc.id }
output "subnet_id"     { value = google_compute_subnetwork.private.id }
output "vpc_self_link" { value = google_compute_network.vpc.self_link }
output "vpc_connection" {
  value = google_service_networking_connection.private_vpc_connection.id
}