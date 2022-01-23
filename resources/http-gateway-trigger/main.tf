resource "aws_api_gateway_resource" "main" {
  rest_api_id = var.gateway.id
  parent_id   = var.gateway.root_resource_id
  path_part   = var.service
}

resource "aws_api_gateway_method" "main" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.main.id
  rest_api_id   = var.gateway.id
}

resource "aws_api_gateway_integration" "main" {
  http_method             = aws_api_gateway_method.main.http_method
  resource_id             = aws_api_gateway_resource.main.id
  rest_api_id             = var.gateway.id
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.invoke_arn
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = var.gateway.id
  stage_name  = var.env

  depends_on = [
    aws_api_gateway_method.main,
    aws_api_gateway_integration.main
  ]
}

resource "aws_api_gateway_base_path_mapping" "main" {
  api_id      = var.gateway.id
  stage_name  = aws_api_gateway_deployment.main.stage_name
  domain_name = var.gateway.domain_name
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.gateway.execution_arn}/*/${aws_api_gateway_method.main.http_method}/${var.service}"
}