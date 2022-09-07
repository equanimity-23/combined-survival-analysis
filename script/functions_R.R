# Functions script
## 1. data import function
get_data <- function(file) {
  read_csv(file, col_types = cols()) %>%
    as_tibble() %>%
    filter(Virus == 1)
}
### testing the function -> WORKING
dcv <- get_data("DCV_data/880_DCV.csv")

## 2. fit data to coxme model
fit_cox <- function(data) {
  coxme(Surv(Days, Survival)~ Mutant + (1|BiolRep/TechRep), data) %>%
    print()
}

fit_cox(data)
