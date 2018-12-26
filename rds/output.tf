output "endpoint" {
  value = "${local.endpoint}"
}

output "port" {
  value = "${local.port}"
}

output "reader_endpoints" {
  value = "${aws_rds_cluster.main.*.reader_endpoint}"
}

output "username" {
  value = "${element(concat(aws_rds_cluster.main.*.master_username, aws_db_instance.main.*.username),0)}"
}

output "password" {
  value = "${element(concat(aws_rds_cluster.main.*.master_password, aws_db_instance.main.*.password),0)}"
}

output "security_group_id" {
  value = "${aws_security_group.main.id}"
}

output "billing_suggestion" {
  value = "Reserved Instances: ${var.instance_type} x ${var.replica_count+1}"
}
