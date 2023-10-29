Business Intelligence Project
================
korn
23/10/23

- [Student Details](#student-details)
- [Setup Chunk](#setup-chunk)
- [LAB 7](#lab-7)
  - [CLASSIFICATION](#classification)
    - [Load required Packages](#load-required-packages)
  - [Dataset Description](#dataset-description)
  - [1.a.Decision tree for a classification problem without
    caret](#1adecision-tree-for-a-classification-problem-without-caret)
  - [1.b. Decision tree for a classification problem with
    caret](#1b-decision-tree-for-a-classification-problem-with-caret)
  - [2.a. Naïve Bayes Classifier for a Classification Problem without
    CARET](#2a-naïve-bayes-classifier-for-a-classification-problem-without-caret)
  - [2.b. Naïve Bayes Classifier for a Classification Problem with
    CARET](#2b-naïve-bayes-classifier-for-a-classification-problem-with-caret)
  - [3.a. kNN for a classification problem without CARET’s train
    function](#3a-knn-for-a-classification-problem-without-carets-train-function)
  - [3.b. kNN for a classification problem with CARET’s train
    function](#3b-knn-for-a-classification-problem-with-carets-train-function)
  - [4.a. SVM Classifier for a classification problem with
    CARET](#4a-svm-classifier-for-a-classification-problem-with-caret)
  - [4.b. SVM Classifier for a classification problem without
    CARET](#4b-svm-classifier-for-a-classification-problem-without-caret)

# Student Details

<table style="width:99%;">
<colgroup>
<col style="width: 52%" />
<col style="width: 45%" />
</colgroup>
<tbody>
<tr class="odd">
<td><strong>Student ID Numbers and Names of Group Members</strong></td>
<td><ol type="1">
<li><p>134644 - C - Sebastian Muramara</p></li>
<li><p>136675 - C - Bernard Otieno</p></li>
<li><p>131589 - C - Agnes Anyango</p></li>
<li><p>131582 - C - Njeri Njuguna</p></li>
<li><p>136009 - C- Sera Ndabari</p></li>
</ol></td>
</tr>
<tr class="even">
<td><strong>GitHub Classroom Group Name</strong></td>
<td>Korn</td>
</tr>
<tr class="odd">
<td><strong>Course Code</strong></td>
<td>BBT4206</td>
</tr>
<tr class="even">
<td><strong>Course Name</strong></td>
<td>Business Intelligence II</td>
</tr>
<tr class="odd">
<td><strong>Program</strong></td>
<td>Bachelor of Business Information Technology</td>
</tr>
<tr class="even">
<td><strong>Semester Duration</strong></td>
<td>21<sup>st</sup> August 2023 to 28<sup>th</sup> November 2023</td>
</tr>
</tbody>
</table>

# Setup Chunk

**Note:** the following KnitR options have been set as the global
defaults: <BR>
`knitr::opts_chunk$set(echo = TRUE, warning = FALSE, eval = TRUE, collapse = FALSE, tidy = TRUE)`.

More KnitR options are documented here
<https://bookdown.org/yihui/rmarkdown-cookbook/chunk-options.html> and
here <https://yihui.org/knitr/options/>.

# LAB 7

## CLASSIFICATION

### Load required Packages

``` r
if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: languageserver

``` r
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
```

    ## Loading required package: mlbench

``` r
## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: caret

    ## Loading required package: ggplot2

    ## Loading required package: lattice

``` r
## MASS ----
if (require("MASS")) {
  require("MASS")
} else {
  install.packages("MASS", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: MASS

``` r
## glmnet ----
if (require("glmnet")) {
  require("glmnet")
} else {
  install.packages("glmnet", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: glmnet

    ## Loading required package: Matrix

    ## Loaded glmnet 4.1-8

``` r
## e1071 ----
if (require("e1071")) {
  require("e1071")
} else {
  install.packages("e1071", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: e1071

``` r
## kernlab ----
if (require("kernlab")) {
  require("kernlab")
} else {
  install.packages("kernlab", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: kernlab

    ## 
    ## Attaching package: 'kernlab'

    ## The following object is masked from 'package:ggplot2':
    ## 
    ##     alpha

``` r
## rpart ----
if (require("rpart")) {
  require("rpart")
} else {
  install.packages("rpart", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
```

    ## Loading required package: rpart

\#Dataset used for classification

## Dataset Description

A data frame with 214 observation containing examples of the chemical
analysis of 7 different types of glass. The problem is to forecast the
type of class on basis of the chemical analysis. The study of
classification of types of glass was motivated by criminological
investigation. At the scene of the crime, the glass left can be used as
evidence (if it is correctlyidentified!).

\#Usage

data(Glass)

\#Format

A data frame with 214 observations on 10 variables:

\[,1\] RI refractive index

\[,2\] Na Sodium

\[,3\] Mg Magnesium

\[,4\] Al Aluminum

\[,5\] Si Silicon

\[,6\] K Potassium

\[,7\] Ca Calcium

\[,8\] Ba Barium

\[,9\] Fe Iron

\[,10\] Type Type of glass (class attribute)

\#Source

• Creator: B. German, Central Research Establishment, Home Office
Forensic Science Service, Aldermaston, Reading, Berkshire RG7 4PN

• Donor: Vina Spiehler, Ph.D., DABFT, Diagnostic Products Corporation
These data have been taken from the UCI Repository Of Machine Learning
Databases at 10 HouseVotes84

• <ftp://ftp.ics.uci.edu/pub/machine-learning-databases>

• <http://www.ics.uci.edu/~mlearn/MLRepository.html> and were converted
to R format by Friedrich Leisch.

\#References

Newman, D.J. & Hettich, S. & Blake, C.L. & Merz, C.J. (1998). UCI
Repository of machine learning databases
\[<http://www.ics.uci.edu/~mlearn/MLRepository.html>\]. Irvine, CA:
University of California, Department of Information and Computer
Science.

\#Examples

data(Glass) summary(Glass)

## 1.a.Decision tree for a classification problem without caret

``` r
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
```

    ## n= 174 
    ## 
    ## node), split, n, loss, yval, (yprob)
    ##       * denotes terminal node
    ## 
    ##  1) root 174 113 2 (0.32 0.35 0.08 0.063 0.046 0.14)  
    ##    2) Ba< 0.335 149  89 2 (0.37 0.4 0.094 0.067 0.054 0.013)  
    ##      4) Al< 1.42 95  43 1 (0.55 0.28 0.12 0.011 0.032 0.011)  
    ##        8) Ca< 10.48 84  32 1 (0.62 0.21 0.13 0 0.024 0.012)  
    ##         16) Mg< 3.865 76  25 1 (0.67 0.16 0.13 0 0.026 0.013)  
    ##           32) RI>=1.51707 61  13 1 (0.79 0.13 0.066 0 0.016 0) *
    ##           33) RI< 1.51707 15   9 3 (0.2 0.27 0.4 0 0.067 0.067) *
    ##         17) Mg>=3.865 8   2 2 (0.12 0.75 0.12 0 0 0) *
    ##        9) Ca>=10.48 11   2 2 (0 0.82 0 0.091 0.091 0) *
    ##      5) Al>=1.42 54  21 2 (0.056 0.61 0.056 0.17 0.093 0.019)  
    ##       10) Mg>=2.26 37   7 2 (0.081 0.81 0.081 0 0.027 0) *
    ##       11) Mg< 2.26 17   8 5 (0 0.18 0 0.53 0.24 0.059) *
    ##    3) Ba>=0.335 25   3 7 (0.04 0.04 0 0.04 0 0.88) *

``` r
#### Make predictions ----
predictions <- predict(Type_model_rpart,
                       Glass_test[, 1:9],
                       type = "class")

#### Display the model's evaluation metrics ----
table(predictions,Glass_test$Type)
```

    ##            
    ## predictions  1  2  3  5  6  7
    ##           1 11  3  1  0  0  1
    ##           2  3 12  1  0  0  0
    ##           3  0  0  1  0  0  0
    ##           5  0  0  0  2  1  0
    ##           6  0  0  0  0  0  0
    ##           7  0  0  0  0  0  4

``` r
confusion_matrix <-
  caret::confusionMatrix(predictions,
                        Glass_test[, 1:10]$Type)
print(confusion_matrix)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction  1  2  3  5  6  7
    ##          1 11  3  1  0  0  1
    ##          2  3 12  1  0  0  0
    ##          3  0  0  1  0  0  0
    ##          5  0  0  0  2  1  0
    ##          6  0  0  0  0  0  0
    ##          7  0  0  0  0  0  4
    ## 
    ## Overall Statistics
    ##                                          
    ##                Accuracy : 0.75           
    ##                  95% CI : (0.588, 0.8731)
    ##     No Information Rate : 0.375          
    ##     P-Value [Acc > NIR] : 1.579e-06      
    ##                                          
    ##                   Kappa : 0.6387         
    ##                                          
    ##  Mcnemar's Test P-Value : NA             
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: 1 Class: 2 Class: 3 Class: 5 Class: 6 Class: 7
    ## Sensitivity            0.7857    0.800   0.3333   1.0000    0.000   0.8000
    ## Specificity            0.8077    0.840   1.0000   0.9737    1.000   1.0000
    ## Pos Pred Value         0.6875    0.750   1.0000   0.6667      NaN   1.0000
    ## Neg Pred Value         0.8750    0.875   0.9487   1.0000    0.975   0.9722
    ## Prevalence             0.3500    0.375   0.0750   0.0500    0.025   0.1250
    ## Detection Rate         0.2750    0.300   0.0250   0.0500    0.000   0.1000
    ## Detection Prevalence   0.4000    0.400   0.0250   0.0750    0.000   0.1000
    ## Balanced Accuracy      0.7967    0.820   0.6667   0.9868    0.500   0.9000

## 1.b. Decision tree for a classification problem with caret

``` r
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
```

    ## CART 
    ## 
    ## 214 samples
    ##   9 predictor
    ##   6 classes: '1', '2', '3', '5', '6', '7' 
    ## 
    ## No pre-processing
    ## Resampling: Cross-Validated (10 fold) 
    ## Summary of sample sizes: 192, 191, 192, 193, 194, 192, ... 
    ## Resampling results across tuning parameters:
    ## 
    ##   cp          Accuracy   Kappa    
    ##   0.05797101  0.6687888  0.5261082
    ##   0.07246377  0.6354338  0.4745725
    ##   0.20652174  0.4372116  0.1517986
    ## 
    ## Accuracy was used to select the optimal model using the largest value.
    ## The final value used for the model was cp = 0.05797101.

``` r
#### Make predictions ----
predictions <- predict(Glass_caret_model_rpart, 
                       Glass_test[, 1:9],
                       type = "raw") 

#### Display the model's evaluation metrics ----
table(predictions, Glass_test$Type)
```

    ##            
    ## predictions  1  2  3  5  6  7
    ##           1 19  3  5  0  1  0
    ##           2  2 18  0  3  1  1
    ##           3  0  0  0  0  0  0
    ##           5  0  0  0  0  0  0
    ##           6  0  0  0  0  0  0
    ##           7  0  1  0  0  0  7

``` r
confusion_matrix <-
  caret::confusionMatrix(predictions,
                         Glass_test[, 1:10]$Type)
print(confusion_matrix)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction  1  2  3  5  6  7
    ##          1 19  3  5  0  1  0
    ##          2  2 18  0  3  1  1
    ##          3  0  0  0  0  0  0
    ##          5  0  0  0  0  0  0
    ##          6  0  0  0  0  0  0
    ##          7  0  1  0  0  0  7
    ## 
    ## Overall Statistics
    ##                                           
    ##                Accuracy : 0.7213          
    ##                  95% CI : (0.5917, 0.8285)
    ##     No Information Rate : 0.3607          
    ##     P-Value [Acc > NIR] : 1.099e-08       
    ##                                           
    ##                   Kappa : 0.5883          
    ##                                           
    ##  Mcnemar's Test P-Value : NA              
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: 1 Class: 2 Class: 3 Class: 5 Class: 6 Class: 7
    ## Sensitivity            0.9048   0.8182  0.00000  0.00000  0.00000   0.8750
    ## Specificity            0.7750   0.8205  1.00000  1.00000  1.00000   0.9811
    ## Pos Pred Value         0.6786   0.7200      NaN      NaN      NaN   0.8750
    ## Neg Pred Value         0.9394   0.8889  0.91803  0.95082  0.96721   0.9811
    ## Prevalence             0.3443   0.3607  0.08197  0.04918  0.03279   0.1311
    ## Detection Rate         0.3115   0.2951  0.00000  0.00000  0.00000   0.1148
    ## Detection Prevalence   0.4590   0.4098  0.00000  0.00000  0.00000   0.1311
    ## Balanced Accuracy      0.8399   0.8193  0.50000  0.50000  0.50000   0.9281

## 2.a. Naïve Bayes Classifier for a Classification Problem without CARET

``` r
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
```

    ## 
    ## Naive Bayes Classifier for Discrete Predictors
    ## 
    ## Call:
    ## naiveBayes.default(x = X, y = Y, laplace = laplace)
    ## 
    ## A-priori probabilities:
    ## Y
    ##          1          2          3          5          6          7 
    ## 0.32183908 0.35057471 0.08045977 0.06321839 0.04597701 0.13793103 
    ## 
    ## Conditional probabilities:
    ##    RI
    ## Y       [,1]        [,2]
    ##   1 1.518700 0.002289339
    ##   2 1.518394 0.003708919
    ##   3 1.517776 0.001738814
    ##   5 1.518771 0.003629326
    ##   6 1.518014 0.002808939
    ##   7 1.517182 0.002753955
    ## 
    ##    Na
    ## Y       [,1]      [,2]
    ##   1 13.20411 0.4316344
    ##   2 13.15885 0.6369278
    ##   3 13.39786 0.5133327
    ##   5 12.78636 0.8313877
    ##   6 14.67750 1.1546397
    ##   7 14.37042 0.7243377
    ## 
    ##    Mg
    ## Y        [,1]      [,2]
    ##   1 3.5366071 0.2049326
    ##   2 3.1091803 1.1380119
    ##   3 3.5428571 0.1620745
    ##   5 0.7463636 1.0106560
    ##   6 1.2512500 1.1598822
    ##   7 0.5145833 1.0713217
    ## 
    ##    Al
    ## Y       [,1]      [,2]
    ##   1 1.187321 0.2284453
    ##   2 1.406393 0.3058705
    ##   3 1.159286 0.3291823
    ##   5 2.107273 0.7271188
    ##   6 1.345000 0.6073831
    ##   7 2.093333 0.4768344
    ## 
    ##    Si
    ## Y       [,1]      [,2]
    ##   1 72.63268 0.5403820
    ##   2 72.58393 0.7366190
    ##   3 72.50000 0.4675303
    ##   5 72.34727 1.4003506
    ##   6 73.03875 1.0206362
    ##   7 72.99625 0.9644273
    ## 
    ##    K
    ## Y        [,1]      [,2]
    ##   1 0.4583929 0.2080802
    ##   2 0.5372131 0.1952787
    ##   3 0.3928571 0.2392755
    ##   5 1.6527273 2.2905113
    ##   6 0.0000000 0.0000000
    ##   7 0.3300000 0.6862437
    ## 
    ##    Ca
    ## Y       [,1]      [,2]
    ##   1 8.796429 0.5832836
    ##   2 8.903443 1.7523478
    ##   3 8.785714 0.3943586
    ##   5 9.910909 2.2601171
    ##   6 9.577500 1.3787961
    ##   7 8.575417 0.9021616
    ## 
    ##    Ba
    ## Y         [,1]       [,2]
    ##   1 0.01428571 0.09310516
    ##   2 0.06032787 0.40408731
    ##   3 0.01071429 0.04008919
    ##   5 0.22181818 0.66002755
    ##   6 0.00000000 0.00000000
    ##   7 1.04666667 0.69691037
    ## 
    ##    Fe
    ## Y         [,1]       [,2]
    ##   1 0.05571429 0.08618916
    ##   2 0.07754098 0.10609203
    ##   3 0.03071429 0.06933356
    ##   5 0.07181818 0.16785817
    ##   6 0.00000000 0.00000000
    ##   7 0.01291667 0.02926330

``` r
#### Make predictions ----
predictions <- predict(Glass_model_nb,
                       Glass_test[, -10])

#### Display the model's evaluation metrics ----
confusion_matrix <-
  caret::confusionMatrix(predictions,
                         Glass_test[, 1:10]$Type)
print(confusion_matrix)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction 1 2 3 5 6 7
    ##          1 8 8 2 0 0 0
    ##          2 2 2 0 0 0 0
    ##          3 2 1 1 0 0 0
    ##          5 0 2 0 0 0 0
    ##          6 2 2 0 2 1 0
    ##          7 0 0 0 0 0 5
    ## 
    ## Overall Statistics
    ##                                           
    ##                Accuracy : 0.425           
    ##                  95% CI : (0.2704, 0.5911)
    ##     No Information Rate : 0.375           
    ##     P-Value [Acc > NIR] : 0.3087          
    ##                                           
    ##                   Kappa : 0.2581          
    ##                                           
    ##  Mcnemar's Test P-Value : NA              
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: 1 Class: 2 Class: 3 Class: 5 Class: 6 Class: 7
    ## Sensitivity            0.5714   0.1333   0.3333   0.0000   1.0000    1.000
    ## Specificity            0.6154   0.9200   0.9189   0.9474   0.8462    1.000
    ## Pos Pred Value         0.4444   0.5000   0.2500   0.0000   0.1429    1.000
    ## Neg Pred Value         0.7273   0.6389   0.9444   0.9474   1.0000    1.000
    ## Prevalence             0.3500   0.3750   0.0750   0.0500   0.0250    0.125
    ## Detection Rate         0.2000   0.0500   0.0250   0.0000   0.0250    0.125
    ## Detection Prevalence   0.4500   0.1000   0.1000   0.0500   0.1750    0.125
    ## Balanced Accuracy      0.5934   0.5267   0.6261   0.4737   0.9231    1.000

## 2.b. Naïve Bayes Classifier for a Classification Problem with CARET

``` r
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
```

    ## Naive Bayes 
    ## 
    ## 153 samples
    ##   9 predictor
    ##   6 classes: '1', '2', '3', '5', '6', '7' 
    ## 
    ## No pre-processing
    ## Resampling: Cross-Validated (10 fold) 
    ## Summary of sample sizes: 139, 138, 137, 139, 137, 137, ... 
    ## Resampling results across tuning parameters:
    ## 
    ##   usekernel  Accuracy   Kappa    
    ##   FALSE            NaN        NaN
    ##    TRUE      0.5595833  0.4088597
    ## 
    ## Tuning parameter 'fL' was held constant at a value of 0
    ## Tuning
    ##  parameter 'adjust' was held constant at a value of 1
    ## Accuracy was used to select the optimal model using the largest value.
    ## The final values used for the model were fL = 0, usekernel = TRUE and adjust
    ##  = 1.

``` r
#### Make predictions ----
predictions <- predict(Glass_caret_model_nb,
                       Glass_train_imputed[, 1:9])

#### Display the model's evaluation metrics ----
confusion_matrix <-
  caret::confusionMatrix(predictions,
                         Glass_train_imputed[, 1:10]$Type)
print(confusion_matrix)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction  1  2  3  5  6  7
    ##          1 45 15  6  0  1  0
    ##          2  3 36  1  0  0  0
    ##          3  1  0  5  0  0  1
    ##          5  0  2  0 10  0  0
    ##          6  0  1  0  0  6  0
    ##          7  0  0  0  0  0 20
    ## 
    ## Overall Statistics
    ##                                          
    ##                Accuracy : 0.7974         
    ##                  95% CI : (0.7249, 0.858)
    ##     No Information Rate : 0.3529         
    ##     P-Value [Acc > NIR] : < 2.2e-16      
    ##                                          
    ##                   Kappa : 0.7257         
    ##                                          
    ##  Mcnemar's Test P-Value : NA             
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: 1 Class: 2 Class: 3 Class: 5 Class: 6 Class: 7
    ## Sensitivity            0.9184   0.6667  0.41667  1.00000  0.85714   0.9524
    ## Specificity            0.7885   0.9596  0.98582  0.98601  0.99315   1.0000
    ## Pos Pred Value         0.6716   0.9000  0.71429  0.83333  0.85714   1.0000
    ## Neg Pred Value         0.9535   0.8407  0.95205  1.00000  0.99315   0.9925
    ## Prevalence             0.3203   0.3529  0.07843  0.06536  0.04575   0.1373
    ## Detection Rate         0.2941   0.2353  0.03268  0.06536  0.03922   0.1307
    ## Detection Prevalence   0.4379   0.2614  0.04575  0.07843  0.04575   0.1307
    ## Balanced Accuracy      0.8534   0.8131  0.70124  0.99301  0.92515   0.9762

## 3.a. kNN for a classification problem without CARET’s train function

``` r
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
```

    ## 2-nearest neighbor model
    ## Training set outcome distribution:
    ## 
    ##  1  2  3  5  6  7 
    ## 56 61 14 11  8 24

``` r
#### Make predictions ----
predictions <- predict(Glass_model_knn,
                       Glass_test[, 1:9],
                       type = "class")

#### Display the model's evaluation metrics ----
table(predictions, Glass_test$Type)
```

    ##            
    ## predictions 1 2 3 5 6 7
    ##           1 9 4 1 0 0 0
    ##           2 2 9 0 0 0 0
    ##           3 3 1 2 0 0 0
    ##           5 0 0 0 2 0 0
    ##           6 0 0 0 0 1 0
    ##           7 0 1 0 0 0 5

``` r
# Or alternatively:
confusion_matrix <-
  caret::confusionMatrix(predictions,
                         Glass_test$Type)
print(confusion_matrix)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction 1 2 3 5 6 7
    ##          1 9 4 1 0 0 0
    ##          2 2 9 0 0 0 0
    ##          3 3 1 2 0 0 0
    ##          5 0 0 0 2 0 0
    ##          6 0 0 0 0 1 0
    ##          7 0 1 0 0 0 5
    ## 
    ## Overall Statistics
    ##                                           
    ##                Accuracy : 0.7             
    ##                  95% CI : (0.5347, 0.8344)
    ##     No Information Rate : 0.375           
    ##     P-Value [Acc > NIR] : 3.088e-05       
    ##                                           
    ##                   Kappa : 0.5953          
    ##                                           
    ##  Mcnemar's Test P-Value : NA              
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: 1 Class: 2 Class: 3 Class: 5 Class: 6 Class: 7
    ## Sensitivity            0.6429   0.6000   0.6667     1.00    1.000   1.0000
    ## Specificity            0.8077   0.9200   0.8919     1.00    1.000   0.9714
    ## Pos Pred Value         0.6429   0.8182   0.3333     1.00    1.000   0.8333
    ## Neg Pred Value         0.8077   0.7931   0.9706     1.00    1.000   1.0000
    ## Prevalence             0.3500   0.3750   0.0750     0.05    0.025   0.1250
    ## Detection Rate         0.2250   0.2250   0.0500     0.05    0.025   0.1250
    ## Detection Prevalence   0.3500   0.2750   0.1500     0.05    0.025   0.1500
    ## Balanced Accuracy      0.7253   0.7600   0.7793     1.00    1.000   0.9857

## 3.b. kNN for a classification problem with CARET’s train function

``` r
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
```

    ## k-Nearest Neighbors 
    ## 
    ## 214 samples
    ##   9 predictor
    ##   6 classes: '1', '2', '3', '5', '6', '7' 
    ## 
    ## Pre-processing: centered (9), scaled (9) 
    ## Resampling: Cross-Validated (10 fold) 
    ## Summary of sample sizes: 192, 191, 192, 193, 194, 192, ... 
    ## Resampling results across tuning parameters:
    ## 
    ##   k  Accuracy   Kappa    
    ##   5  0.6693027  0.5362041
    ##   7  0.6690457  0.5342341
    ##   9  0.6738076  0.5403175
    ## 
    ## Accuracy was used to select the optimal model using the largest value.
    ## The final value used for the model was k = 9.

``` r
#### Make predictions ----
predictions <- predict(Glass_caret_model_knn,
                       Glass_test[, 1:9])

#### Display the model's evaluation metrics ----
confusion_matrix <-
  caret::confusionMatrix(predictions,
                         Glass_test[, 1:10]$Type)
print(confusion_matrix)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction  1  2  3  5  6  7
    ##          1 19  5  4  0  0  1
    ##          2  2 16  1  0  0  0
    ##          3  0  0  0  0  0  0
    ##          5  0  1  0  2  0  0
    ##          6  0  0  0  0  2  0
    ##          7  0  0  0  1  0  7
    ## 
    ## Overall Statistics
    ##                                           
    ##                Accuracy : 0.7541          
    ##                  95% CI : (0.6271, 0.8554)
    ##     No Information Rate : 0.3607          
    ##     P-Value [Acc > NIR] : 4.418e-10       
    ##                                           
    ##                   Kappa : 0.6504          
    ##                                           
    ##  Mcnemar's Test P-Value : NA              
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: 1 Class: 2 Class: 3 Class: 5 Class: 6 Class: 7
    ## Sensitivity            0.9048   0.7273  0.00000  0.66667  1.00000   0.8750
    ## Specificity            0.7500   0.9231  1.00000  0.98276  1.00000   0.9811
    ## Pos Pred Value         0.6552   0.8421      NaN  0.66667  1.00000   0.8750
    ## Neg Pred Value         0.9375   0.8571  0.91803  0.98276  1.00000   0.9811
    ## Prevalence             0.3443   0.3607  0.08197  0.04918  0.03279   0.1311
    ## Detection Rate         0.3115   0.2623  0.00000  0.03279  0.03279   0.1148
    ## Detection Prevalence   0.4754   0.3115  0.00000  0.04918  0.03279   0.1311
    ## Balanced Accuracy      0.8274   0.8252  0.50000  0.82471  1.00000   0.9281

## 4.a. SVM Classifier for a classification problem with CARET

``` r
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
```

    ## Support Vector Machines with Radial Basis Function Kernel 
    ## 
    ## 153 samples
    ##   9 predictor
    ##   6 classes: '1', '2', '3', '5', '6', '7' 
    ## 
    ## No pre-processing
    ## Resampling: Cross-Validated (11 fold) 
    ## Summary of sample sizes: 139, 138, 138, 139, 141, 139, ... 
    ## Resampling results across tuning parameters:
    ## 
    ##   C     Accuracy   Kappa    
    ##   0.25  0.6202298  0.4384773
    ##   0.50  0.6777223  0.5310272
    ##   1.00  0.7030470  0.5758018
    ## 
    ## Tuning parameter 'sigma' was held constant at a value of 0.2576114
    ## Accuracy was used to select the optimal model using the largest value.
    ## The final values used for the model were sigma = 0.2576114 and C = 1.

``` r
#### Make predictions ----
predictions <- predict(Glass_caret_model_svm_radial,
                       Glass_test[, 1:9])

#### Display the model's evaluation metrics ----
table(predictions, Glass_test$Type)
```

    ##            
    ## predictions  1  2  3  5  6  7
    ##           1 19  8  3  0  0  1
    ##           2  2 14  2  1  1  3
    ##           3  0  0  0  0  0  0
    ##           5  0  0  0  2  0  0
    ##           6  0  0  0  0  1  0
    ##           7  0  0  0  0  0  4

``` r
confusion_matrix <-
  caret::confusionMatrix(predictions,
                         Glass_test[, 1:10]$Type)
print(confusion_matrix)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction  1  2  3  5  6  7
    ##          1 19  8  3  0  0  1
    ##          2  2 14  2  1  1  3
    ##          3  0  0  0  0  0  0
    ##          5  0  0  0  2  0  0
    ##          6  0  0  0  0  1  0
    ##          7  0  0  0  0  0  4
    ## 
    ## Overall Statistics
    ##                                           
    ##                Accuracy : 0.6557          
    ##                  95% CI : (0.5231, 0.7727)
    ##     No Information Rate : 0.3607          
    ##     P-Value [Acc > NIR] : 2.711e-06       
    ##                                           
    ##                   Kappa : 0.4925          
    ##                                           
    ##  Mcnemar's Test P-Value : NA              
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: 1 Class: 2 Class: 3 Class: 5 Class: 6 Class: 7
    ## Sensitivity            0.9048   0.6364  0.00000  0.66667  0.50000  0.50000
    ## Specificity            0.7000   0.7692  1.00000  1.00000  1.00000  1.00000
    ## Pos Pred Value         0.6129   0.6087      NaN  1.00000  1.00000  1.00000
    ## Neg Pred Value         0.9333   0.7895  0.91803  0.98305  0.98333  0.92982
    ## Prevalence             0.3443   0.3607  0.08197  0.04918  0.03279  0.13115
    ## Detection Rate         0.3115   0.2295  0.00000  0.03279  0.01639  0.06557
    ## Detection Prevalence   0.5082   0.3770  0.00000  0.03279  0.01639  0.06557
    ## Balanced Accuracy      0.8024   0.7028  0.50000  0.83333  0.75000  0.75000

## 4.b. SVM Classifier for a classification problem without CARET

``` r
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
```

    ## Support Vector Machine object of class "ksvm" 
    ## 
    ## SV type: C-svc  (classification) 
    ##  parameter : cost C = 1 
    ## 
    ## Gaussian Radial Basis kernel function. 
    ##  Hyperparameter : sigma =  0.185383732995563 
    ## 
    ## Number of Support Vectors : 134 
    ## 
    ## Objective Function Value : -57.1113 -22.0066 -5.589 -6.255 -7.0466 -21.9399 -11.0195 -8.4698 -10.0512 -5.1011 -5.4737 -6.035 -5.4248 -7.105 -6.4565 
    ## Training error : 0.215686

``` r
#### Make predictions ----
predictions <- predict(Glass_model_svm, Glass_test[, 1:9],
                       type = "response")

#### Display the model's evaluation metrics ----
table(predictions, Glass_test$Type)
```

    ##            
    ## predictions  1  2  3  5  6  7
    ##           1 19  3  2  0  0  0
    ##           2  2 19  3  0  0  1
    ##           3  0  0  0  0  0  0
    ##           5  0  0  0  3  1  0
    ##           6  0  0  0  0  1  0
    ##           7  0  0  0  0  0  7

``` r
confusion_matrix <-
  caret::confusionMatrix(predictions,
                         Glass_test[, 1:10]$Type)
print(confusion_matrix)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction  1  2  3  5  6  7
    ##          1 19  3  2  0  0  0
    ##          2  2 19  3  0  0  1
    ##          3  0  0  0  0  0  0
    ##          5  0  0  0  3  1  0
    ##          6  0  0  0  0  1  0
    ##          7  0  0  0  0  0  7
    ## 
    ## Overall Statistics
    ##                                          
    ##                Accuracy : 0.8033         
    ##                  95% CI : (0.6816, 0.894)
    ##     No Information Rate : 0.3607         
    ##     P-Value [Acc > NIR] : 1.86e-12       
    ##                                          
    ##                   Kappa : 0.7181         
    ##                                          
    ##  Mcnemar's Test P-Value : NA             
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: 1 Class: 2 Class: 3 Class: 5 Class: 6 Class: 7
    ## Sensitivity            0.9048   0.8636  0.00000  1.00000  0.50000   0.8750
    ## Specificity            0.8750   0.8462  1.00000  0.98276  1.00000   1.0000
    ## Pos Pred Value         0.7917   0.7600      NaN  0.75000  1.00000   1.0000
    ## Neg Pred Value         0.9459   0.9167  0.91803  1.00000  0.98333   0.9815
    ## Prevalence             0.3443   0.3607  0.08197  0.04918  0.03279   0.1311
    ## Detection Rate         0.3115   0.3115  0.00000  0.04918  0.01639   0.1148
    ## Detection Prevalence   0.3934   0.4098  0.00000  0.06557  0.01639   0.1148
    ## Balanced Accuracy      0.8899   0.8549  0.50000  0.99138  0.75000   0.9375
