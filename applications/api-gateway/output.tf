output "id" {
  value = aws_api_gateway_rest_api.main.id
}

output "root_resource_id" {
  value = aws_api_gateway_rest_api.main.root_resource_id
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.main.execution_arn
}

output "domain_name" {
  value = aws_api_gateway_domain_name.main.domain_name
}