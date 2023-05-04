/* 
* * User Pool 
*/
variable "pool_name" {
  type    = string
  default = "pool"
}
/* 
* * Resource Server 
*/
variable "resource_server_identifier" {
  type = string
}
variable "resource_server_name" {
  type = string
}
variable "resource_server_scope" {
  type = string
}
variable "resource_server_description" {
  type    = string
  default = "Sample Resource Server"
}
/* 
* * App Client
*/
variable "user_pool_clients" {
  type = list(string)
}
/*
* * Domain Name 
*/
variable "cognito_domain" {
  type = string
}
/*
* * Go API
*/
variable "demo_api_name" {
  type = string
}
/*
* * 
*/
variable "vpc_endpoints" {
  type = list(string)
}
variable "stage_name" {
  type    = string
  default = "uat"
}
variable "region" {
  type = string
}
variable "demo_lb_url" {
  type = string
}
variable "auth_scopes" {
  type = list(string)  
}