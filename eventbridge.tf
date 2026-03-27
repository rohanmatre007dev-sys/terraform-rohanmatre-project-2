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
