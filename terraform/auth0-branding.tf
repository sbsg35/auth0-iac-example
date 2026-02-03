# Prompts - Set to Classic Universal Login experience

resource "auth0_prompt" "prompts" {
  universal_login_experience = "new"
}

# Branding with custom Universal Login template
# for custom universal login html file, we need a custom domain to be set up in auth0
# this is because auth0 doesn't want to allow arbitrary html to be hosted on their default domain for security reasons
resource "auth0_branding" "brand" {
  count      = var.custom_domain != null ? 1 : 0
  depends_on = [auth0_prompt.prompts]

  universal_login {
    body = file("${path.module}/../src/html/universal_login.html")
  }
}



# Uncomment below to enable classic login page instead of universal login
# you will also need to comment out the auth0_branding resource above and update the auth0_prompt resource to set universal_login_experience to "classic"
# resource "auth0_pages" "classic_login" {
#   login {
#     html    = file("${path.module}/../src/html/classic_login.html")
#     enabled = true
#   }
# }
