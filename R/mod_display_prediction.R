#' display_prediction UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList req
mod_display_prediction_ui <- function(id){
  ns <- NS(id)
  tagList(

    uiOutput(ns("display_pred"))


  )
}

#' display_prediction Server Functions
#'
#' @noRd
mod_display_prediction_server <- function(id, form_list, accessToken, email){

  stopifnot(is.reactive(form_list))
  stopifnot(is.reactive(email))
  stopifnot(is.reactive(accessToken))

  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # Predictionz
    pred_text <- reactive({
      req(form_list)
      user_inputs <- form_list()$in_form

      user_preds <- make_prediction(user_inputs$sex,
                                    user_inputs$age,
                                    user_inputs$career,
                                    user_inputs$rating)
      if(is.null(user_preds)){
        return(NULL)
      }

      paste0("Your chances of survival:\nDay 1: ",
                        round(100*(user_preds[user_preds$.eval_time==1L,]$.pred_survival),1), "%\nDay 10: ",
                        round(100*(user_preds[user_preds$.eval_time==10L,]$.pred_survival),1), "%\nDay 20: ",
                        round(100*(user_preds[user_preds$.eval_time==20L,]$.pred_survival),1), "%")
    })


    output$display_pred <- renderUI({
      req(form_list())

      imagez <- c("https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExa2N2cjNjNDY1Zml6NGs1dDc1bzBkYjZzMXZ1ZW11a2E0dTQxMDkwaCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/CiXgjFx7tAWas/giphy.gif",
                  "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExaG1kdjltdWhrYXQwOWIyazB5NGlmYTZsOWp4dXgwdnRlZ2E5cHFzaCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/dYGHhPyGjJkxG/giphy.gif",
                  "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExY2ppemxuMHIwanhsN3M4ODB4MTQzbmZkemk5MHVham5lbTM0Z21wNCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/6Xb4I34Be1hFm/giphy.gif",
                  "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExYXM5b25oYWFydm1nMnhtYXVzaTkzbGZwb3c4eHo1dXA1dW0xMXBzdyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/xTiTng7eyNZuXl7GzC/giphy.gif",
                  "https://media.giphy.com/media/BsH0I7tBbP03e/giphy.gif")

div(
      p(pred_text(), style = "text-align: center; color: white; font-size: 20pt; text-shadow: 2px 2px 4px rgba(0,0,0,0.5); background-color: rgba(0,0,0,0.3);"),


      img(
        src = sample(imagez, 1),
        style = "display: block; margin: 0 auto;"
          # width = "300px",
          # height = "200px"
          )
)
    })


  })
}

## To be copied in the UI
# mod_display_prediction_ui("display_prediction_1")

## To be copied in the server
# mod_display_prediction_server("display_prediction_1")
