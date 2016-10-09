rm(list = ls())

setwd("/home/fractaluser/Documents/Quantiphi-movie-prob")

library(data.table)
library(ggplot2)

mdata <- fread("movies.csv")

summary(mdata)

mdata[,`:=`(id = NULL, name = NULL, display_name = NULL, board_rating_reason = NULL)]
mdata <- data.frame(mdata)

for(i in names(mdata)) {
  if(is.character(mdata[[i]])) mdata[[i]] <- factor(mdata[[i]])
}

# sapply(mdata, function(x) length(unique(x)))

# boxplot(log(mdata$total) ~ mdata$movie_sequel , col = topo.colors(5))

# ggplot(data = mdata, aes(x = creative_type, y = log(total))) + geom_boxplot() +
#   theme(axis.text.x = element_text(angle = 90, hjust = 1))

# mdata$creative_type_multiple <- ifelse(mdata$creative_type == "Multiple Creative Types", 1, 0)
# mdata$creative_type_factual <- ifelse(mdata$creative_type == "Factual", 1, 0)
mdata$creative_type_fictionhero <- ifelse(mdata$creative_type %in% c("Kids Fiction", "Science Fiction", "Super Hero"), 1, 0)

# ggplot(data = mdata, aes(x = source, y = log(total))) + geom_boxplot() +
#   theme(axis.text.x = element_text(angle = 90, hjust = 1))
# 
# table(mdata$source)
# 
# ggplot(data = mdata, aes(x = production_method, y = log(total))) + geom_boxplot() +
#   theme(axis.text.x = element_text(angle = 90, hjust = 1))
# 
# table(mdata$production_method)

mdata$method_animeaction <- ifelse(mdata$production_method == "Animation/Live Action", 1, 0)
# mdata$method_MPM <- ifelse(mdata$production_method == "Multiple Production Methods", 1, 0)

# ggplot(data = mdata, aes(x = genre, y = log(total))) + geom_boxplot() +
#   theme(axis.text.x = element_text(angle = 90, hjust = 1))
# 
# table(mdata$genre)

# mdata$genre_lower <- ifelse(mdata$genre %in% c("Black Comedy", "Multiple Genres", "Documentary"), 1, 0)

# ggplot(data = mdata, aes(x = movie_board_rating_display_name, y = log(total))) + geom_boxplot() +
#   theme(axis.text.x = element_text(angle = 90, hjust = 1))
# 
# table(mdata$movie_board_rating_display_name)

# mdata$boardrating_poor <- ifelse(mdata$movie_board_rating_display_name %in% c("Not Rated", "NC-17"), 1, 0)

# ggplot(data = mdata, aes(x = movie_release_pattern_display_name, y = log(total))) + geom_boxplot() +
#   theme(axis.text.x = element_text(angle = 90, hjust = 1))
# 
# table(mdata$movie_release_pattern_display_name)

mdata$releasepattern_wide <- ifelse(mdata$movie_release_pattern_display_name %in% c("Expands Wide", "Wide"), 1, 0)
# mdata$releasepattern_oscar <- ifelse(mdata$movie_release_pattern_display_name == "Oscar Qualifying Run", 1, 0)

mdata$language <- NULL

library(caret)

set.seed(10)

inTrain <- createDataPartition(y = mdata$total, times = 1, p = 0.75, list = FALSE)

training <- mdata[inTrain,]
testing <- mdata[-inTrain,]

###########################################################################

set.seed(11)

lmfit1 <- lm(total ~., data = training[,-10])

RMSE(predict(lmfit1, testing), testing$total)

library(rpart)

treefit1 <- rpart(total ~., data = training[,-10]) 

RMSE(predict(treefit1, testing), testing$total)

varImp(treefit1)

pred1 <- predict(lmfit1, testing)
pred2 <- predict(treefit1, testing)


##########################################################################

# control <- trainControl(method="repeatedcv", number=10, repeats=3, search="grid", allowParallel = TRUE)
# tunegrid <- expand.grid(.mtry=c(1:15))
# 
# fit3 <- train(total ~., data = training, method = "rf", tuneGrid=tunegrid, trControl=control)
# 
# RMSE(predict(fit3, testing), testing$total)
# 
# print(fit3)

##########################################################################

set.seed(12)

tunegrid <- expand.grid(.mtry=6)

fit1 <- train(total ~., data = training[,-10], method = "rf", tuneGrid = tunegrid)

RMSE(predict(fit1, testing), testing$total)

pred3 <- predict(fit1, testing)

pred.avg <- (pred1+pred2+pred3)/3

RMSE(pred.avg, testing$total)

###########################################################################

mdata$total <- NULL
mdata$total1 <- predict(fit1, mdata)
mdata$total2 <- predict(treefit1, mdata)
mdata$total3 <- predict(lmfit1, mdata)
# mdata$total <- (mdata$total1 + mdata$total2 + mdata$total3)/3
# mdata$total1 <- NULL
# mdata$total2 <- NULL
# mdata$total3 <- NULL

mdata$Category <- factor(mdata$Category, levels = c("1", "2", "3", "4", "5", "6", "7","8","9"))

set.seed(15)

inTrain <- createDataPartition(y = mdata$Category, times = 1, p = 0.75, list = FALSE)

training <- mdata[inTrain, ]
testing <- mdata[-inTrain, ]

control <- trainControl(method="repeatedcv", number=10, repeats=3, search="grid", allowParallel = TRUE)
tunegrid <- expand.grid(.mtry=c(1:15))

fit2 <- train(Category ~., data = mdata, method = "rf", tuneGrid=tunegrid, trControl=control)

confusionMatrix(predict(fit2, mdata), mdata$Category)

##Best mtry is found to be 6
## Checking with different no. of trees to further improve the accuracy

tunegrid <- expand.grid(.mtry=6)
modellist <- list()
for(ntree in c(250, 500, 750, 1000)){
  set.seed(20)
  fit3 <-  train(Category ~., data = mdata, method = "rf", tuneGrid=tunegrid, ntree = ntree)
  key <- toString(ntree)
  modellist[[key]] <- fit3
}

results <- resamples(modellist)
summary(results)

confusionMatrix(predict(modellist[["1000"]], mdata), mdata$Category)

#Increasing no. of trees did not result in any major change in accuracy

