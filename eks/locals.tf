data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_ami" "main" {
  most_recent = true

  filter {
    name   = "name"
    values = [
      "amazon-eks-node-v*"]
  }
}

module "defaults" {
  source = "../defaults"
  name   = "${var.name}"
  tags   = "${var.default_tags}"
}

locals {
  account_id       = "${module.defaults.account_id}"
  aws_region       = "${module.defaults.aws_region}"
  name             = "${module.defaults.name}"
  tags             = "${module.defaults.tags}"
  cluster_name     = "${module.defaults.name}-eks"
  image_id         = "${var.image_id != "" ? var.image_id : data.aws_ami.main.image_id}"
  max_size         = "${var.min_size}"
  min_size         = "${var.min_size}"
  desired_capacity = "${var.desired_capacity}"
}