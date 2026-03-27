output "api_url" {
  value = module.apigw.invoke_url
}

output "cloudfront_url" {
  value = module.cloudfront.cloudfront_distribution_domain_name
}

output "dynamodb_table" {
  value = module.dynamodb.dynamodb_table_id
}
