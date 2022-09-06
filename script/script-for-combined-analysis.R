library(survival)
library(dplyr)
library(coxme)
library(survminer)

# DCV data----------------- 
## Import data  
### list file names -> import using a for loop -> rename files within the data list
dcv_files <- list.files(path = "DCV_data", pattern = "*.csv")

dcv_data <- list()
for (i in 1:length(dcv_files)) {
  dcv_data[[i]] <- read.csv(paste0("DCV_data/", dcv_files[i]), header = T, sep = ",")
}

names(dcv_data) <- gsub("*.csv", "", dcv_files)

## making sure data is coded as factors
### not working yet

## removing PBS samples
dcv_noPBS <- lapply(dcv_data, function(x) filter(x, Virus == 1))

## Specify the model attributes
mixed_effects <- Surv(Days, Survival) ~ Mutant + (1|BiolRep/TechRep)

model <- Surv(Days, Survival) ~ Mutant

## Run the analysis across the dataset -> pick which one you want
dcv_fit <- lapply(dcv_noPBS, function(x) coxme(mixed_effects, x))

lapply(dcv_noPBS, function(x) coxph(model, x)) # CoxPH model

## Split the coxme fit into separate dataframes
list2env(dcv_fit, .GlobalEnv)



## test for cox assumptions
lapply(dcv_fit, function(x) cox.zph(x)) # THIS DOES NOT WORK!
# should i split the data list back into coxme objects then loop the cox.zph function through each?

## plotting survival curves







miRNAcurves <- survfit(Surv(Days, Survival) ~ Mutant, data=DCV_noPBS)
ggsurvplot(miRNAcurves,
           data = DCV_noPBS,               #change to the virus under analysis
           axes.offset = FALSE,            #changes axes to start at zero
           line = c(1,1),
           pval = 0.19,             #change to coxme pvalue
           xlab = "Time in days",
           ylab = "Proportional survival",
           break.time.by = 1, 
           break.y.by = 0.2,
           ggtheme = theme_classic(),
           legend.title = "Genotype",      #change legend title to suit your analysis
           legend.labs = 
             c("w1118", "miR- KO")         #change the legends to the miRNA
)

# Save survival plot ----
ggsave(here("plots", "example.png"))


