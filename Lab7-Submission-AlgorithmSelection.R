
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


