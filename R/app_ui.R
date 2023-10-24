#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny micromodal bslib shinyWidgets
#' @noRd
app_ui <- function(request) {

  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    page_fluid(

      tags$style(
        HTML(
          "@font-face {
    font-family: 'Hunger Games';
    src: url('www/Hunger Games.ttf') format('truetype');
  }",
  ".modal__title{
  font-family: 'Playpen Sans';
  }")),

      setBackgroundImage(
        src = "www/hg_bg2.png"
      ),

      title = "May the Odds be Ever in your Favour",

      theme = bs_theme(version = 5,
                       preset = "shiny",
                       heading_font = font_face(
                         family = 'Hunger Games',
                         src = "url('Hunger Games.ttf') format('truetype')"),
                       base_font = font_google(family = "Playpen Sans")),

      use_micromodal(),

      mod_questionnaire_ui("questionnaire"),

      br(),

      mod_display_prediction_ui("dpred"),

      br(),
      # verbatimTextOutput("user_out"),
  fluidRow(
    column(12, align = "center",
      actionButton(
        "sign_out",
        "Sign Out",
        icon = icon("sign-out-alt"),
        # class = "pull-right",
        style = "margin: 0 auto;"
      )
))
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "gdg"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
