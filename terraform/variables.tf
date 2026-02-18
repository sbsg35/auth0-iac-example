variable "auth0_domain" {
  default     = "nine-trx.au.auth0.com"
  description = "Auth0 domain"
}

variable "custom_domain" {
  type        = string
  default     = "happynewyear.world"
  description = "Custom domain for Auth0 tenant (optional)"
}

variable "custom_domain_type" {
  type        = string
  default     = "auth0_managed_certs"
  description = "Custom domain certificate type (auth0_managed_certs or self_managed_certs)"
}

provider "auth0" {
  domain = var.auth0_domain
  debug  = false
}
