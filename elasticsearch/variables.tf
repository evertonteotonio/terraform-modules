variable "name" {}

variable "default_tags" {
  type    = "map"
  default = {}
}

variable "version" {
  default = "6.3"
}

variable "vpc_id" {}

variable "security_group_ids" {
  type    = "list"
  default = []
}

variable "private_subnet_ids" {
  type = "list"
}

#r4.large is required since not all instance types support encrypt_at_rest
variable "instance_type" {
  default = "r4.large.elasticsearch"
}

variable "instance_count" {
  default = 1
}

variable "dedicated_master_enabled" {
  default = "false"
}

variable "dedicated_master_type" {
  default = ""
}

variable "dedicated_master_count" {
  default = 0
}

variable "multi_az" {
  default = "false"
}

variable "automated_snapshot_start_hour" {
  default = 23
}

variable "ebs_volume_type" {
  default = "gp2"
}

variable "ebs_volume_size" {
  default = 10
}

variable "ebs_iops" {
  default = 0
}

variable "log_publishing_options" {
  type    = "list"
  default = []
}

variable "cognito_options" {
  type    = "list"
  default = []
}
