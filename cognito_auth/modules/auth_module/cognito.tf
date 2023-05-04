resource "aws_cognito_user_pool" "pool" {
  name = var.pool_name
}
resource "aws_cognito_resource_server" "resource_server" {
  identifier = var.resource_server_identifier
  name       = var.resource_server_name
  scope {
    scope_name        = var.resource_server_scope
    scope_description = var.resource_server_description
  }
  user_pool_id = aws_cognito_user_pool.pool.id
}
resource "aws_cognito_user_pool_client" "client" {
  for_each        = toset(var.user_pool_clients)
  name            = each.value
  user_pool_id    = aws_cognito_user_pool.pool.id
  generate_secret = true
  explicit_auth_flows = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
  allowed_oauth_flows                  = ["client_credentials"]
  supported_identity_providers         = ["COGNITO"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = aws_cognito_resource_server.resource_server.scope_identifiers
}
resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.cognito_domain
  user_pool_id = aws_cognito_user_pool.pool.id
}
output "app_client_credentials" {
  value     = zipmap((values(aws_cognito_user_pool_client.client)[*].id),(values(aws_cognito_user_pool_client.client)[*].client_secret))
  sensitive = true
}