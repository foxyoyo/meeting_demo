output "elasticache_primary_endpoint" {
  description = "The primary endpoint of the Redis cluster."
  value = aws_elasticache_replication_group.redis_replication_group.primary_endpoint_address
}

output "elasticache_reader_endpoint" {
  description = "The reader endpoint of the Redis cluster."
  value = aws_elasticache_replication_group.redis_replication_group.reader_endpoint_address
}