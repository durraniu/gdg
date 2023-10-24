#' helpers
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
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



read.db <- function(db_endpoint, auth_token) {
  r <- httr::GET(
    sprintf("https://firestore.googleapis.com/v1beta1/%s", db_endpoint),
    httr::add_headers(
      "Content-Type" = "application/json",
      "Authorization" = paste("Bearer", auth_token)
    )
  )
  return(r)
}



write.db <- function(db_endpoint, data, auth_token) {
  r <- httr::POST(sprintf("https://firestore.googleapis.com/v1beta1/%s", db_endpoint),
                  httr::add_headers(
              "Content-Type" = "application/json",
              "Authorization" = paste("Bearer", auth_token)
            ),
            body = data
  )
  return(r)
}


update.db <- function(db_endpoint, document_id, data, auth_token) {
  r <- httr::PATCH(
    sprintf("https://firestore.googleapis.com/v1beta1/%s/%s", db_endpoint, document_id),
    httr::add_headers("Content-Type" = "application/json", "Authorization" = paste("Bearer", auth_token)),
    body = data
  )
  return(r)
}



delete.db <- function(db_endpoint, auth_token) {
  r <- httr::DELETE(sprintf("https://firestore.googleapis.com/v1beta1/%s", db_endpoint),
                    httr::add_headers("Content-Type" = "application/json",
                          "Authorization" = paste("Bearer", auth_token)))
  return(r)
}
