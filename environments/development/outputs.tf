output "vm_private_ip"  { value = module.compute.vm_private_ip }
output "db_private_ip"  { value = module.database.db_private_ip_address }
output "secret_id"      { value = module.secrets.secret_id }