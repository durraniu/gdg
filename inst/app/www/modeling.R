library(survival)
library(tidymodels)
library(censored)
library(survminer)
tidymodels_prefer()


data <- readr::read_csv(file = here::here("inst/app/www/Hunger Games survival analysis data set.csv"))


# Create a failure variable
data <- data %>%
  mutate(failure = ifelse(winner == 0, 1, 0))


ph_spec <-
  proportional_hazards() %>%
  set_engine("survival") %>%
  set_mode("censored regression")
ph_spec



set.seed(1)
ph_fit <- ph_spec %>% fit(survival::Surv(survival_days, failure) ~  sex + age + career + rating_rand , data = data)

tidy(ph_fit)



# predictions <- predict(
#   ph_fit,
#   data |> select(sex, age, career, rating_rand),
#   type = "survival",
#   eval_time = c(5, 10, 19, 20)
# ) %>%
#   slice(1) %>%
#   tidyr::unnest(col = .pred)


make_prediction <- function(sex, age, career, rating_rand){
 predict(
  ph_fit,
  tibble(
  sex = sex, age = age, career = career, rating_rand = rating_rand
),
  type = "survival",
  eval_time = c(1, 10, 20)
) %>%
  tidyr::unnest(col = .pred)
}

foo <- make_prediction(1, 16, 0, 11)

