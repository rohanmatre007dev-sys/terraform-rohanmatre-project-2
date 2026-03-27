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
