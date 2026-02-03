# Create a custom API for the application
resource "auth0_resource_server" "my_api" {
  name       = "login-api"
  identifier = var.custom_domain != null ? "https://api.${var.custom_domain}" : "https://api.example.com"

  # Skip consent for first-party clients (your own apps)
  skip_consent_for_verifiable_first_party_clients = true

  signing_alg    = "RS256"
  token_lifetime = 86400
}

# events api
resource "auth0_resource_server" "events_api" {
  name       = "events-api"
  identifier = var.custom_domain != null ? "https://events.${var.custom_domain}" : "https://events.example.com"

  # Skip consent for first-party clients (your own apps)
  skip_consent_for_verifiable_first_party_clients = true

  signing_alg    = "RS256"
  token_lifetime = 86400
}

resource "auth0_resource_server_scopes" "events_api_scopes" {
  resource_server_identifier = auth0_resource_server.events_api.identifier

  scopes {
    name        = "read:events"
    description = "Read events"
  }

  scopes {
    name        = "list:events"
    description = "List events"
  }

  scopes {
    name        = "write:events"
    description = "Create and update events"
  }

  scopes {
    name        = "delete:events"
    description = "Delete events"
  }
}

