
# A generic, global key-value store for reuse across applications.

resource "aws_dynamodb_table" "global-store" {
  provider = aws.secondary
  hash_key = "k"
  # I screwed up and thought DDB tables were unique at the account level.
  # Fixing this will break the Gilfoyle/insult-bot lambda. Needs to be done,
  # but not today.
  name     = terraform.workspace == "develop" ? "GlobalStore" : "zbmowrey-global-store-${terraform.workspace}"
  attribute {
    name = "k"
    type = "S"
  }
  ttl {
    attribute_name = "ExpiresAt"
    enabled = true
  }
  tags = {
    CostCenter = "zbmowrey-global"
  }
  billing_mode = "PAY_PER_REQUEST"
}
