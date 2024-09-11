library(titanic)
head(titanic_train)

## Drop NA (missing value)
titanic_train <- na.omit(titanic_train)
nrow(titanic_train)

## Split data
set.seed(42)
n <- nrow(titanic_train)
id <- sample(1:n, size = n * 0.7) ## 70% train 30% test
train_data <- titanic_train[id, ]
test_data <- titanic_train[-id, ]

## train model
train_model <- glm(Survived ~ Pclass + factor(Sex) + Age,
                   data = train_data, 
                   family = "binomial")
summary(train_model)
train_data$prob_survive <- predict(train_model, type = "response")
train_data$pred_survive <- ifelse(train_data$prob_survive >= 0.5, 1, 0)
conM_train <- table(train_data$Survived, train_data$pred_survive, 
                    dnn = c("Actual", "Predicted"))
conM_train

## test model
test_data$prob_survive <- predict(train_model, newdata = test_data, type = "response")
test_data$pred_survive <- ifelse(test_data$prob_survive >= 0.5, 1, 0)
conM_test <- table(test_data$Survived, test_data$pred_survive,
                   dnn = c("Actual", "Predicted"))
conM_test

## accuracy
acc_train <- (conM_train[1,1] + conM_train[2,2])/sum(conM_train)
cat("Train accuracy:", acc_train)

acc_test <- (conM_test[1,1] + conM_test[2,2])/ sum(conM_test)
cat("Test accuracy:", acc_test)
