# Create a new Auth0 application for OIDC authentication
resource "auth0_client" "nine_oidc_client" {
  name                = "nine_now"
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


# afr client
resource "auth0_client" "afr_auth0_client" {
  name                = "afr"
  description         = "AFR OIDC Client Created Through Terraform"
  app_type            = "spa"
  logo_uri            = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSuW1bAvs64jnvk54IE42ZOgtj4XygAk_8opg&s"
  callbacks           = ["http://localhost:3000/callback", "http://localhost:3000"]
  allowed_logout_urls = ["http://localhost:3000"]
  allowed_origins     = ["http://localhost:3000"]
  web_origins         = ["http://localhost:3000"]
  oidc_conformant     = true

  jwt_configuration {
    alg = "RS256"
  }
}


# the_age client
resource "auth0_client" "the_age_auth0_client" {
  name                = "the_age"
  description         = "The Age OIDC Client Created Through Terraform"
  app_type            = "spa"
  logo_uri            = "https://images.squarespace-cdn.com/content/v1/648facedaaf1c8276ed93931/1688462220874-MTGESJCGIEBDJUOKCON1/the+age.png"
  callbacks           = ["http://localhost:3000/callback", "http://localhost:3000"]
  allowed_logout_urls = ["http://localhost:3000"]
  allowed_origins     = ["http://localhost:3000"]
  web_origins         = ["http://localhost:3000"]
  oidc_conformant     = true

  jwt_configuration {
    alg = "RS256"
  }
}
