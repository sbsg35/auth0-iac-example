# Create a new Auth0 application for OIDC authentication
resource "auth0_client" "nine_now_oidc_client" {
  name                = "nine_now"
  description         = "9now OIDC Client Created Through Terraform"
  app_type            = "spa"
  logo_uri            = "https://uat.login.nine.com.au/client-images/themes/9now/client-logo.svg?v=1611008630764"
  callbacks           = ["http://localhost:3000/callback", "http://localhost:3000"]
  allowed_logout_urls = ["http://localhost:3000"]
  allowed_origins     = ["http://localhost:3000"]
  web_origins         = ["http://localhost:3000"]
  oidc_conformant     = true

  jwt_configuration {
    alg = "RS256"
  }
}


# stan client

resource "auth0_client" "stan_oidc_client" {
  name        = "stan"
  description = "stan OIDC Client Created Through Terraform"
  app_type    = "spa"
  logo_uri    = "https://play-lh.googleusercontent.com/qSLEksYvGazk-b9Av7ey1OEKLq5czlK_klcHnuSR-h_oc3I41T7f4HmhSUUjqvRrvf8=w240-h480-rw"
  // Where Auth0 redirects users after login
  callbacks = ["http://localhost:3000/callback", "http://localhost:3000"]
  // allowed_logout_urls: Where Auth0 redirects users after logout
  allowed_logout_urls = ["http://localhost:3000"]
  // Which domains can make direct API calls to Auth0 from the browser (CORS)
  allowed_origins = ["http://localhost:3000"]
  // Web origins allowed to use Auth0's web SDK
  web_origins     = ["http://localhost:3000"]
  oidc_conformant = true

  jwt_configuration {
    alg = "RS256"
  }
}
