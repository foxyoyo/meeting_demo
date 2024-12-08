output "efs_arn" {
  description = "ARN of EFS "
  # value       = module.efs.arn
  value = { for k, v in module.efs : k => v.arn }
}

output "id" {
  description = "efs id "
  # value       = module.efs.id
  value = { for k, v in module.efs : k => v.id }
}

output "dns_name" {
  description = "efs endpoint name"
  # value       = module.efs.dns_name
  value = { for k, v in module.efs : k => v.dns_name }
}

output "mount_targets" {
  description = "Map of mount targets created and their attributes"
  # value       = module.efs.mount_targets
  value = { for k, v in module.efs : k => v.mount_targets }
}

output "security_group_arn" {
  description = "ARN of the security group"
  # value       = module.efs.security_group_arn
  value = { for k, v in module.efs : k => v.security_group_arn }
}

output "security_group_id" {
  description = "ID of the security group"
  # value       = module.efs.security_group_id
  value = { for k, v in module.efs : k => v.security_group_id }
}
