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

  secrets {
    name  = "PROGRESSIVE_PROFILE_FORM_ID"
    value = auth0_form.progressive_profiling_form.id
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


## Pre registration action for progressive profiling
resource "auth0_action" "post_resgistration_action" {
  name    = "post_resgistration_action"
  runtime = "node22"
  deploy  = true
  code    = file("${path.module}/../dist/post-registration-action.js")
  dependencies {
    name    = "axios"
    version = "1.13.4"
  }

  secrets {
    name  = "PROGRESSIVE_PROFILE_FORM_ID"
    value = auth0_form.progressive_profiling_form.id
  }

  supported_triggers {
    id      = "post-user-registration"
    version = "v2"
  }
}

# Attach the action to the pre-registration flow
resource "auth0_trigger_actions" "pre_registration_flow" {
  trigger = "post-user-registration"

  actions {
    id           = auth0_action.post_resgistration_action.id
    display_name = auth0_action.post_resgistration_action.name
  }
}
