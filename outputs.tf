output "api_gateway_invoke_url" {
  value = "https://${aws_api_gateway_rest_api.my_api.id}.execute-api.us-east-1.amazonaws.com/${aws_api_gateway_stage.dev.stage_name}/"
}
