# EC2 Complete
output "ec2_public" {
  description = "The ID of the instance"
  value       = module.ec2_public.id
}

output "ec2_public_instance_state" {
  description = "The state of the instance. One of: `pending`, `running`, `shutting-down`, `terminated`, `stopping`, `stopped`"
  value       = module.ec2_public.instance_state
}

output "ec2_public_public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = module.ec2_public.public_dns
}

output "ec2_public_public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.ec2_public.public_ip
}

output "ec2_public_iam_role_name" {
  description = "The name of the IAM role"
  value       = module.ec2_public.iam_role_name
}

output "ec2_public_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = module.ec2_public.iam_role_arn
}

output "ec2_public_iam_instance_profile_arn" {
  description = "ARN assigned by AWS to the instance profile"
  value       = module.ec2_public.iam_instance_profile_arn
}

output "ec2_public_iam_instance_profile_id" {
  description = "Instance profile's ID"
  value       = module.ec2_public.iam_instance_profile_id
}