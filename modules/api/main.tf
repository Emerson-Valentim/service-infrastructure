resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.service}-api-${var.env}"

  assume_role_policy = file("${path.module}/lambda-policy.json")
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "build/start.handle"

  runtime = "nodejs14.x"

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.security_groups.id]
  }
  environment {
    variables = {
      foo = "bar"
    }
  }
}