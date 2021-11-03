
resource "aws_lambda_permission" "gilfoyle" {
  statement_id  = "AllowGilfoyleLambdaInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.gilfoyle-lambda.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.gilfoyle-api.apigatewayv2_api_execution_arn}/*/*/*"
}

resource "aws_cloudwatch_log_group" "gilfoyle" {
  name = "zbmowrey-com-${terraform.workspace}-gilfoyle-logs"
}

module "gilfoyle-lambda" {
  source        = "terraform-aws-modules/lambda/aws"
  function_name = "${var.app_name}-${terraform.workspace}-gilfoyle"
  description   = "Provides a webhook for Slack user impersonation."
  handler       = "handle.handle"
  runtime       = "python3.8"
  publish       = false
  source_path   = "lambda-gilfoyle/"
  environment_variables = {
    Serverless = "Terraform"
  }
  tags = {
    CostCenter = "lambda-gilfoyle"
  }
}

module "gilfoyle-api" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "${local.app_domain}-gilfoyle"
  description   = "API Gateway for Gilfoyle Slack Bot"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  # Custom domain
  create_api_domain_name      = true
  domain_name                 = join(".",["gilfoyle",local.app_domain])
  domain_name_certificate_arn = aws_acm_certificate.web-cert.arn

  # Access logs
  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.gilfoyle.arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  # Routes and integrations
  integrations = {
    "GET /" = {
      lambda_arn             = module.gilfoyle-lambda.lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    "$default" = {
      lambda_arn = module.gilfoyle-lambda.lambda_function_arn
    }
  }
  tags = {
    Module = "lambda-web-mail"
    Name = "web-mail-api"
  }
}

