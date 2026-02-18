# Create a new Auth0 application for OIDC authentication
resource "auth0_client" "nine_oidc_client" {
  name                = "nine"
  description         = "Nine OIDC Client Created Through Terraform"
  app_type            = "spa"
  logo_uri            = "https://login.nine.com.au/client-images/themes/9now/client-logo.svg?v=1599526833403"
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
  logo_uri    = "https://www.stan.com.au/logo-square.png"
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

