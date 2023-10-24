#' Get probabilities of surviving on the 1st, 10th, and 20th day in the 74th hunger games
#'
#' @param sex integer. 1 = Female, 0 = Male.
#' @param age numeric. 12 - 18 years.
#' @param career integer. 1 = yes, 0 = no.
#' @param rating_rand numeric. Gamekeepers rating. 3- 11.
#'
#' @return a dataframe with probabilities of surving on 1st, 10th, and 20th day.
#' @export
#'
#' @examples
#' make_prediction(1, 16, 0, 11)
make_prediction <- function(sex, age, career, rating_rand){

  if (is.null(sex) | is.null(age) | is.null(career) | is.null(rating_rand)){
    return(NULL)
  }
 predict(
    readRDS(system.file("models/ph_fit.rds", package = "gdg")),
    tibble::tibble(
      sex = sex, age = age, career = career, rating_rand = rating_rand
    ),
    type = "survival",
    eval_time = c(1L, 10L, 20L)
  ) |>
    tidyr::unnest(col = .pred)
}
