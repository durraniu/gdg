#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {

  polished::polished_config(
    app_name = Sys.getenv("APP_NAME"),
    api_key = Sys.getenv("POLISHED_API_KEY"),

    firebase_config = list(
      apiKey = Sys.getenv("FIREBASE_API_KEY"),
      authDomain = Sys.getenv("AUTH_DOMAIN"),
      projectId = Sys.getenv("PROJECT_ID")
    ),
    sign_in_providers = c("google", "email")
  )



  # customize your sign in page UI with logos, text, and colors.
  my_custom_sign_in_page <- sign_in_ui_default(
    # color = "#006CB5",
    company_name = "Hunger Games Survival Analysis",
    logo_top = NULL,
    logo_bottom = NULL,
    icon_href = NULL,
    background_image = "www/girl_on_fire.png"
  )





  with_golem_options(
    app = shinyApp(
      ui =  polished::secure_ui(
        app_ui,
        sign_in_page_ui = my_custom_sign_in_page#polished::sign_in_ui_default()
        ),
      server = polished::secure_server(app_server),
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
