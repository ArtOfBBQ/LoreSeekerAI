require(xgboost)

setwd("/users/jelle/documents/github/LoreSeekerAI")
source("Queries/read_ls_data.R")

data_list <- read_loreseeker_data("sim00.csv")

xgb.cv(
    params = list(objective = "binary:logistic"),
    data_list$train_x,
    nrounds=50,
    nfold=5,
    label = data_list$train_y,
    missing = NA,
    prediction = FALSE,
    showsd = TRUE,
    metrics = list("error"),
    obj = NULL,
    feval = NULL,
    stratified = TRUE,
    folds = NULL,
    train_folds = NULL,
    verbose = TRUE,
    print_every_n = 1L,
    early_stopping_rounds = NULL,
)

myxgb <- xgboost(
    params = list(objective = "binary:logistic"),
    data = data_list$train_x,
    nrounds=50,
    label = data_list$train_y,
    missing = NA,
    showsd = TRUE,
    obj = NULL,
    feval = NULL,
    stratified = TRUE,
    verbose = TRUE,
    print_every_n = 1L,
    early_stopping_rounds = NULL,
    xgb_model = myxgb
)


for (i in 1:18) {
	filename <- paste0("sim", 0, i, ".csv")
	if (i > 9) { filename <- paste0("sim", i, ".csv")}
	print(paste("Running xgboost run on file: ", filename))
	data_list <- read_loreseeker_data(filename)
	
	myxgb <- xgboost(
        params = list(objective = "binary:logistic"),
        data = data_list$train_x,
        nrounds=50,
        label = data_list$train_y,
        missing = NA,
        showsd = TRUE,
        obj = NULL,
        feval = NULL,
        stratified = TRUE,
        verbose = TRUE,
        print_every_n = 1L,
        early_stopping_rounds = NULL,
        xgb_model = myxgb
       
     predictions <- predict(myxgb, data_list$test_x)
	 comparison <- round(predictions) == data_list$test_y
	 paste("Validation accuracy: ", sum(comparison) / length(comparison))
)

}
	
rm(data_list)
gc()

