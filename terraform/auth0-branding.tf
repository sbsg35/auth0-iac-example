# An example of a fully configured auth0_branding_theme.
resource "auth0_branding_theme" "my_theme" {
  borders {
    button_border_radius = 3
    button_border_weight = 1
    buttons_style        = "rounded"
    input_border_radius  = 3
    input_border_weight  = 1
    inputs_style         = "rounded"
    show_widget_shadow   = true
    widget_border_weight = 0
    widget_corner_radius = 5
  }

  colors {
    body_text                 = "#1A1A1A"
    error                     = "#D62828"
    header                    = "#1A1A1A"
    icons                     = "#19BEFF"
    input_background          = "#FFFFFF"
    input_border              = "#E0E0E0"
    input_filled_text         = "#1A1A1A"
    input_labels_placeholders = "#6B6B6B"
    links_focused_components  = "#19BEFF"
    primary_button            = "#19BEFF"
    primary_button_label      = "#FFFFFF"
    secondary_button_border   = "#19BEFF"
    secondary_button_label    = "#19BEFF"
    success                   = "#28A745"
    widget_background         = "#FFFFFF"
    widget_border             = "#E0E0E0"
  }

  fonts {
    font_url            = "https://google.com/font.woff"
    links_style         = "normal"
    reference_text_size = 12

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
    background_color = "#000000"
    page_layout      = "center"
  }

  widget {
    header_text_alignment = "center"
    logo_height           = 55
    logo_position         = "center"
    logo_url              = "https://uat.login.nine.com.au/client-images/themes/9now/client-logo.svg?v=1611008630764"
    social_buttons_layout = "bottom"
  }
}
