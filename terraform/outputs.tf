output "auth0_nine_client_id" {
  description = "Auth0 SPA Client ID"
  value       = auth0_client.nine_oidc_client.client_id
}

output "auth0_stan_oidc_client" {
  description = "Auth0 SPA Client ID"
  value       = auth0_client.stan_oidc_client.client_id
}

