
# A generic, global key-value store for reuse across applications.

resource "aws_dynamodb_table" "global-store" {
  provider = aws.secondary
  hash_key = "k"
  name     = "GlobalStore"
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
