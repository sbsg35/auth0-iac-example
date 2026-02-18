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
  logo_url   = "https://www.nineforbrands.com.au/wp-content/uploads/2025/06/9_BLUE.png"

  # universal_login {
  #   body = file("${path.module}/../src/html/universal_login.html")
  # }
}

resource "auth0_branding_theme" "nine_theme" {
  borders {
    button_border_radius = 1
    button_border_weight = 1
    buttons_style        = "pill"
    input_border_radius  = 3
    input_border_weight  = 1
    inputs_style         = "pill"
    show_widget_shadow   = false
    widget_border_weight = 1
    widget_corner_radius = 3
  }

  colors {
    body_text                 = "#1e293b"
    error                     = "#ef4444"
    header                    = "#0f172a"
    icons                     = "#1abeff"
    input_background          = "#ffffff"
    input_border              = "#cbd5e1"
    input_filled_text         = "#1e293b"
    input_labels_placeholders = "#64748b"
    links_focused_components  = "#1abeff"
    primary_button            = "#1abeff"
    primary_button_label      = "#ffffff"
    secondary_button_border   = "#1abeff"
    secondary_button_label    = "#1abeff"
    success                   = "#22c55e"
    widget_background         = "#ffffff"
    widget_border             = "#e2e8f0"
  }

  fonts {
    font_url            = "https://google.com/font.woff"
    links_style         = "normal"
    reference_text_size = 16

    body_text {
      bold = false
      size = 100
    }

    buttons_text {
      bold = false
      size = 100
    }

    input_labels {
      bold = false
      size = 100
    }

    links {
      bold = false
      size = 100
    }

    title {
      bold = false
      size = 100
    }

    subtitle {
      bold = false
      size = 100
    }
  }

  page_background {
    background_color     = "#0f172a"
    background_image_url = "https://google.com/background.png"
    page_layout          = "center"
  }

  widget {
    header_text_alignment = "center"
    logo_height           = 55
    logo_position         = "center"
    logo_url              = "https://www.nineforbrands.com.au/wp-content/uploads/2025/06/9_BLUE.png"
    social_buttons_layout = "bottom"
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
