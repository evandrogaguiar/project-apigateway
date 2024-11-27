resource "aws_dynamodb_table" "user_table" {
  name         = "USERS"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "name"
    type = "S"
  }
  attribute {
    name = "club"
    type = "S"
  }

  global_secondary_index {
    name            = "NameClubIndex"
    hash_key        = "name"
    range_key       = "club"
    projection_type = "ALL"
  }
}
