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
