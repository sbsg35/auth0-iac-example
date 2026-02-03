# m2m clients
resource "auth0_client" "m2m_client" {
  name        = "tesla-m2m"
  description = "Machine to machine client for internal services"
  app_type    = "non_interactive"
}

resource "auth0_client_credentials" "m2m_client_credentials" {
  client_id             = auth0_client.m2m_client.id
  authentication_method = "client_secret_post"
}

resource "auth0_client_grant" "m2m_client_grant" {
  client_id = auth0_client.m2m_client.id
  audience  = auth0_resource_server.events_api.identifier
  scopes    = ["write:events", "delete:events"]
}

# microsoft m2m client
resource "auth0_client" "microsoft_m2m_client" {
  name        = "microsoft-m2m"
  description = "Machine to machine client for 9now internal services"
  app_type    = "non_interactive"
}

resource "auth0_client_credentials" "microsoft_m2m_client_credentials" {
  client_id             = auth0_client.microsoft_m2m_client.id
  authentication_method = "client_secret_post"
}

resource "auth0_client_grant" "microsoft_m2m_client_grant" {
  client_id = auth0_client.microsoft_m2m_client.id
  audience  = auth0_resource_server.events_api.identifier
  scopes    = ["read:events", "list:events", "write:events", "delete:events"]
}
