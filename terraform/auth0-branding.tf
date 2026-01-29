# Branding with custom Universal Login template
resource "auth0_branding" "brand" {
  logo_url = "https://uat.login.nine.com.au/client-images/themes/9now/client-logo.svg?v=1611008630764"

  colors {
    primary         = "#19BEFF"
    page_background = "#FFFFFF"
  }

  universal_login {
    body = file("${path.module}/../src/universal-login/universal_login_body.html")
  }
}


