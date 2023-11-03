
if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# Introduction ----
# There are hundreds of algorithms to choose from.
# A list of the Typeification and regression algorithms offered by
# the caret package can be found here:
# http://topepo.github.io/caret/available-models.html

# The goal of predictive modelling is to use the most appropriate algorithm to
# design an accurate model that represents the dataset. Selecting the most
# appropriate algorithm is a process that involves trial-and-error.

# If the most appropriate algorithm was known beforehand, then it would not be
# necessary to use Machine Learning. The trial-and-error approach to selecting
# the most appropriate algorithm involves evaluating a diverse set of
# algorithms on the dataset, and identifying the algorithms that create
# accurate models and the ones that do not.

# Once you have a shortlist of the top algorithms, you can then improve their
# results further by either tuning the algorithm parameters or by combining the
# predictions of multiple models using ensemble methods.

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

### 1.a. Decision tree for a classification problem without caret ----
#### Load and split the dataset ----
data(Glass)

# Define a 80:20 train:test data split of the dataset.
train_index <- createDataPartition(Glass$Type,
                                   p = 0.8,
                                   list = FALSE)
Glass_train <- Glass[train_index, ]
Glass_test <- Glass[-train_index, ]

#### Train the model ----
Type_model_rpart <- rpart(Type ~ ., data = Glass_train)

#### Display the model's details ----
print(Type_model_rpart)

#### Make predictions ----
predictions <- predict(Type_model_rpart,
                       Glass_test[, 1:9],
                       type = "class")

#### Display the model's evaluation metrics ----
table(predictions,Glass_test$Type)

confusion_matrix <-
  caret::confusionMatrix(predictions,
                        Glass_test[, 1:10]$Type)
print(confusion_matrix)



### 1.b. Decision tree for a classification problem with caret ----
#### Load and split the dataset ----
data(Glass)

# Define a 70:30 train:test data split of the dataset.
train_index <- createDataPartition(Glass$Type,
                                   p = 0.7,
                                   list = FALSE)
Glass_train <- Glass[train_index, ]
Glass_test <- Glass[-train_index, ]

#### Train the model ----
set.seed(121)
# We apply the 10-fold cross validation resampling method
train_control <- trainControl(method = "cv", number = 10)
Glass_caret_model_rpart <- train(Type ~ ., data = Glass,
                                 method = "rpart", metric = "Accuracy",
                                 trControl = train_control)

#### Display the model's details ----
print(Glass_caret_model_rpart)

#### Make predictions ----
predictions <- predict(Glass_caret_model_rpart, 
                       Glass_test[, 1:9],
                       type = "raw") 

#### Display the model's evaluation metrics ----
table(predictions, Glass_test$Type)

confusion_matrix <-
  caret::confusionMatrix(predictions,
                         Glass_test[, 1:10]$Type)
print(confusion_matrix)

### 2.a. Naïve Bayes Classifier for a Classification Problem without CARET ----
# We use the naiveBayes function inside the e1071 package
#### Load and split the dataset ----
data(Glass)

# Define a 70:30 train:test data split of the dataset.
train_index <- createDataPartition(Glass$Type,
                                   p = 0.8,
                                   list = FALSE)
Glass_train <- Glass[train_index, ]
Glass_test <- Glass[-train_index, ]

#### Train the model ----
Glass_model_nb <- naiveBayes(Type ~ .,
                                data = Glass_train)

#### Display the model's details ----
print(Glass_model_nb)

#### Make predictions ----
predictions <- predict(Glass_model_nb,
                       Glass_test[, -10])

#### Display the model's evaluation metrics ----
confusion_matrix <-
  caret::confusionMatrix(predictions,
                         Glass_test[, 1:10]$Type)
print(confusion_matrix)



### 2.b. Naïve Bayes Classifier for a Classification Problem with CARET ----
#### Load and split the dataset ----
data(Glass)

# Define a 70:30 train:test data split of the dataset.
train_index <- createDataPartition(Glass$Type,
                                   p = 0.7,
                                   list = FALSE)
Glass_train <- Glass[train_index, ]
Glass_test <- Glass[-train_index, ]

#### Train the model ----
# We apply the 5-fold cross validation resampling method
set.seed(7)
train_control <- trainControl(method = "cv", number = 10)
preProcessObj <- preProcess(Glass_train, method = "medianImpute")
Glass_train_imputed <- predict(preProcessObj, Glass_train)
Glass_caret_model_nb <- train(Type ~ .,
                                 data = Glass_train_imputed,
                                 method = "nb", metric = "Accuracy",
                                 trControl = train_control)

