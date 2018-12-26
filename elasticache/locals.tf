
module "defaults" {
  source = "../defaults"
  name   = "${var.name}"
  tags   = "${var.default_tags}"
}

locals {
  name = "${module.defaults.name}"
  tags = "${module.defaults.tags}"

  master_endpoint = "${element(concat(aws_elasticache_replication_group.cluster.*.configuration_endpoint_address, aws_elasticache_replication_group.service.*.primary_endpoint_address), 0)}"
  master_len      = "${length(element(split(".", local.master_endpoint), 0))}"
  member_clusters = "${concat(aws_elasticache_replication_group.service.*.member_clusters, aws_elasticache_replication_group.cluster.*.member_clusters)}"
}
