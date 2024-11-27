data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

locals {
  aws_resource_prefix = "lab"

  tags = {
    Terraform = true
    Owner     = "Evandro Gervasio Aguiar"
  }
}
