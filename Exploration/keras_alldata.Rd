require(keras)

setwd("/users/jelle/documents/github/LoreSeekerAI/models")
source("../Queries/read_ls_data.R")
# model <- load_model_tf("kerasdeepnn")
	
	setwd("/users/jelle/documents/github/helloworldcpp/data")
	
	l1reglambda <- 0.001
	lambda <- 0.002
	
	# layers:
	# 60 -> 10 got about 0.774 in 1 run
	# 60 -> 17 got about 0.78 in 1 run
	# 60 -> 20 got about 0.78 in 1 run
	# 60 -> 30 got about 0.76 in 1 run
	# 40 -> 17 got about 0.774 in 1 run
	# 55 -> 17 got about 0.771 in 1 run
	# 80 -> 17 got about 0.7745 in 1 run
	# 120 -> 17 got about 0.77 in 1 run
	# dropouts 0.15 -> 0.07 got 0.78 in 1 run
	# dropouts 0.1 -> 0.07 got 0.7725 in 1 run
	# dropouts 0.07 -> 0.07 got 0.7799 in 1 run
	# dropouts 0.15 -> 0.15 got 0.768 in 1 run
	# dropouts 0.15 -> 0.04 got 0.780 in run
	
	model <- keras_model_sequential()
	model %>% 
	layer_dense(
        units = 60,
        activation = "relu",
        kernel_regularizer = regularizer_l1_l2(
            l1 = l1reglambda,
            l2 = lambda)) %>%
    layer_dropout(rate = 0.45) %>% 
    layer_dense(
        units = 17,
        activation = "relu",
        kernel_regularizer = regularizer_l1_l2(
            l1 = l1reglambda,
            l2 = lambda)) %>%
    layer_dropout(rate = 0.4) %>%
    layer_dense(
        units = 1,
        activation = 'sigmoid',
        kernel_regularizer = regularizer_l1_l2(
            l1 = l1reglambda,
            l2 = lambda))
	
	# on 1 training set, we're getting about 0.78 validation accuracy
	# lr = 0.00008, rho = 0.9 did well on 1 training set
	model %>% compile(
	    optimizer = optimizer_rmsprop(
	        lr = 0.00025,
	        rho = 0.9,
	        epsilon = NULL,
	        decay = 0,
	        clipnorm = NULL,
	        clipvalue = NULL), 
	    loss = loss_binary_crossentropy,
	    metrics = metric_binary_accuracy)
	
	allcomparisons <- c()
	accuracies <- c()
	for (i in 0:40) {
	    print(paste0("training iteration: ", i))
	    if (i < 10) {
	        data_list <- read_loreseeker_data(
	        paste0("sim0", i, ".csv"))
	    } else {
	        data_list <- read_loreseeker_data(
	        paste0("sim", i, ".csv"))
	    }
	    
	    # 105 epochs of 512 batches gave 0.762 in 1 run
	    # 220 epochs of 256 batches gave 0.78 in 1 run
	    # 220 epochs of 124 batches gave 0.771 in 1 run
	    # 440 epochs of 124 batches gave 0.773 in 1 run
	    # best result we've had was epochs 220 x batch_size 256 for 0.78 in 1 run
	    model %>% fit(
	        data_list$train_x,
	        data_list$train_y,
	        epochs = round(nrow(data_list$train_x) / 32),
	        batch_size= 32,
	        validation_data = list(data_list$test_x, data_list$test_y),
	        verbose = 2)
	    comparisons <- round(predict(model, data_list$test_x)) == data_list$test_y
	    accuracies <- c(accuracies, sum(comparisons) / length(comparisons))
	    allcomparisons <- c(allcomparisons, comparisons)
	    print(paste(
		     "Validation accuracy so far: ",
		     sum(allcomparisons) / length(allcomparisons)))
		
	    rm(data_list)
	    gc()
	}
	
setwd("/users/jelle/documents/github/LoreSeekerAI/models")

model %>% save_model_tf("kerasdeepnn")


weights <- get_weights(model)


for (i in 1:length(weights)) {

    description <- "weights"
    if (i %% 2 == 0) { description <- "intercepts" }
    layer <- ceiling(i / 2)

    filename <- paste0(
        "AI_",
        description,
        "_layer",
        layer,
        ".csv")

    write.table(
        weights[i], 
        file=filename,
        sep=",",
        row.names=F,
        col.names=F)
}

