require(keras)

setwd("/users/jelle/documents/github/helloworldcpp/data")

dat <- read.csv("sim0.csv")
dat$game_id <- NULL
dat <- as.matrix(dat)

train_sample <- sample(c(T, T, F), nrow(dat), replace=T)

train_x <- dat[train_sample, -929]
train_y <- dat[train_sample, 929]
test_x <- dat[!train_sample, -929]
test_y <- dat[!train_sample, 929]
rm(dat)
gc()

# We're missing a normalization step here

model <- keras_model_sequential()
model %>%
  layer_dense(units = 40, input_shape = c(NULL)) %>%
  layer_dense(units = 20, activation = "relu") %>%
  layer_dense(units = 1, activation = 'sigmoid')
	
	model %>% compile(
	  optimizer = 'adam', 
	  loss = 'binary_crossentropy',
	  metrics = c('accuracy')
	)

model %>% fit(
	train_x,
	train_y,
	epochs = 50,
	batch_size=1000,
	validation_data = list(test_x, test_y),
	verbose = 2)

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

## layer1 <- read.csv("AI_weights_layer1.csv", stringsAsFactors=F, header=F)