resource "aws_waf_rule" "wafCSRFRule" {
  depends_on = [
    aws_waf_byte_match_set.wafCSRFMethodStringSet,
    aws_waf_size_constraint_set.wafCSRFTokenSizeConstraint,
  ]

  name        = "${local.name}wafCSRFRule"
  metric_name = "${local.name}wafCSRFRule"

  predicates {
    data_id = aws_waf_byte_match_set.wafCSRFMethodStringSet.id
    negated = false
    type    = "ByteMatch"
  }

  predicates {
    data_id = aws_waf_size_constraint_set.wafCSRFTokenSizeConstraint.id
    negated = false
    type    = "SizeConstraint"
  }
}

resource "aws_waf_byte_match_set" "wafCSRFMethodStringSet" {
  name = "${local.name}wafCSRFMethodStringSet"

  byte_match_tuples {
    text_transformation   = "LOWERCASE"
    target_string         = "post"
    positional_constraint = "EXACTLY"

    field_to_match {
      type = "METHOD"
    }
  }
}

resource "aws_waf_size_constraint_set" "wafCSRFTokenSizeConstraint" {
  name = "${local.name}wafCSRFTokenSizeConstraint"

  size_constraints {
    text_transformation = "NONE"
    comparison_operator = "EQ"
    size                = var.csrfExpectedSize

    field_to_match {
      type = "HEADER"
      data = var.csrfExpectedHeader
    }
  }
}

