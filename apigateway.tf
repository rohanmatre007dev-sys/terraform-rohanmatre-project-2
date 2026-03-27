module "apigw" {
  source  = "rohanmatre007dev-sys/apigw/rohanmatre"
  version = "1.0.0"

  name = "${var.project_name}-api"

  depends_on = [aws_api_gateway_account.this]

  openapi_config = {
    openapi = "3.0.1"

    info = {
      title   = "My API"
      version = "1.0"
    }

    paths = {
      "/" = {
        get = {
          x-amazon-apigateway-integration = {
            uri        = module.lambda_main.lambda_function_invoke_arn
            httpMethod = "POST"
            type       = "aws_proxy"
          }
        }
      }
    }
  }
}
