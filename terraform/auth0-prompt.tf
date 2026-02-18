resource "auth0_prompt_custom_text" "example" {
  prompt   = "login"
  language = "en"
  body = jsonencode(
    {
      "login" : {
        "description" : "Login to $${clientName} using ninepass account",
      }
    }
  )
}
