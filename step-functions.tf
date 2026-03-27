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
