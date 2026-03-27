resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = module.apigw_cloudwatch_role.arn
}

module "apigw_cloudwatch_role" {
  source  = "rohanmatre007dev-sys/iam/rohanmatre"
  version = "1.0.1"

  name        = "${var.project_name}-apigw-cw-role"
  environment = "dev"

  region = var.aws_region
  trust_policy_permissions = {
    APIGatewayAssumeRole = {
      actions = ["sts:AssumeRole"]
      principals = [
        {
          type        = "Service"
          identifiers = ["apigateway.amazonaws.com"]
        }
      ]
    }
  }

  policies = {
    cloudwatch = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
  }
}

data "aws_api_gateway_rest_api" "apigw" {
  name = "${var.project_name}-api"
}
