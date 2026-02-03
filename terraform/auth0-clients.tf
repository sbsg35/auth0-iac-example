# Create a new Auth0 application for OIDC authentication
resource "auth0_client" "microsoft_oidc_client" {
  name                = "microsoft"
  description         = "Microsoft OIDC Client Created Through Terraform"
  app_type            = "spa"
  logo_uri            = "https://cdn.brandfetch.io/idchmboHEZ/theme/dark/symbol.svg?c=1dxbfHSJFAPEGdCLU4o5B"
  callbacks           = ["http://localhost:3000/callback", "http://localhost:3000"]
  allowed_logout_urls = ["http://localhost:3000"]
  allowed_origins     = ["http://localhost:3000"]
  web_origins         = ["http://localhost:3000"]
  oidc_conformant     = true

  jwt_configuration {
    alg = "RS256"
  }
}


# tesla client

resource "auth0_client" "tesla_oidc_client" {
  name        = "tesla"
  description = "tesla OIDC Client Created Through Terraform"
  app_type    = "spa"
  logo_uri    = "https://upload.wikimedia.org/wikipedia/commons/b/bd/Tesla_Motors.svg"
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

