resource "auth0_email_template" "my_email_template" {

  template                = "verify_email"
  body                    = file("${path.module}/../src/html/verify_email.html")
  from                    = "welcome@${var.custom_domain}"
  subject                 = "Welcome"
  syntax                  = "Verify your email"
  url_lifetime_in_seconds = 3600
  enabled                 = true
}
