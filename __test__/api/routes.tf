# ***** Generated by Makefile *****
resource "aws_api_gateway_resource" "ping" {
  rest_api_id = "${module.api.rest_api_id}"
  parent_id   = "${module.api.root_resource_id}"
  path_part   = "ping"
}

resource "aws_api_gateway_resource" "ping_pong" {
  rest_api_id = "${module.api.rest_api_id}"
  parent_id   = "${aws_api_gateway_resource.ping.id}"
  path_part   = "pong"
}

module "GET_ping_pong" {
  source             = "../../public-api-endpoint"
  name               = "${local.name}"
  #security_group_ids = []
  #private_subnet_ids = []
  rest_api_id        = "${module.api.rest_api_id}"
  resource_id        = "${aws_api_gateway_resource.ping_pong.id}"
  http_method        = "GET"
  stage_name         = "${module.api.stage_name}"
  resource_path      = "${aws_api_gateway_resource.ping_pong.path}"
  source_dir         = "${path.module}/ping"
}

resource "aws_api_gateway_resource" "ping_-pong" {
  rest_api_id = "${module.api.rest_api_id}"
  parent_id   = "${aws_api_gateway_resource.ping.id}"
  path_part   = "{pong}"
}

module "GET_ping_-pong" {
  source             = "../../public-api-endpoint"
  name               = "${local.name}"
  #security_group_ids = []
  #private_subnet_ids = []
  rest_api_id        = "${module.api.rest_api_id}"
  resource_id        = "${aws_api_gateway_resource.ping_-pong.id}"
  http_method        = "GET"
  stage_name         = "${module.api.stage_name}"
  resource_path      = "${aws_api_gateway_resource.ping_-pong.path}"
  source_dir         = "${path.module}/ping"
}

resource "aws_api_gateway_resource" "ping_pang" {
  rest_api_id = "${module.api.rest_api_id}"
  parent_id   = "${aws_api_gateway_resource.ping.id}"
  path_part   = "pang"
}

module "GET_ping_pang" {
  source             = "../../public-api-endpoint"
  name               = "${local.name}"
  #security_group_ids = []
  #private_subnet_ids = []
  rest_api_id        = "${module.api.rest_api_id}"
  resource_id        = "${aws_api_gateway_resource.ping_pang.id}"
  http_method        = "GET"
  stage_name         = "${module.api.stage_name}"
  resource_path      = "${aws_api_gateway_resource.ping_pang.path}"
  source_dir         = "${path.module}/ping"
}
