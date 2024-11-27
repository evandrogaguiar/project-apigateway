terraform {
  backend "s3" {
    bucket = "tfstate-637423577083"
    key    = "project-apigateway/terraform.tfstate"
    region = "us-east-1"
  }
}
