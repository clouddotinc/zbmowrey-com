
# Creates a

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*/*"
}

resource "aws_cloudwatch_log_group" "api-log" {
  name = "zbmowrey-com-${terraform.workspace}-api-logs"
}

module "lambda_function" {
  source        = "terraform-aws-modules/lambda/aws"
  function_name = "${var.app_name}-${terraform.workspace}-web-mail-handler"
  description   = "Handle requests to forward mail to Customer Service agents."
  handler       = "handle.handle"
  runtime       = "python3.8"
  publish       = false
  source_path   = "lambda-web-mail/"
  environment_variables = {
    Serverless = "Terraform"
  }
  tags = {
    Module = "lambda-web-mail"
  }
}

module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "${local.app_domain}-web-mail"
  description   = "My awesome HTTP API Gateway"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  # Custom domain
  create_api_domain_name      = var.create_api_domain_name
  domain_name                 = local.api_domain
  domain_name_certificate_arn = aws_acm_certificate.web-cert.arn

  # Access logs
  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.api-log.arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  # Routes and integrations
  integrations = {
    "GET /" = {
      lambda_arn             = module.lambda_function.lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    "$default" = {
      lambda_arn = module.lambda_function.lambda_function_arn
    }
  }
  tags = {
    Module = "lambda-web-mail"
    Name = "web-mail-api"
  }
}

