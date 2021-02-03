require(keras)

setwd("/users/jelle/documents/github/helloworldcpp/data")

dat <- read.csv("sim0.csv")
dat <- as.matrix(dat)

train_sample <- sample(c(T, T, F), nrow(dat), replace=T)

train_x <- dat[train_sample, -930]
train_y <- dat[train_sample, 930]
test_x <- dat[!train_sample, -930]
test_y <- dat[!train_sample, 930]
rm(dat)
gc()

# We're missing a normalization step here

model <- keras_model_sequential()
model %>%
  layer_dense(units=ncol(train_x), input_shape = ncol(train_x)) %>%
  layer_dense(units = 70, activation = 'relu') %>%
  layer_dense(units = 10, activation = "relu") %>%
  layer_dense(units = 1, activation = 'sigmoid')

model %>% compile(
  optimizer = 'adam', 
  loss = 'binary_crossentropy',
  metrics = c('accuracy')
)

model %>% fit(
	train_x,
	train_y,
	epochs = 10,
	batch_size=500,
	validation_data = list(test_x, test_y),
	verbose = 2)

setwd("/users/jelle/documents/github/LoreSeekerAI/models")

model %>% save_model_tf("kerasdeepnn")
