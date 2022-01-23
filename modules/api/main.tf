data "archive_file" "dummy" {
  type        = "zip"
  output_path = "${path.module}/lambda_function_payload.zip"

  source {
    content  = "hello"
    filename = "dummy.txt"
  }
}

module "cloudwatch" {
  source = "../../resources/cloudwatch"

  name = "/aws/lambda/${var.service}-api"
  env  = var.env
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.service}-api-${var.env}"

  assume_role_policy = file("${path.module}/lambda-policy.json")
}

resource "aws_iam_policy" "policy_for_lambda" {
  name = "${var.service}-api-${var.env}"
  path = "/"
  policy = templatefile("${path.module}/lambda-policy.json.tpl", {
    cloudwatch_log_group = module.cloudwatch.logs.arn
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.policy_for_lambda.arn
}

resource "aws_lambda_function" "api_lambda" {
  filename      = data.archive_file.dummy.output_path
  function_name = "${var.service}-api-${var.env}"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "build/start.handle"

  runtime = "nodejs14.x"

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_groups
  }
  environment {
    variables = var.env_vars
  }
}

module "api-gateway" {
  source        = "../../resources/http-gateway-trigger"
  region        = var.region
  service       = var.service
  env           = var.env
  gateway       = var.gateway
  invoke_arn    = aws_lambda_function.api_lambda.invoke_arn
  function_name = aws_lambda_function.api_lambda.function_name
}