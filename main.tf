module "vpc" {
  source  = "rohanmatre007dev-sys/vpc/rohanmatre"
  version = "1.0.0"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"
}

module "dynamodb" {
  source  = "rohanmatre007dev-sys/dynamodb/rohanmatre"
  version = "1.0.0"

  name = "${var.project_name}-table"

  hash_key = "id"

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}

module "lambda_main" {
  source  = "rohanmatre007dev-sys/lambda/rohanmatre"
  version = "1.0.0"

  source_path   = "./lambda-code"
  function_name = "${var.project_name}-lambda-main"
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  publish = true

  allowed_triggers = {
    apigw = {
      service = "apigateway"
    }
  }

  create_current_version_allowed_triggers = false

  environment_variables = {
    TABLE_NAME = module.dynamodb.dynamodb_table_id
  }
}

module "lambda_worker" {
  source  = "rohanmatre007dev-sys/lambda/rohanmatre"
  version = "1.0.0"

  source_path   = "./lambda-code"
  function_name = "${var.project_name}-lambda-worker"
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  publish = true

  event_source_mapping = {
    sqs = {
      event_source_arn = module.sqs.queue_arn
      batch_size       = 10
    }
  }

  attach_policy_statements = true

  policy_statements = {
    sqs_access = {
      effect = "Allow"
      actions = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ]
      resources = [module.sqs.queue_arn]
    }
  }
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

resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = module.apigw_cloudwatch_role.arn
}

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

data "aws_api_gateway_rest_api" "apigw" {
  name = "${var.project_name}-api"
}

module "cloudfront" {
  source  = "rohanmatre007dev-sys/cloudfront/rohanmatre"
  version = "1.0.0"

  origin = {
    apigw = {
      domain_name = "${data.aws_api_gateway_rest_api.apigw.id}.execute-api.${var.aws_region}.amazonaws.com"
      origin_path = "/default"


      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "apigw"
    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate = {
    cloudfront_default_certificate = true
  }
}

module "sqs" {
  source  = "rohanmatre007dev-sys/sqs/rohanmatre"
  version = "1.0.0"

  name       = "${var.project_name}-queue"
  create_dlq = true
}

module "sns" {
  source  = "rohanmatre007dev-sys/sns/rohanmatre"
  version = "1.0.0"

  name = "${var.project_name}-topic"
}

module "eventbridge" {
  source  = "rohanmatre007dev-sys/eventbridge/rohanmatre"
  version = "1.0.0"

  bus_name = "default"

  rules = {
    app_rule = {
      event_pattern = jsonencode({
        source = ["custom.app"]
      })
    }
  }

  targets = {
    app_rule = [
      {
        name = "send-to-sqs"
        arn  = module.sqs.queue_arn
      }
    ]
  }
}

module "step_functions" {
  source  = "rohanmatre007dev-sys/step-functions/rohanmatre"
  version = "1.0.0"

  name = "${var.project_name}-state-machine"

  definition = jsonencode({
    StartAt = "Process"
    States = {
      Process = {
        Type     = "Task"
        Resource = module.lambda_main.lambda_function_arn
        End      = true
      }
    }
  })
}
