resource "aws_lambda_function" "create_user_handler" {
  function_name = "${local.aws_resource_prefix}-create-user-handler"
  filename      = "./services/index.zip"
  handler       = "index.lambda_handler"
  runtime       = "python3.11"

  environment {
    variables = {
      REGION    = var.region
      TABLE_ARN = aws_dynamodb_table.user_table.arn
    }
  }

  source_code_hash = filebase64sha256("./services/index.zip")
  role             = aws_iam_role.lambda_role.arn

  timeout     = "5"
  memory_size = "128"

  tags = local.tags
}
