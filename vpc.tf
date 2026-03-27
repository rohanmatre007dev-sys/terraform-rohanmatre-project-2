module "vpc" {
  source  = "rohanmatre007dev-sys/vpc/rohanmatre"
  version = "1.0.0"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"
}
