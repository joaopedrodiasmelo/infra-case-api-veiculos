output "redis_endpoint" {
  value = aws_elasticache_cluster.elasticache.cache_nodes[0].address
}

output "redis_port" {
  value = aws_elasticache_cluster.elasticache.port #
}

output "redis_arn" {
  value = aws_elasticache_cluster.elasticache.arn
}