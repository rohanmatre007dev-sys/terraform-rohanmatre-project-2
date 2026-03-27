module "sqs" {
  source  = "rohanmatre007dev-sys/sqs/rohanmatre"
  version = "1.0.0"

  name       = "${var.project_name}-queue"
  create_dlq = true
}
