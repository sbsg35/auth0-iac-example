# Create a custom API for the application
resource "auth0_resource_server" "my_api" {
  name       = "login-api"
  identifier = "https://api.happynewyear.world"

  # Skip consent for first-party clients (your own apps)
  skip_consent_for_verifiable_first_party_clients = true

  signing_alg    = "RS256"
  token_lifetime = 86400
}
