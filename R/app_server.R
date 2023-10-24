#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny polished shinyjs
#' @noRd
app_server <- function(input, output, session) {

  email <- reactive({session$userData$user()$email})
  accessToken <- reactive({
    api_key <- Sys.getenv("FIREBASE_API_KEY")
    user <- sign.in("example@email.com",  Sys.getenv("PASSWORD"), api_key)
    user$idToken
  })


  shinyjs::disable("questionnaire-form_submit")


  form_list <- mod_questionnaire_server("questionnaire", accessToken, email)


  mod_display_prediction_server("dpred", form_list, accessToken, email)

  # output$user_out <- renderPrint({
  #   session$userData$user()
  # })


  observeEvent(input$sign_out, {
    sign_out_from_shiny()
    session$reload()
  })
}
