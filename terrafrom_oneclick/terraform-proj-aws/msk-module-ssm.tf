locals {

 # kafka_endpoints = ["b-1.kafkaau.bw6ieo.c3.kafka.ap-southeast-2.amazonaws.com", "b-2.kafkaau.bw6ieo.c3.kafka.ap-southeast-2.amazonaws.com", "b-3.kafkaau.bw6ieo.c3.kafka.ap-southeast-2.amazonaws.com"]
 kafka_endpoints = module.msk-kafka-cluster-h2.bootstrap_brokers
 kafka_endpoints_with_port = [for endpoint in local.kafka_endpoints : "${endpoint}:9092"]
 kafka_endpoints_string = join(",", local.kafka_endpoints_with_port)
 kafka_endpoints_string_witoutport = join(",", local.kafka_endpoints)

}

module "msk-ssm" {
  source  = "terraform-aws-modules/ssm-parameter/aws"
  name  = lower("/terraform/${var.country}/msk/kafka-${var.country}/entrypoint")
  value = local.kafka_endpoints_string
  depends_on = [
    module.msk-kafka-cluster-h2
  ]
}


module "msk-ssm-bootstrap_servers" {
  source  = "terraform-aws-modules/ssm-parameter/aws"
  name  = lower("/${var.environment}-${var.country}/kafka/bootstrap_servers")
  value = local.kafka_endpoints_string_witoutport
  depends_on = [
    module.msk-kafka-cluster-h2
  ]
}