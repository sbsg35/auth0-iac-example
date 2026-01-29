# create custom domain for auth0 tenant

resource "auth0_custom_domain" "custom_domain" {
  domain = "login.happynewyear.world"
  type   = "auth0_managed_certs"
}
