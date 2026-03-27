module "sns" {
  source  = "rohanmatre007dev-sys/sns/rohanmatre"
  version = "1.0.0"

  name = "${var.project_name}-topic"
}
