resource "aws_api_gateway_rest_api" "api_user" {
  name        = "${local.aws_resource_prefix}-rest-api"
  description = "API Gateway Learn"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = local.tags
}

resource "aws_api_gateway_resource" "user" {
  rest_api_id = aws_api_gateway_rest_api.api_user.id
  parent_id   = aws_api_gateway_rest_api.api_user.root_resource_id
  path_part   = "users"
}

resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_user.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.api_user.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.options_method]
}

resource "aws_api_gateway_integration" "options" {
  rest_api_id = aws_api_gateway_rest_api.api_user.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.options_method.http_method
  type        = "MOCK"

  depends_on = [aws_api_gateway_method.options_method]
}

resource "aws_api_gateway_integration_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.api_user.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = aws_api_gateway_method_response.options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.options_200]
}

resource "aws_api_gateway_method" "user_insert" {
  rest_api_id   = aws_api_gateway_rest_api.api_user.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "user_insert" {
  rest_api_id = aws_api_gateway_rest_api.api_user.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.user_insert.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "user_insert" {
  rest_api_id = aws_api_gateway_rest_api.api_user.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.user_insert.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"

  uri = aws_lambda_function.create_user_handler.invoke_arn
}

resource "aws_api_gateway_integration_response" "user_insert" {
  rest_api_id = aws_api_gateway_rest_api.api_user.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.user_insert.http_method
  status_code = aws_api_gateway_method_response.user_insert.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [
    aws_api_gateway_method.user_insert,
    aws_api_gateway_integration.user_insert
  ]
}

resource "aws_api_gateway_method" "get_user" {
  rest_api_id   = aws_api_gateway_rest_api.api_user.id
  resource_id   = aws_api_gateway_resource.user.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "get_user" {
  rest_api_id = aws_api_gateway_rest_api.api_user.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.get_user.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "get_user" {
  rest_api_id = aws_api_gateway_rest_api.api_user.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.get_user.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"

  uri = aws_lambda_function.create_user_handler.invoke_arn
}

resource "aws_api_gateway_integration_response" "get_user" {
  rest_api_id = aws_api_gateway_rest_api.api_user.id
  resource_id = aws_api_gateway_resource.user.id
  http_method = aws_api_gateway_method.get_user.http_method
  status_code = aws_api_gateway_method_response.get_user.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [
    aws_api_gateway_method.get_user,
    aws_api_gateway_integration.get_user
  ]
}

resource "aws_lambda_permission" "lambda_apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_user_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_user.execution_arn}/*/*/*"
}

resource "aws_api_gateway_deployment" "userapi_stageprod" {
  depends_on = [
    aws_api_gateway_integration.get_user,
    aws_api_gateway_integration.user_insert,
    aws_api_gateway_integration.options
  ]

  rest_api_id = aws_api_gateway_rest_api.api_user.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api_user.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "apigw_stage" {
  deployment_id = aws_api_gateway_deployment.userapi_stageprod.id
  rest_api_id   = aws_api_gateway_rest_api.api_user.id
  stage_name    = "prod"
}
