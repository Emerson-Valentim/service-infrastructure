resource "aws_api_gateway_rest_api" "main" {
  name = "main-${var.env}"
}

resource "aws_api_gateway_domain_name" "main" {
  domain_name              = "${var.env}.${var.dns.domain}"
  regional_certificate_arn = var.dns.certificate_arn
  security_policy          = "TLS_1_2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_route53_record" "main" {
  name    = aws_api_gateway_domain_name.main.domain_name
  type    = "A"
  zone_id = var.dns.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.main.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.main.regional_zone_id
  }
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = var.env
}

resource "aws_api_gateway_base_path_mapping" "main" {
  api_id      = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_deployment.main.stage_name
  domain_name = aws_api_gateway_domain_name.main.domain_name
}