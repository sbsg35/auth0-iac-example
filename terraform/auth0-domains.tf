# create custom domain for auth0 tenant (only if custom_domain is provided)

resource "auth0_custom_domain" "custom_domain" {
  count  = var.custom_domain != null ? 1 : 0
  domain = "login.${var.custom_domain}"
  type   = var.custom_domain_type
}
