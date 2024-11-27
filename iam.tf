resource "aws_iam_role" "lambda_role" {
  name               = "${local.aws_resource_prefix}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_policy" "lambda_role" {
  name   = "${local.aws_resource_prefix}-lambda-policy"
  policy = data.aws_iam_policy_document.dynamo.json
}

resource "aws_iam_role_policy_attachment" "lambda_role" {
  policy_arn = aws_iam_policy.lambda_role.arn
  role       = aws_iam_role.lambda_role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "dynamo" {
  statement {
    sid       = "AllowDynamoPermissions"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "dynamodb:*"
    ]
  }

  statement {
    sid       = "AllowInvokingLambdas"
    effect    = "Allow"
    resources = ["arn:aws:lambda:*:*:function:*"]
    actions   = ["lambda:InvokeFunction"]
  }

  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
    ]
  }
}
