# Forms Management M2M Client
resource "auth0_client" "forms_management_m2m" {
  name        = "forms-management-m2m"
  description = "Machine to machine client for forms management"
  app_type    = "non_interactive"
}

resource "auth0_client_credentials" "forms_management_m2m_credentials" {
  client_id             = auth0_client.forms_management_m2m.id
  authentication_method = "client_secret_post"
}

resource "auth0_client_grant" "forms_management_m2m_grant" {
  client_id = auth0_client.forms_management_m2m.id
  audience  = "https://${var.auth0_domain}/api/v2/"
  scopes = [
    "read:users",
    "update:users",
    "create:users",
    "read:users_app_metadata",
    "update:users_app_metadata",
    "create:users_app_metadata"
  ]
}


# vault connection
resource "auth0_flow_vault_connection" "forms_management_vault_connection" {
  name   = "forms-management-vault"
  app_id = "AUTH0"

  setup = {
    client_id     = auth0_client.forms_management_m2m.client_id
    client_secret = auth0_client_credentials.forms_management_m2m_credentials.client_secret
    domain        = var.auth0_domain
    type          = "OAUTH_APP"
  }
}


# Auth0 progressive profiling form
resource "auth0_form" "progressive_profiling_form" {
  name = "progressive-profiling-form"

  start = jsonencode({
    next_node   = "step_details"
    coordinates = { x = 0, y = 0 }
  })

  nodes = jsonencode([
    {
      id          = "step_details"
      type        = "STEP"
      coordinates = { x = 250, y = 0 }
      alias       = "Details Step"
      config = {
        components = [
          {
            id       = "rich_text_heading"
            category = "BLOCK"
            type     = "RICH_TEXT"
            config   = { content = "<h1>We need more details</h1><p>To provide you with the best experience, we need a bit more information about you.</p>" }
          },
          {
            id       = "full_name"
            category = "FIELD"
            type     = "TEXT"
            label    = "Full Name"
            required = true
          },
          # --- ADDED GENDER FIELD START ---
          {
            id       = "gender"
            category = "FIELD"
            type     = "CHOICE"
            label    = "Gender"
            required = true
            config = {
              options = [
                { label = "Male", value = "male" },
                { label = "Female", value = "female" },
                { label = "Other", value = "other" }
              ]
            }
          },
          # --- ADDED GENDER FIELD END ---
          {
            id       = "next_button"
            category = "BLOCK"
            type     = "NEXT_BUTTON"
            config   = { text = "Continue" }
          }
        ]
        next_node = "flow_update_user"
      }
    },
    {
      id          = "flow_update_user"
      type        = "FLOW"
      coordinates = { x = 800, y = 0 }
      alias       = "Update User Metadata"
      config = {
        flow_id   = auth0_flow.progressive_profiling_flow.id
        next_node = "$ending"
      }
    }
  ])

  ending = jsonencode({
    resume_flow = true
    coordinates = { x = 1200, y = 0 }
  })
}


# Example:
resource "auth0_flow" "progressive_profiling_flow" {
  actions = jsonencode([{
    action        = "UPDATE_USER"
    alias         = "user meta data"
    allow_failure = false
    id            = "update_user_flow"
    mask_output   = false
    params = {
      changes = {
        user_metadata = {
          full_name = "{{fields.full_name}}"
          gender    = "{{fields.gender}}"
        }
      }
      connection_id = "${auth0_flow_vault_connection.forms_management_vault_connection.id}" #  Altenative ways: (connection_id = auth0_flow_vault_connection.my_connection.id) or using terraform variables
      user_id       = "{{context.user.user_id}}"
    }
    type = "AUTH0"
  }])
  name = "Flow progressive profiling update data"
}
