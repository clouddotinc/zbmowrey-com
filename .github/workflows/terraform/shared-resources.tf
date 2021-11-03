
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
#
## Allow lambdas to assume other roles in this account.
#
#resource "aws_iam_role" "lambda-can-assume-role" {
#  name = "LambdaDynamoAccessRole"
#  assume_role_policy = file("lambda-gilfoyle/assume_role_policy.json")
#}
#
## If a lambda can access dynamo, it can access the global store.
#
#resource "aws_iam_role_policy" "lambda-dynamo-global-store-access" {
#  name = "lambda-gilfoyle-dynamo-access"
#  policy = file("lambda-gilfoyle/policy.json")
#  role   = aws_iam_role.lambda-can-assume-role.id
#}