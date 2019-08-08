# High Dimensional Restrictive Federated Model Selection with multi-objective Bayesian Optimization over shifted distributions

## Terminology
- **open-box, lock-box and curator-box**: openbox is data you can use as you want for training, lock-box is left over independent dataset for testing,  curator-box is the data you can send your model to it to query how good it is but can not carry out training on it. 

## How to run
- Set working directory to "./R"
- Source R/bt_pre.R to download OpenML dataset to local folder
- Test if all codes work on the Geo and OpenML dataset with low budget: source R/bt_test_geo_oml.R 
- Run complete experiment with full budget: R/bt_playground.R
- To avoid accidently deleting the experiment registry, one should execute the function in
  R/bt_playground.R line by line, then run submitJobs()

### Run on lrz cluster in Munich
- recommendation: test how long it needs to run locally (> 8 hours) first before submit to cluster
- the computation budgets are set in R/lrz_batchtools.conf.R, copy this file as R/batchtools.conf.R
- recommendation: submits according to replication: getJobTable()[, repl]

### Run on lido cluster in Dortmund
- delete the batchtools.conf.R file since that file is for lrz

## Problem with experiments
- Errors like "Error in t.default(T) : argument is not a matrix" occurs, that means in Kriging, the Bayesian Optimization always see a constant target value, which is normal for machine learning predicative performance
- In this case, to ensure fairness (some algorithms might fail by chance), all algorithms are run sequentially on the same computing node as one job, which means if one algorithm fails, there **won't** be result for this job, in which case we could only 
