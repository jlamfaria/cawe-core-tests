resource "aws_elasticache_subnet_group" "private_subnet_group" {
  name       = "cache-subnet-group"
  subnet_ids = data.aws_subnets.subnets.ids
}

resource "aws_cloudwatch_log_group" "redis" {
  #checkov:skip=CKV_AWS_158
  #checkov:skip=CKV_AWS_66
  #checkov:skip=CKV_AWS_338

  name = "Redis_Logs"
  retention_in_days = 7
  kms_key_id = var.kms_arn
}

resource "aws_elasticache_replication_group" "rg" {
  #checkov:skip=CKV_AWS_191
  #checkov:skip=CKV_AWS_29
  #checkov:skip=CKV_AWS_30
  #checkov:skip=CKV_AWS_31

  subnet_group_name           = aws_elasticache_subnet_group.private_subnet_group.name
  automatic_failover_enabled  = true
  engine                      = "redis"
  description                 = "redis-cluster replication group"
  preferred_cache_cluster_azs = var.redis_azs
  replication_group_id        = "redis-cluster-replication-group"
  node_type                   = var.node_type
  num_cache_clusters          = length(var.redis_azs)
  port                        = 6379
  security_group_ids          = [aws_security_group.aws_sg_runners_redis.id]

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.redis.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "slow-log"
  }
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.redis.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "engine-log"
  }
}

resource "aws_security_group" "aws_sg_runners_redis" {
  name        = "${local.name_prefix}-sg-runners-redis"
  description = "Security Group (SG) for redis cluster"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow redis connections"
    from_port   = 6379
    to_port     = 6379
    protocol    = "TCP"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Default"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-sg-redis"
  })

  lifecycle {
    create_before_destroy = true
  }
}
