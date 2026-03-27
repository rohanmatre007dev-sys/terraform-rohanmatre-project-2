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