#### Display the model's details ----
print(Glass_caret_model_nb)

#### Make predictions ----
predictions <- predict(Glass_caret_model_nb,
                       Glass_train_imputed[, 1:9])

#### Display the model's evaluation metrics ----
confusion_matrix <-
  caret::confusionMatrix(predictions,
                         Glass_train_imputed[, 1:10]$Type)
print(confusion_matrix)

### 3.a. kNN for a classification problem without CARET's train function ----
#### Load and split the dataset ----
data(Glass)

# Define a 70:30 train:test data split of the dataset.
train_index <- createDataPartition(Glass$Type,
                                   p = 0.8,
                                   list = FALSE)
Glass_train <- Glass[train_index, ]
Glass_test <- Glass[-train_index, ]

#### Train the model ----
Glass_model_knn <- knn3(Type ~ ., data = Glass_train, k=2)

#### Display the model's details ----
print(Glass_model_knn)

#### Make predictions ----
predictions <- predict(Glass_model_knn,
                       Glass_test[, 1:9],
                       type = "class")

#### Display the model's evaluation metrics ----
table(predictions, Glass_test$Type)

# Or alternatively:
confusion_matrix <-
  caret::confusionMatrix(predictions,
                         Glass_test$Type)
print(confusion_matrix)


### 3.c. kNN for a classification problem with CARET's train function ----
#### Load and split the dataset ----
data(Glass)

# Define a 70:30 train:test data split of the dataset.
train_index <- createDataPartition(Glass$Type,
                                   p = 0.7,
                                   list = FALSE)
Glass_train <- Glass[train_index, ]
Glass_test <- Glass[-train_index, ]

#### Train the model ----

set.seed(121)
train_control <- trainControl(method = "cv", number = 10)
Glass_caret_model_knn <- train(Type ~ ., data = Glass,
                                  method = "knn", metric = "Accuracy",
                                  preProcess = c("center", "scale"),
                                  trControl = train_control)

#### Display the model's details ----
print(Glass_caret_model_knn)

#### Make predictions ----
predictions <- predict(Glass_caret_model_knn,
                       Glass_test[, 1:9])

#### Display the model's evaluation metrics ----
confusion_matrix <-
  caret::confusionMatrix(predictions,
                         Glass_test[, 1:10]$Type)
print(confusion_matrix)

## 4.a. SVM Classifier for a classification problem with CARET ----
  
  #### Load and split the dataset ----
data(Glass)

# Define a 70:30 train:test data split of the dataset.
train_index <- createDataPartition(Glass$Type,
                                   p = 0.7,
                                   list = FALSE)
Glass_train <- Glass[train_index, ]
Glass_test <- Glass[-train_index, ]

#### Train the model ----
set.seed(121)
train_control <- trainControl(method = "cv", number = 11)
Glass_caret_model_svm_radial <- # nolint: object_length_linter.
  train(Type ~ ., data = Glass_train, method = "svmRadial",
        metric = "Accuracy", trControl = train_control)

#### Display the model's details ----
print(Glass_caret_model_svm_radial)

#### Make predictions ----
predictions <- predict(Glass_caret_model_svm_radial,
                       Glass_test[, 1:9])

#### Display the model's evaluation metrics ----
table(predictions, Glass_test$Type)
confusion_matrix <-
  caret::confusionMatrix(predictions,
                         Glass_test[, 1:10]$Type)
print(confusion_matrix)

### 4.b. SVM Classifier for a classification problem without CARET ----
#### Load and split the dataset ----
data(Glass)

# Define a 70:30 train:test data split of the dataset.
train_index <- createDataPartition(Glass$Type,
                                   p = 0.7,
                                   list = FALSE)
Glass_train <- Glass[train_index, ]
Glass_test <- Glass[-train_index, ]

#### Train the model ----
Glass_model_svm <- ksvm(Type ~ ., data = Glass_train,
                           kernel = "rbfdot")

#### Display the model's details ----
print(Glass_model_svm)

#### Make predictions ----
predictions <- predict(Glass_model_svm, Glass_test[, 1:9],
                       type = "response")

#### Display the model's evaluation metrics ----
table(predictions, Glass_test$Type)

confusion_matrix <-
  caret::confusionMatrix(predictions,
                         Glass_test[, 1:10]$Type)
print(confusion_matrix)


############################
#Regression algorithms
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

##############
#LAB 7c
#ASSOCIATION RULE MINING USING APRIORI
# Install and Load the Required Packages ----

