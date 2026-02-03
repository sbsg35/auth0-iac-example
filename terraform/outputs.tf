output "auth0_microsoft_client_id" {
  description = "Auth0 SPA Client ID"
  value       = auth0_client.microsoft_oidc_client.client_id
}

output "auth0_tesla_oidc_client" {
  description = "Auth0 SPA Client ID"
  value       = auth0_client.tesla_oidc_client.client_id
}
