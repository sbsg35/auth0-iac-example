variable "auth0_domain" {
  default     = "https://dev-sjjgeg1szb3x4yy2.au.auth0.com"
  description = "Auth0 domain"
}

provider "auth0" {
  domain = var.auth0_domain
  debug  = false
}
