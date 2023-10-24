api_key <- "AIzaSyCV-gUz8Mtu2XeJroz3zru262uJ9nakn2A"


sign.in <- function(email, password, api_key) {
  r <- httr::POST(paste0("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=", api_key),
                  httr::add_headers("Content-Type" = "application/json"),
                  body = jsonlite::toJSON(list(email = email,
                                               password = password,
                                               returnSecureToken = TRUE),
                                          auto_unbox = TRUE)
  )
  return(httr::content(r))
}


user <- sign.in("example@email.com", "examplepass", api_key)
accessToken <- user$idToken
email <- user$email



read.db <- function(db_endpoint, auth_token) {
  r <- httr::GET(sprintf("https://firestore.googleapis.com/v1beta1/%s", db_endpoint),
                 httr::add_headers("Content-Type" = "application/json",
                                   "Authorization" = paste("Bearer", auth_token)))
  return(r)
}


# read.db("projects/gdg-demo-b8928/databases/(default)/documents/test",
#         accessToken)


# https://console.cloud.google.com/apis/api/firestore.googleapis.com/overview?project=gdg-demo



form_inputs <- list(
    sex = as.integer("0"),
    age = as.integer(15),
    career = as.integer("1"),
    rating = as.integer(5)
  )


form_list <- list(
  "in_form" = form_inputs
)

library(jsonlite)
# form_data_list <- toJSON(list(
#   fields = list(
#     uid = list("stringValue" = email),
#     Sex = list("integerValue" = as.integer(form_inputs[["sex"]])),
#     Age = list("integerValue" = as.integer(form_inputs[["age"]])),
#     Career = list("integerValue" = as.integer(form_inputs[["career"]])),
#     Rating = list("integerValue" = as.integer(form_inputs[["rating"]]))
#   )
# ), auto_unbox = TRUE)
#
#
# ## writing data
# endpoint_quiz <- "projects/gdg-demo-b8928/databases/(default)/documents/Quiz"
# write_request_quiz <- write.db(
#   db_endpoint = paste0(endpoint_quiz, "?documentId=", email),
#   data = form_data_list,
#   auth_token = accessToken
# )
#
# ## overwriting data if already exists
# if (write_request_quiz$status_code == 409L) {
#   update.db(
#     db_endpoint = endpoint_quiz,
#     document_id = email,
#     data = form_data_list,
#     auth_token = accessToken
#   )


user_inputs <- form_list$in_form

user_preds <- make_prediction(user_inputs$sex, user_inputs$age, user_inputs$career, user_inputs$rating)


pred_text <- paste0("Your chances of survival:\nDay 1: ",
       round(100*(user_preds[user_preds$.eval_time==1L,]$.pred_survival),1), "%\nDay 10: ",
       round(100*(user_preds[user_preds$.eval_time==10L,]$.pred_survival),1), "%\nDay20: ",
       round(100*(user_preds[user_preds$.eval_time==20L,]$.pred_survival),1), "%")



pred_list <- toJSON(list(
  fields = list(
    uid = list("stringValue" = email),
    Prediction = list("stringValue" = pred_text))
), auto_unbox = TRUE)


## writing data
endpoint_prediction <- "projects/gdg-demo-b8928/databases/(default)/documents/Prediction"

write_request_prediction <- write.db(
  db_endpoint = paste0(endpoint_prediction, "?documentId=", email),
  data = pred_list,
  auth_token = accessToken
)

## overwriting data if already exists
if (write_request_prediction$status_code == 409L) {
  update.db(
    db_endpoint = endpoint_prediction,
    document_id = email,
    data = pred_list,
    auth_token = accessToken
  )
}
