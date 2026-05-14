output "vm_name"       { value = google_compute_instance.app_vm.name }
output "vm_private_ip" { value = google_compute_instance.app_vm.network_interface[0].network_ip }