##languageserver
if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## arules ----
if (require("arules")) {
  require("arules")
} else {
  install.packages("arules", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## arulesViz ----
if (require("arulesViz")) {
  require("arulesViz")
} else {
  install.packages("arulesViz", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## tidyverse ----
if (require("tidyverse")) {
  require("tidyverse")
} else {
  install.packages("tidyverse", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## readxl ----
if (require("readxl")) {
  require("readxl")
} else {
  install.packages("readxl", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## knitr ----
if (require("knitr")) {
  require("knitr")
} else {
  install.packages("knitr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## ggplot2 ----
if (require("ggplot2")) {
  require("ggplot2")
} else {
  install.packages("ggplot2", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## lubridate ----
if (require("lubridate")) {
  require("lubridate")
} else {
  install.packages("lubridate", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## plyr ----
if (require("plyr")) {
  require("plyr")
} else {
  install.packages("plyr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## dplyr ----
if (require("dplyr")) {
  require("dplyr")
} else {
  install.packages("dplyr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## naniar ----
if (require("naniar")) {
  require("naniar")
} else {
  install.packages("naniar", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## RColorBrewer ----
if (require("RColorBrewer")) {
  require("RColorBrewer")
} else {
  install.packages("RColorBrewer", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## The dataset ----
# We used the Groceries dataset for Market Basket Analysis available on Kaggle
# here: https://www.kaggle.com/datasets/heeraldedhia/groceries-dataset/data

# Abstract:
# The dataset has 38765 rows of the purchase orders of people from the grocery stores. These orders can be analysed and association rules can be generated using Market Basket Analysis by algorithms like Apriori Algorithm.

# Step One: Loading the Dataset

# We can read data from the csv file as follows:
mba2 <- read.csv(file = "data/mba2.csv")
dim(mba2)

# We have 38,765 observations and 3 variables

# Step Two: Handling missing values and Data Transformation
# There are no missing values in the dataset
any_na(mba2)

## Creating a transaction data frame
transactions <- as(split(data$ItemName, data$MemberNo), "transactions")
View (transactions)

write.csv(transaction_data,
          "data/transactions_mba2.csv",
          quote = FALSE, row.names = FALSE)

# This shows there are 3,898 transactions that have been identified
# and 167 items
print(transactions)
summary(transactions)

# Step Three: Basic EDA ----
## Create an item frequency plot  for the top 10 items
itemFrequencyPlot(transactions, topN = 10, type = "absolute",
                  col = brewer.pal(8, "Pastel2"),
                  main = "Absolute Item Frequency Plot",
                  horiz = TRUE,
                  mai = c(2, 2, 2, 2))

association_rules <- apriori(transactions, 
                             parameter = list(supp = 0.005, conf = 0.8, maxlen = 10))


# Step Four: Print the association rules ----
# Threshold values of support = 0.01, confidence = 0.9, and
# maxlen = 10 results in a total of 14 rules when using the
# product name to identify the products.
summary(association_rules)
inspect(association_rules)

# To view the top 10 rules
inspect(association_rules[1:10])
plot(association_rules)

### Remove redundant rules ----
# We can remove the redundant rules as follows:
# Find the subset rules
subset_rules <- is.subset(association_rules, association_rules)

# Get the indices of the subset rules
subset_rule_indices <- which(subset_rules)

# Remove the subset rules from the association_rules
association_rules_no_reps <- association_rules[-subset_rule_indices]

# Check the number of remaining rules
length(association_rules_no_reps)

# This results in 34 non-redundant rules (instead of the initial 35 rules)
summary(association_rules_no_reps)
inspect(association_rules_no_reps)

write(association_rules_no_reps,
      file = "rules/association_rules.csv")

# Visualize the rules ----
# Filter rules with confidence greater than 0.85 or 85%
rules_to_plot <-
  association_rules_no_reps[quality(association_rules_no_reps)$confidence > 0.85] # nolint

#Plot SubRules
plot(rules_to_plot)
plot(rules_to_plot, method = "two-key plot")

top_10_rules_to_plot <- head(rules_to_plot, n = 10, by = "confidence")
plot(top_10_rules_to_plot, method = "graph",  engine = "htmlwidget")

saveAsGraph(head(rules_to_plot, n = 1000, by = "lift"),
            file = "graph/association_rules_no_reps.graphml")

# Filter top 20 rules with highest lift
rules_to_plot_by_lift <- head(rules_to_plot, n = 20, by = "lift")
plot(rules_to_plot_by_lift, method = "paracoord")

plot(top_10_rules_to_plot, method = "grouped")




