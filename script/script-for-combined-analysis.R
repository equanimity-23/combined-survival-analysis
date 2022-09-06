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


# figuring out to do it (archived)-------------------------------

install.packages("simsurv")
library(simsurv)

covs <- data.frame(id = 1:200, 
                   trt = rbinom(200, 1, 0.5))

dat <- simsurv(lambdas = 0.1,
               gammas = 1.5, 
               betas = c(trt = -0.5),
               x = covs)

dat <- merge(covs, dat)

cox.dat <- coxph(Surv(eventtime, status) ~ trt, data = dat)
cox.zph(cox.dat)

dat.curves <- survfit(Surv(eventtime, status) ~ trt, data = dat)
ggsurvplot(dat.curves, data = dat)

covs.2 <- data.frame(id = 1:200, 
                     trt = rbinom(200, 1, 0.5))

dat.2 <- simsurv(lambdas = 0.1,
                 gammas = 1.5, 
                 betas = c(trt = -0.5),
                 x = covs.2)

dat.2 <- merge(covs.2, dat.2)

cox.dat2 <- coxph(Surv(eventtime, status) ~ trt, data = dat.2)
cox.zph(cox.dat2)

dat2.curves <- survfit(Surv(eventtime, status) ~ trt, data = dat.2)
ggsurvplot(dat2.curves, data = dat.2)

#-------- testing the model with a data list
model <- Surv(eventtime, status) ~ trt
coxph(model, dat) # works
coxph(model, dat.2) # works

# create list
df.list <- list(A = dat, B = dat.2)
names(df.list)

# use lapply
cox.combined <- lapply(df.list, function(x) coxph(model, x))

