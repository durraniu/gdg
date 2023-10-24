#' questionnaire UI Function
#'
#' @description A shiny Module to ask questions to user.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList sliderInput
#' @importFrom shinyWidgets radioGroupButtons materialSwitch
#' @importFrom micromodal micromodal
#' @importFrom shinyjs html disable enable
#' @importFrom jsonlite toJSON
mod_questionnaire_ui <- function(id){
  ns <- NS(id)


    form_inputs <- div(

    # sex
    radioGroupButtons(
      inputId = ns("sex"),
      label = "Are you a girl or a boy?",
      choices = list("Girl" = 1L, "Boy" = 0L),
      status = "primary",
      selected = character(0)
    ),

    br(),
    # age
    sliderInput(
      inputId = ns("age"),
      label = "What is your age?",
      min = 12,
      max = 18,
      value = 15,
      step = 1
    ),

    br(),
    # career
    radioGroupButtons(
      inputId = ns("career"),
      label = "I am a career tribute.",
      choices = list("Yes" = 1L, "No" = 0L),
      status = "primary",
      selected = character(0)
    ),

    br(),
    # career
    sliderInput(
      inputId = ns("rating"),
      label = "How would you rate your survival skills?",
      min = 3,
      max = 11,
      value = 5,
      step = 1
    )

)

    tagList(
# Button to start the form ---------------------------------------
h1("How long would you survive the Hunger Games?",
   style = "text-align: center;"),
br(),

fluidRow(
  column(12, align = "center",
         actionButton(ns("start_intake"),
                      label = "Click to find out",
                      `data-micromodal-trigger` = ns("modal-form"),
                      style = "margin: 0 auto; background-color: black; border-color: white; color: white;"
         )

  )
),

# First page: Demographics (triggered by start_intake button) -------------
micromodal(
  id = ns("modal-form"),
  title = "Complete this form to find out your chances of surviving Hunger Games",
  content = tagList(
    form_inputs
  ),
  footer = tagList(
    ## Submit
    ## Clicking this button closes this page
    actionButton(ns("form_submit"),
                 label = "Submit",
                 class = "modal__btn modal__btn-primary",
                 `data-micromodal-close` = NA
    )
  )
)



  )
}

#' questionnaire Server Functions
#'
#' @noRd
mod_questionnaire_server <- function(id, accessToken, email){

  stopifnot(is.reactive(email))
  stopifnot(is.reactive(accessToken))

  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # Form inputs in one list
    form_inputs <- reactive({
      list(
       sex    = as.integer(input$sex),
       age    = as.integer(input$age),
       career = as.integer(input$career),
       rating = as.integer(input$rating)
      )
    })


    # Send form data to firestore------------------------
    ## Form data is sent to firestore when the user clicks on 'Submit' button

    values <- reactiveValues(input_list = NULL)

    observeEvent(
      input$form_submit,
      {
        form_data_list <- toJSON(list(
          fields = list(
            uid = list("stringValue" = email()),
            Sex = list("integerValue" = form_inputs()[["sex"]]),
            Age = list("integerValue" = form_inputs()[["age"]]),
            Career = list("integerValue" = form_inputs()[["career"]]),
            Rating = list("integerValue" = form_inputs()[["rating"]])
          )
        ), auto_unbox = TRUE)


        ## writing data
        endpoint_quiz <- "projects/gdg-demo-b8928/databases/(default)/documents/Quiz"
        write_request_quiz <- write.db(
          db_endpoint = paste0(endpoint_quiz, "?documentId=", email()),
          data = form_data_list,
          auth_token = accessToken()
        )

        ## overwriting data if already exists
        if (write_request_quiz$status_code == 409L) {
          update.db(
            db_endpoint = endpoint_quiz,
            document_id = email(),
            data = form_data_list,
            auth_token = accessToken()
          )
        }


        ## Change the label on the button.
        ## The button is previously labelled as 'Click to find out'. When the user clicks on
        ## 'Submit' button at the end of form, the label
        ## changes to 'Complete' and the button gets disabled.
        shinyjs::html("form_submit", html = "Submitted!")
        shinyjs::html("start_intake", html = "Complete")
        shinyjs::disable("start_intake")

        ## updated list with all responses
        values$input_list <- list(
          "in_form" = form_inputs()
        )
      }
    )


    observe({
      ## Do not allow to click Submit if even one question is unanswered.
      if (is.null(form_inputs()) | any(list(NULL) %in% form_inputs()) | any("" %in% form_inputs())) {
        shinyjs::disable("form_submit")
      } else {
        shinyjs::enable("form_submit")
      }

    })

    return(
      ## The list with all responses is returned as a reactive expression
      reactive({
        values$input_list
      })
    )

  })
}

## To be copied in the UI
# mod_questionnaire_ui("questionnaire_1")

## To be copied in the server
# mod_questionnaire_server("questionnaire_1")
