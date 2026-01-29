terraform {
  required_version = ">= 1.5.0"

  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 1.38.0" # Refer to docs for latest version
    }
    ## Add other providers here
  }
}
