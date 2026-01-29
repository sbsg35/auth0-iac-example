# Create a new Auth0 application for OIDC authentication
resource "auth0_client" "nine_now_oidc_client" {
  name                = "9now-oidc client"
  description         = "9now OIDC Client Created Through Terraform"
  app_type            = "spa"
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
  name        = "stan-oidc client"
  description = "stan OIDC Client Created Through Terraform"
  app_type    = "spa"
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
