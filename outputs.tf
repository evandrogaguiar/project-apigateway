#Lambda
output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = aws_lambda_function.create_user_handler.arn
}

output "lambda_function_name" {
  description = "The ARN of the Lambda Function"
  value       = aws_lambda_function.create_user_handler.function_name
}

#API
output "api_deployment_invoke_url" {
  description = "Invoke URL of the API"
  value       = aws_api_gateway_deployment.userapi_stageprod.invoke_url
}

#DynamoDB
output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.user_table.name
}
