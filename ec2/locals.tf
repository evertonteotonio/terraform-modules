data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_ami" "main" {
  most_recent = true

  filter {
    name   = "name"
    values = [
      "amzn-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = [
      "hvm"]
  }
}

data "template_file" "userdata" {
  template = "${file("${path.module}/user_data.sh")}"

  vars {
    BANNER                = "${var.banner}"
    IAM_AUTHORIZED_GROUPS = "${var.iam_user_groups}"
    SUDOERS_GROUPS        = "${var.iam_sudo_groups}"
    LOCAL_GROUPS          = "${var.iam_local_groups}"
    USER_DATA             = "${var.user_data}"
  }
}

locals {
  account_id       = "${var.account_id != "" ? var.account_id : data.aws_caller_identity.current.account_id}"
  aws_region       = "${data.aws_region.current.name}"
  image_id         = "${var.image_id != "" ? var.image_id : data.aws_ami.main.image_id}"
  user_data        = "${data.template_file.userdata.rendered}"
  max_size         = "${var.max_size}"
  min_size         = "${var.min_size}"
  desired_capacity = "${var.desired_capacity}"
}