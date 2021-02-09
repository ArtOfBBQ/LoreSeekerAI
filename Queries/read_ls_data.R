read_loreseeker_data <- function(filename) {
    dat <- read.csv(paste0("/users/jelle/documents/github/helloworldcpp/data/", filename))
    dat <- dat[complete.cases(dat),]
    dat$winner_i <- NULL

    game_ids <- unique(dat$game_id)
    test_game_ids <- sample(game_ids, length(game_ids)/8)

    train <- dat[!(dat$game_id %in% test_game_ids),]
    test <- dat[dat$game_id %in% test_game_ids,]

    train$game_id <- NULL
    test$game_id <- NULL

    train <- as.matrix(train)
    test <- as.matrix(test)

    train_x <- train[, -929]
    train_y <- train[, 929]
    test_x <- test[, -929]
    test_y <- test[, 929]

    return(list(
        "train_x" = train_x,
        "train_y" = train_y,
        "test_x" = test_x,
        "test_y" = test_y))
}

read_loreseeker_data_old <- function(filename) {
    dat <- read.csv(paste0("/users/jelle/documents/github/helloworldcpp/data/", filename))
    
    ## equalize player 0 and player 1 wins
    wintable <- table(dat$winner_i)
    least_wins <- min(wintable)
    winner_i_to_sample_down <- as.numeric(names(wintable[wintable > least_wins]))
    dat$cumsum <- 0
    dat[dat$winner_i == winner_i_to_sample_down,]$cumsum <- cumsum(rep(1, nrow(dat[dat$winner_i == winner_i_to_sample_down,])))
    dat <- dat[dat$cumsum <= least_wins,]
    dat$cumsum <- NULL
    table(dat$winner_i)
    dat$winner_i <- NULL

    ## equalize win and loss observations
    wintable <- table(dat$won_game)
    least_wins <- min(wintable)
    type_to_sample_down <- as.numeric(names(wintable[wintable > least_wins]))
    dat$cumsum <- 0
    dat[dat$won_game == type_to_sample_down,]$cumsum <-
            cumsum(rep(1, nrow(dat[dat$won_game == 	type_to_sample_down,])))
    dat <- dat[dat$cumsum <= least_wins,]
    dat$cumsum <- NULL
    table(dat$won_game)
    
    game_ids <- unique(dat$game_id)
    test_game_ids <- sample(game_ids, length(game_ids)/8)
    
    train <- dat[!(dat$game_id %in% test_game_ids),]
    test <- dat[dat$game_id %in% test_game_ids,]
    
    train$game_id <- NULL
    test$game_id <- NULL
    
    train <- as.matrix(train)
    test <- as.matrix(test)
    
    train_x <- train[, -929]
    train_y <- train[, 929]
    test_x <- test[, -929]
    test_y <- test[, 929]
    
    return(list(
        "train_x" = train_x,
        "train_y" = train_y,
        "test_x" = test_x,
        "test_y" = test_y))
}

