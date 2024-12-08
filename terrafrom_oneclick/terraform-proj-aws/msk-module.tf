module "msk-kafka-cluster-h2" {
  source  = "terraform-aws-modules/msk-kafka-cluster/aws"
  version = "2.9.0"

  name                   = "${local.name}-MSK"
  kafka_version          = var.kafka_version
  number_of_broker_nodes = length(module.vpc.private_subnets)
  enhanced_monitoring    = var.enhanced_monitoring
  broker_node_client_subnets = module.vpc.private_subnets
  broker_node_instance_type   = var.kafka_instance_type
  broker_node_security_groups = [module.security_group.security_group_id]
  broker_node_storage_info = {
    ebs_storage_info = { volume_size = var.kafka_ebs_storage }
  }

  encryption_in_transit_client_broker = var.encrypt_in_transit
  encryption_in_transit_in_cluster    = var.encrypt_in_cluster

  configuration_name        = "msk-conf"
  configuration_description = "${var.business_divsion} ${var.kafka_version} configuration"

  cloudwatch_logs_enabled = true
#   s3_logs_enabled         = true
#   s3_logs_bucket          = module.s3_logs_bucket.s3_bucket_id
#   s3_logs_prefix          = local.name

  configuration_server_properties = {
    "auto.create.topics.enable" = var.auto_create_topics_enable
    "default.replication.factor" = var.default_replication_factor
    "min.insync.replica" = var.min_insync_replicas
    "num.io.threads" = var.num_io_threads
    "num.network.threads" = var.num_network_threads
    "num.partitions" = var.num_partitions
    "num.replica.fetchers" = var.num_replica_fetchers
    "socket.request.max.bytes" = var.socket_request_max_bytes
    "unclean.leader.election.enable" = var.unclean_leader_election_enable
    "message.max.bytes" = var.message_max_bytes
  
    # "auto.create.topics.enable" = true
    # "default.replication.factor" = 2
    # "min.insync.replicas" = 2
    # "num.io.threads" = 8
    # "num.network.threads" = 5
    # "num.partitions" = 1
    # "num.replica.fetchers" = 2
    # "socket.request.max.bytes" = 104857600
    # "unclean.leader.election.enable" = true
    # "message.max.bytes" = 104857600

  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.name
  description = "Security group for ${local.name}"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.private_subnets_cidr_blocks 
  ingress_rules = [
    "kafka-broker-tcp",
    "kafka-broker-tls-tcp",
    "kafka-broker-sasl-scram-tcp"
  ]

  tags = local.common_tags
}