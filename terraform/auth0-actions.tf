# Create an action to add the roles to the ID/access token claims.
resource "auth0_action" "roles_action" {
  name    = "add_roles_claim"
  runtime = "node22"
  deploy  = true
  code    = file("${path.module}/../dist/post-login-action.js")
  dependencies {
    name    = "axios"
    version = "1.13.4"
  }


  supported_triggers {
    id      = "post-login"
    version = "v3"
  }
}

# Attach the action to the login flow
resource "auth0_trigger_actions" "login_flow" {
  trigger = "post-login"

  actions {
    id           = auth0_action.roles_action.id
    display_name = auth0_action.roles_action.name
  }
}

