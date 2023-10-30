# STEP 1. Install and Load the Required Packages ----
## stats ----
if (require("stats")) {
  require("stats")
} else {
  install.packages("stats", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## mlbench ----
if (require("mlbench")) {
  require("mlbench")
} else {
  install.packages("mlbench", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## MASS ----
if (require("MASS")) {
  require("MASS")
} else {
  install.packages("MASS", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## glmnet ----
if (require("glmnet")) {
  require("glmnet")
} else {
  install.packages("glmnet", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## e1071 ----
if (require("e1071")) {
  require("e1071")
} else {
  install.packages("e1071", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## kernlab ----
if (require("kernlab")) {
  require("kernlab")
} else {
  install.packages("kernlab", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## rpart ----
if (require("rpart")) {
  require("rpart")
} else {
  install.packages("rpart", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# A. Linear Algorithms ----
## 1. Linear Regression ----
### 1.a. Linear Regression using Ordinary Least Squares without caret ----
# The lm() function is in the stats package and creates a linear regression
# model using ordinary least squares (OLS).

### Load and split the dataset ----
library(readr)
insurance <- read_csv("data/insurance.csv")
View(insurance)



# Define an 80:20 train:test data split of the dataset.
train_index <- createDataPartition(insurance$charges,
                                   p = 0.8,
                                   list = FALSE)
insurance_train <- insurance[train_index, ]
insurance_test <- insurance[-train_index, ]

#### Train the model ----
insurance_model_lm <- lm(charges ~ ., insurance_train)

#### Display the model's details ----
print(insurance_model_lm)

#### Make predictions ----
predictions <- predict(insurance_model_lm, insurance_test[, 1:7])

#### Display the model's evaluation metrics ----
##### RMSE ----
rmse <- sqrt(mean((insurance_test$charges - predictions)^2))
print(paste("RMSE =", sprintf(rmse, fmt = "%#.4f")))

##### SSR ----
# SSR is the sum of squared residuals (the sum of squared differences
# between observed and predicted values)
ssr <- sum((insurance_test$charges - predictions)^2)
print(paste("SSR =", sprintf(ssr, fmt = "%#.4f")))

##### SST ----
# SST is the total sum of squares (the sum of squared differences
# between observed values and their mean)
sst <- sum((insurance_test$charges - mean(insurance_test$charges))^2)
print(paste("SST =", sprintf(sst, fmt = "%#.4f")))

##### R Squared ----
# We then use SSR and SST to compute the value of R squared.
# The closer the R squared value is to 1, the better the model.
r_squared <- 1 - (ssr / sst)
print(paste("R Squared =", sprintf(r_squared, fmt = "%#.4f")))

##### MAE ----
# MAE is expressed in the same units as the target variable, making it easy to
# interpret. For example, if you are predicting the amount paid in rent,
# and the MAE is KES. 10,000, it means, on average, your model's predictions
# are off by about KES. 10,000.
absolute_errors <- abs(predictions - insurance_test$charges)
mae <- mean(absolute_errors)
print(paste("MAE =", sprintf(mae, fmt = "%#.4f")))



### 1.b. Linear Regression using Ordinary Least Squares with caret ----
#### Load and split the dataset ----
View(insurance)

# Define an 80:20 train:test data split of the dataset.
train_index <- createDataPartition(insurance$charges,
                                   p = 0.8,
                                   list = FALSE)
insurance_train <- insurance[train_index, ]
insurance_test <- insurance[-train_index, ]

#### Train the model ----
set.seed(7)
train_control <- trainControl(method = "cv", number = 5)
insurance_caret_model_lm <- train(charges ~ ., data = insurance_train,
                                       method = "lm", metric = "RMSE",
                                       preProcess = c("center", "scale"),
                                       trControl = train_control)

#### Display the model's details ----
print(insurance_caret_model_lm)

#### Make predictions ----
predictions <- predict(insurance_caret_model_lm,
                       insurance_test[, 1:7])

#### Display the model's evaluation metrics ----
##### RMSE ----
rmse <- sqrt(mean((insurance_test$charges - predictions)^2))
print(paste("RMSE =", sprintf(rmse, fmt = "%#.4f")))

##### SSR ----
# SSR is the sum of squared residuals (the sum of squared differences
# between observed and predicted values)
ssr <- sum((insurance_test$charges - predictions)^2)
print(paste("SSR =", sprintf(ssr, fmt = "%#.4f")))

##### SST ----
# SST is the total sum of squares (the sum of squared differences
# between observed values and their mean)
sst <- sum((insurance_test$charges - mean(insurance_test$charges))^2)
print(paste("SST =", sprintf(sst, fmt = "%#.4f")))

##### R Squared ----
# We then use SSR and SST to compute the value of R squared.
# The closer the R squared value is to 1, the better the model.
r_squared <- 1 - (ssr / sst)
print(paste("R Squared =", sprintf(r_squared, fmt = "%#.4f")))

##### MAE ----
# MAE is expressed in the same units as the target variable, making it easy to
# interpret. For example, if you are predicting the amount paid in rent,
# and the MAE is KES. 10,000, it means, on average, your model's predictions
# are off by about KES. 10,000.
absolute_errors <- abs(predictions - insurance_test$charges)
mae <- mean(absolute_errors)
print(paste("MAE =", sprintf(mae, fmt = "%#.4f")))


####
### 2.b. Logistic Regression with caret ----
View(insurance)

# Define a 70:30 train:test data split of the dataset.
train_index <- createDataPartition(insurance$charges,
                                   p = 0.7,
                                   list = FALSE)
insurance_charges_train <- insurance[train_index, ]
insurance_charges_test <- insurance[-train_index, ]

set.seed(123)  # Set a seed for reproducibility
trainIndex <- createDataPartition(y = insurance$charges, p = 0.7, 
                                  list = FALSE)
data_train <- insurance[trainIndex, ]
data_test <- insurance[-trainIndex, ]

ctrl <- trainControl(method = "cv", number = 5)  # Example: 5-fold cross-validation

model <- train(charges ~ ., data = data_train, method = "glm", trControl = ctrl)

predictions <- predict(model, newdata = data_test)

levels(predictions)
levels(data_test$charges)

predictions <- factor(predictions, levels = levels(data_test$charges))

#### Display the model's details ----
print(model)

#### Make predictions ----
probabilities <- predict(model, data_test[, 1:7],
                         type = "raw")
print(probabilities)
predictions <- ifelse(probabilities > 0.5, "pos", "neg")
print(predictions)

#### Display the model's evaluation metrics ----
table(predictions, data_test$charges)



