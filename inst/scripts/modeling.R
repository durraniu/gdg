
# Load Libraries ----------------------------------------------------------

library(survival)
library(tidymodels)
library(censored)
# library(survminer)
tidymodels_prefer()



# Load data ---------------------------------------------------------------

data <- readr::read_csv(file = here::here("data/Hunger Games survival analysis data set.csv"))



# Process data ------------------------------------------------------------

# Create a failure variable
data <- data %>%
  mutate(failure = ifelse(winner == 0, 1, 0))




# Fit a Cox Proportional Hazards Model ------------------------------------

## Model specification
ph_spec <-
  proportional_hazards() %>%
  set_engine("survival") %>%
  set_mode("censored regression")
# ph_spec


## Model fitting
set.seed(1)
ph_fit <- ph_spec %>% fit(survival::Surv(survival_days, failure) ~  sex + age + career + rating_rand , data = data)

tidy(ph_fit)


## Predictions on original data
# predictions <- predict(
#   ph_fit,
#   data |> select(sex, age, career, rating_rand),
#   type = "survival",
#   eval_time = c(5, 10, 19, 20)
# ) %>%
#   slice(1) %>%
#   tidyr::unnest(col = .pred)



# Save the model ----------------------------------------------------------
saveRDS(object = ph_fit, file = here::here("inst/models/ph_fit.rds"))



# make_prediction <- function(sex, age, career, rating_rand){
#  stats::predict(
#   ph_fit,
#   tibble(
#   sex = sex, age = age, career = career, rating_rand = rating_rand
# ),
#   type = "survival",
#   eval_time = c(1, 10, 20)
# ) %>%
#   tidyr::unnest(col = .pred)
# }
#
# foo <- make_prediction(1, 16, 0, 11)

