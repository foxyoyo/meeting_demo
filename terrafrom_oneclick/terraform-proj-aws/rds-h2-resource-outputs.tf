output "master_db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.shuriken.address
}


output "slave_db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.shuriken_slave.address
}

output "master_db_instance_endpoint" {
    description = "The connection endpoint"
    value = aws_db_instance.shuriken.endpoint

}

output "slave_db_instance_endpoint" {
    description = "The connection endpoint"
    value = aws_db_instance.shuriken_slave.endpoint

}


output "master_db_instance_az" {
    description = "The availability zone of the instance"
    value = aws_db_instance.shuriken.availability_zone

}

output "slave_db_instance_az" {
    description = "The availability zone of the instance"
    value = aws_db_instance.shuriken_slave.availability_zone

}
