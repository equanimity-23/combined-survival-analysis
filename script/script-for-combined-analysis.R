library(survival)

# Actual data-----------------    
## Importing data into a list 
my_files <- list.files(pattern = "*.csv")
my_data <- lapply(my_files, read.csv)
names(my_data) <- gsub("*.csv", "", my_files)

## Specify the model attributes
model <- Surv(Days, Survival) ~ Mutant

mixed_effects <- Surv(Days, Survival) ~ Mutant + (1|BiolRep/TechRep)

## Run the analysis across the dataset -> pick which one you want
lapply(my_data, function(x) coxph(model, x))


fit = lapply(my_data, function(x) coxme(mixed_effects, x))


## test for cox assumptions
lapply(my_data, function(x) cox.zph(coxme(mixed_effects, x))) # THIS DOES NOT WORK!
# should i split the data list back into coxme objects then loop the cox.zph function through each?

## plotting survival curves

