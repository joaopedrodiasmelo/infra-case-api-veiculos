# Output do ARN
output "redis_arn" {
  value = aws_elasticache_cluster.elasticache.arn
}

output "redis_endpoint" {
  value = aws_elasticache_cluster.elasticache.cache_nodes[0].address
}
