variable "kafka_version" {
  type = string
  default = "3.5.1"
}

variable "enhanced_monitoring" {
  type = string
  default = "PER_TOPIC_PER_BROKER"
}


variable "kafka_instance_type" {
  type = string
  default = "kafka.t3.small" 
}


variable "kafka_ebs_storage" {
  type = number
  default = 100
}

variable "encrypt_in_transit" {
  type = string
  default = "TLS"
}

variable "encrypt_in_cluster" {
  type = bool
  default = true
}

variable "auto_create_topics_enable" {
  type = bool
  default = true
}

variable "unclean_leader_election_enable" {
  type = bool
  default = true
}

variable "default_replication_factor" {
  type = number
  default = 2

}


variable "min_insync_replicas" {
  type = number
  default = 2

}

variable "num_io_threads" {
  type = number
  default = 8

  
}

variable "num_network_threads" {
  type = number
  default = 5

}

variable "num_partitions" {
  type = number
  default = 1

}

variable "num_replica_fetchers" {
  type = number
  default = 2
}

variable "socket_request_max_bytes" {
  type = number
  default = 104857600
}

variable "message_max_bytes" {
  type = number
  default = 104857600
}