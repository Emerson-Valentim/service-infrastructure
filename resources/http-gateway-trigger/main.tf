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

resource "aws_api_gateway_method" "cors" {
  rest_api_id   = var.gateway.id
  resource_id   = aws_api_gateway_resource.main.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cors" {
  rest_api_id          = var.gateway.id
  resource_id          = aws_api_gateway_resource.main.id
  http_method          = aws_api_gateway_method.cors.http_method
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_method_response" "cors" {
  rest_api_id = var.gateway.id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.cors.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "cors" {
  rest_api_id = var.gateway.id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.cors.http_method
  status_code = aws_api_gateway_method_response.cors.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [aws_api_gateway_integration.cors]
}

resource "aws_lambda_permission" "apigw_lambda_post" {
  statement_id  = "AllowExecutionFromAPIGatewayPost"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.gateway.execution_arn}/*/${aws_api_gateway_method.main.http_method}/${var.service}"
}