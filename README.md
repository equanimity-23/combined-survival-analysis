# combined-survival-analysis
Automated combined survival analysis in R

## Daily Notes
### 6th Sept
- The code is working up to the coxme analysis of the entire DCV dataset.
- cox.zph is not working as it requires the coxme object, but I do not know how to pull it into the loop.
- Other issues I have noticed:
  - When running coxme as a loop, the data variable is termed as "x", rather than the miRNA itself. I believe this is the nature      of the loop. 
  - I need to rename all of the datasets to be "DCV_stockNo." as the numerals first is causing issues with the R code. 
