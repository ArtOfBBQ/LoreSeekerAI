require(xgboost)

setwd("/users/jelle/documents/github/LoreSeekerAI")
source("Queries/read_ls_data.R")

nrounds_per_file <- 50
# 1x50 + 18 x 5 rounds for ~82% accuracy
# 18 x 15 rounds for ~82%x accuracy
# 18 x 50 rounds for ~82% accuracy

data_list <- read_loreseeker_data("sim00.csv")
myxgb <- xgboost(
    params = list(objective = "binary:logistic"),
    data = data_list$train_x,
    nrounds = nrounds_per_file,
    label = data_list$train_y,
    missing = NA,
    showsd = TRUE,
    obj = NULL,
    feval = NULL,
    stratified = TRUE,
    verbose = TRUE,
    print_every_n = 1L,
    early_stopping_rounds = NULL,
)

allcomparisons <- c()
for (i in 1:18) {
	filename <- paste0("sim", 0, i, ".csv")
	if (i > 9) { filename <- paste0("sim", i, ".csv")}
	print(paste("Running xgboost run on file: ", filename))
	data_list <- read_loreseeker_data(filename)
	
	myxgb <- xgboost(
        params = list(objective = "binary:logistic"),
        data = data_list$train_x,
        nrounds = nrounds_per_file,
        label = data_list$train_y,
        missing = NA,
        obj = NULL,
        feval = NULL,
        verbose = TRUE,
        print_every_n = 1L,
        early_stopping_rounds = NULL,
        xgb_model = myxgb)
     
     predictions <- predict(myxgb, data_list$test_x)
	 comparison <- round(predictions) == data_list$test_y
	 allcomparisons <- c(allcomparisons, comparison)
	 print(paste(
	     "Validation accuracy: ",
	     sum(allcomparisons) / length(allcomparisons)))
	 
	 rm(data_list)
	 gc()
}


