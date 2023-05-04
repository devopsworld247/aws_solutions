provider "aws" {
  region  = "us-east-1"
  profile = "saml" //replace with profile
}
module "init_cognito" {
  source                     = "../modules/auth_module"
  pool_name                  = "demo_pool"
  resource_server_name       = "demo_resourcesrv"
  resource_server_identifier = "demoresourcesrv"
  resource_server_scope      = "json.read"
  user_pool_clients          = ["client_a"]
  cognito_domain             = "sample127399go"
  demo_api_name              = "demo_api_wrapper"
  vpc_endpoints              = ["TBD"]
  region                     = "us-east-1"
  demo_lb_url                = "https://tradestie.com/api/v1/{proxy}"
  auth_scopes                = ["demoresourcesrv/json.read"]
}
output "cognito_app_credentials" {
  value     = module.init_cognito.app_client_credentials
  sensitive = true
}
