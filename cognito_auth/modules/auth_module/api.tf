resource "aws_api_gateway_rest_api" "demo_api_wrapper" {
  name = var.demo_api_name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "execute-api:Invoke",
        "Resource" : [
          "*"
        ]
      },
      {
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : "execute-api:Invoke",
        "Resource" : [
          "*"
        ],
        "Condition" : {
          "StringNotEquals" : {
            "aws:SourceVpce" : "${var.vpc_endpoints}"
          }
        }
      }
    ]
  })
  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = var.vpc_endpoints
  }
}
resource "aws_api_gateway_deployment" "demo_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.demo_api_wrapper.id  
  depends_on = [
    aws_api_gateway_integration.demo_api_integration
  ]
}
resource "aws_api_gateway_stage" "demo_api_stage" {
  deployment_id = aws_api_gateway_deployment.demo_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.demo_api_wrapper.id
  stage_name    = var.stage_name
}
resource "aws_api_gateway_resource" "demo_api_proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.demo_api_wrapper.id
  parent_id   = aws_api_gateway_rest_api.demo_api_wrapper.root_resource_id
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "demo_api_any" {
  rest_api_id   = aws_api_gateway_rest_api.demo_api_wrapper.id
  resource_id   = aws_api_gateway_resource.demo_api_proxy_resource.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.demo_authorizer.id
  authorization_scopes = var.auth_scopes
  request_parameters = {
    "method.request.path.proxy" = true
  }
}
resource "aws_api_gateway_authorizer" "demo_authorizer" {
  name          = "GoAPIAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.demo_api_wrapper.id
  provider_arns = [aws_cognito_user_pool.pool.arn]
}
resource "aws_api_gateway_integration" "demo_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.demo_api_wrapper.id
  resource_id             = aws_api_gateway_resource.demo_api_proxy_resource.id
  http_method             = aws_api_gateway_method.demo_api_any.http_method
  type                    = "HTTP_PROXY"
  uri                     = var.demo_lb_url
  integration_http_method = "GET"
  cache_key_parameters    = ["method.request.path.proxy"]
  timeout_milliseconds    = 29000
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}
resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.demo_api_wrapper.id
  stage_name  = aws_api_gateway_stage.demo_api_stage.stage_name
  method_path = "*/*"
  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}