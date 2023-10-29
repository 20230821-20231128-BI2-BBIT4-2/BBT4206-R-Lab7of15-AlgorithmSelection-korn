Business Intelligence Project
================
korn
27/10/23

- [Student Details](#student-details)
- [Setup Chunk](#setup-chunk)
- [STEP 1. Install and Load the Required
  Packages](#step-1-install-and-load-the-required-packages)

# Student Details

<table>
<colgroup>
<col style="width: 53%" />
<col style="width: 46%" />
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

# STEP 1. Install and Load the Required Packages

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

``` r
# A. Linear Algorithms ----
## 1. Linear Regression ----
### 1.a. Linear Regression using Ordinary Least Squares without caret ----
# The lm() function is in the stats package and creates a linear regression
# model using ordinary least squares (OLS).

### Load and split the dataset ----
library(readr)
insurance <- read_csv("../data/insurance.csv")
```

    ## Rows: 1338 Columns: 7

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (3): sex, smoker, region
    ## dbl (4): age, bmi, children, charges
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
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
```

    ## 
    ## Call:
    ## lm(formula = charges ~ ., data = insurance_train)
    ## 
    ## Coefficients:
    ##     (Intercept)              age          sexmale              bmi  
    ##        -11180.5            250.6           -202.2            327.9  
    ##        children        smokeryes  regionnorthwest  regionsoutheast  
    ##           607.8          23500.8           -629.9          -1466.0  
    ## regionsouthwest  
    ##         -1354.3

``` r
#### Make predictions ----
predictions <- predict(insurance_model_lm, insurance_test[, 1:7])

#### Display the model's evaluation metrics ----
##### RMSE ----
rmse <- sqrt(mean((insurance_test$charges - predictions)^2))
print(paste("RMSE =", sprintf(rmse, fmt = "%#.4f")))
```

    ## [1] "RMSE = 6096.8772"

``` r
##### SSR ----
# SSR is the sum of squared residuals (the sum of squared differences
# between observed and predicted values)
ssr <- sum((insurance_test$charges - predictions)^2)
print(paste("SSR =", sprintf(ssr, fmt = "%#.4f")))
```

    ## [1] "SSR = 9887728612.9601"

``` r
##### SST ----
# SST is the total sum of squares (the sum of squared differences
# between observed values and their mean)
sst <- sum((insurance_test$charges - mean(insurance_test$charges))^2)
print(paste("SST =", sprintf(sst, fmt = "%#.4f")))
```

    ## [1] "SST = 42257924696.6010"

``` r
##### R Squared ----
# We then use SSR and SST to compute the value of R squared.
# The closer the R squared value is to 1, the better the model.
r_squared <- 1 - (ssr / sst)
print(paste("R Squared =", sprintf(r_squared, fmt = "%#.4f")))
```

    ## [1] "R Squared = 0.7660"

``` r
##### MAE ----
# MAE is expressed in the same units as the target variable, making it easy to
# interpret. For example, if you are predicting the amount paid in rent,
# and the MAE is KES. 10,000, it means, on average, your model's predictions
# are off by about KES. 10,000.
absolute_errors <- abs(predictions - insurance_test$charges)
mae <- mean(absolute_errors)
print(paste("MAE =", sprintf(mae, fmt = "%#.4f")))
```

    ## [1] "MAE = 4216.1022"

``` r
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
```

    ## Linear Regression 
    ## 
    ## 1072 samples
    ##    6 predictor
    ## 
    ## Pre-processing: centered (8), scaled (8) 
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 857, 857, 858, 859, 857 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared   MAE    
    ##   5990.485  0.7497502  4201.24
    ## 
    ## Tuning parameter 'intercept' was held constant at a value of TRUE

``` r
#### Make predictions ----
predictions <- predict(insurance_caret_model_lm,
                       insurance_test[, 1:7])

#### Display the model's evaluation metrics ----
##### RMSE ----
rmse <- sqrt(mean((insurance_test$charges - predictions)^2))
print(paste("RMSE =", sprintf(rmse, fmt = "%#.4f")))
```

    ## [1] "RMSE = 6432.8182"

``` r
##### SSR ----
# SSR is the sum of squared residuals (the sum of squared differences
# between observed and predicted values)
ssr <- sum((insurance_test$charges - predictions)^2)
print(paste("SSR =", sprintf(ssr, fmt = "%#.4f")))
```

    ## [1] "SSR = 11007385800.2619"

``` r
##### SST ----
# SST is the total sum of squares (the sum of squared differences
# between observed values and their mean)
sst <- sum((insurance_test$charges - mean(insurance_test$charges))^2)
print(paste("SST =", sprintf(sst, fmt = "%#.4f")))
```

    ## [1] "SST = 43071903523.4514"

``` r
##### R Squared ----
# We then use SSR and SST to compute the value of R squared.
# The closer the R squared value is to 1, the better the model.
r_squared <- 1 - (ssr / sst)
print(paste("R Squared =", sprintf(r_squared, fmt = "%#.4f")))
```

    ## [1] "R Squared = 0.7444"

``` r
##### MAE ----
# MAE is expressed in the same units as the target variable, making it easy to
# interpret. For example, if you are predicting the amount paid in rent,
# and the MAE is KES. 10,000, it means, on average, your model's predictions
# are off by about KES. 10,000.
absolute_errors <- abs(predictions - insurance_test$charges)
mae <- mean(absolute_errors)
print(paste("MAE =", sprintf(mae, fmt = "%#.4f")))
```

    ## [1] "MAE = 4271.5991"

``` r
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
```

    ## NULL

``` r
levels(data_test$charges)
```

    ## NULL

``` r
predictions <- factor(predictions, levels = levels(data_test$charges))

#### Display the model's details ----
print(model)
```

    ## Generalized Linear Model 
    ## 
    ## 938 samples
    ##   6 predictor
    ## 
    ## No pre-processing
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 750, 750, 751, 751, 750 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared   MAE     
    ##   6017.499  0.7569529  4153.392

``` r
#### Make predictions ----
probabilities <- predict(model, data_test[, 1:7],
                         type = "raw")
print(probabilities)
```

    ##           1           2           3           4           5           6 
    ## 25795.84134  6562.36310  5649.22550 10555.79265  8089.96160 35735.39633 
    ##           7           8           9          10          11          12 
    ## 14725.15482 14865.76687 30745.72584 32187.69883 12773.89793  1882.90702 
    ##          13          14          15          16          17          18 
    ##   912.42857 39744.27904  6861.48381 32417.62781  4978.81637  9152.75952 
    ##          19          20          21          22          23          24 
    ## 12667.88554 24778.63663  9534.64252  7805.77403 12818.34798  8472.19096 
    ##          25          26          27          28          29          30 
    ## 12585.36109 31794.88358  9005.08915  5901.71530 12783.76220  8487.73394 
    ##          31          32          33          34          35          36 
    ## 26834.87319 38661.20177 12225.08935 12848.05858 18046.23900  4695.97419 
    ##          37          38          39          40          41          42 
    ## 13155.03450 12919.08338  5220.59623  6120.39252  6070.34748 35012.96573 
    ##          43          44          45          46          47          48 
    ## 13227.18638  5258.41500  9118.71440 31378.59959 30591.74078 28292.60650 
    ##          49          50          51          52          53          54 
    ## 14576.91215 11252.56195  8645.82890  4083.34544 16767.10609  5391.76840 
    ##          55          56          57          58          59          60 
    ## 40009.06235 11118.53865  9718.39422 11209.13899  4752.45805  8064.89052 
    ##          61          62          63          64          65          66 
    ##  6841.90539  7109.59379 11557.47383  7027.63082  3736.27189 10759.93816 
    ##          67          68          69          70          71          72 
    ## 12512.23746  3917.43539 13576.99391  6919.45596  9452.73294  6822.47667 
    ##          73          74          75          76          77          78 
    ##  8659.77419 26491.56400 31470.49844 10818.88891 10545.21923 15135.74335 
    ##          79          80          81          82          83          84 
    ##  5698.41758 35448.19505 10662.13353 27439.29135 38168.58149  9635.17616 
    ##          85          86          87          88          89          90 
    ## 11490.40288  3464.21221  1329.92605 13435.99930  7850.08067 33559.30317 
    ##          91          92          93          94          95          96 
    ## 10323.95224  7270.80213  6535.80677 12744.28110  8475.57237  9225.30661 
    ##          97          98          99         100         101         102 
    ## 10142.91908 12118.17318  2925.22043 16311.76579  7061.92991 10227.31765 
    ##         103         104         105         106         107         108 
    ##  8733.18487  4752.45805  8152.93144  6954.90456  7976.79355 10562.97336 
    ##         109         110         111         112         113         114 
    ## 10528.16933 10574.40935  3354.85763 30634.27909 11958.82345 14967.02803 
    ##         115         116         117         118         119         120 
    ##  9845.38714  5674.80717 13965.61599  5505.36294 11467.44904 12852.88499 
    ##         121         122         123         124         125         126 
    ##  7319.46824 15237.38772 15243.38511  3841.37535  5101.46579  5686.89060 
    ##         127         128         129         130         131         132 
    ##  3903.55839 37000.40652  4797.76506  6484.87780  6924.30457 12852.24017 
    ##         133         134         135         136         137         138 
    ## 35355.26602 14648.30152 12659.81785 13247.16358 10967.66132 11440.55955 
    ##         139         140         141         142         143         144 
    ## 34654.50879  6149.43970  4774.34698 12848.47538  2447.98417  6698.97074 
    ##         145         146         147         148         149         150 
    ##  1796.72175  1472.22517 17141.44286  9153.45058  7064.35222  4422.80616 
    ##         151         152         153         154         155         156 
    ##  3029.18459  2362.03280 31100.48714  4455.12502 10306.48171  6386.31540 
    ##         157         158         159         160         161         162 
    ##  9490.50127 13405.78774 10249.08149  8763.42408 40766.85133  4383.82943 
    ##         163         164         165         166         167         168 
    ## 10074.61572  3291.65475 11415.56030 12962.16370 15069.80276  3199.22639 
    ##         169         170         171         172         173         174 
    ## 11720.00505 38417.68195  5166.76483 10233.17964 15129.79057 11803.09888 
    ##         175         176         177         178         179         180 
    ##  1694.62542 10953.14870 11998.44185  2981.34378  5600.06385 31296.41874 
    ##         181         182         183         184         185         186 
    ## 15778.99524 11855.51044 25602.54406  8684.94499 17786.34449  9451.33442 
    ##         187         188         189         190         191         192 
    ##  9688.65263  4759.35261 35881.21995 33134.11579 13802.16253 12339.63379 
    ##         193         194         195         196         197         198 
    ## 14598.86013 13164.07352  3241.05796  6576.57656 13863.27694 11912.63321 
    ##         199         200         201         202         203         204 
    ## 14346.95441 12984.32339  9707.45603 38498.93208  -771.68840  9361.08334 
    ##         205         206         207         208         209         210 
    ##  2727.82233  1920.02189 13235.47240 14277.47676 10296.12569  7812.01973 
    ##         211         212         213         214         215         216 
    ##  3920.62021  8701.38513  6838.40521  1262.54086 13888.09905 29467.62031 
    ##         217         218         219         220         221         222 
    ##  8275.79560  8480.94339 36953.26573  4111.60744 11232.55996    43.38899 
    ##         223         224         225         226         227         228 
    ##  5316.78292  9553.34338  9642.66423 28482.08039  6510.86064 13102.09062 
    ##         229         230         231         232         233         234 
    ## 10406.65945 16039.46956 26677.85569 12841.34217  8744.05104 33855.77778 
    ##         235         236         237         238         239         240 
    ##  7022.60514  1836.25867  4175.03568 28878.09772 30084.97507  5221.04474 
    ##         241         242         243         244         245         246 
    ##  3660.06576  3743.11894  2359.04088 32374.70058  9292.60771  5883.64158 
    ##         247         248         249         250         251         252 
    ## 13954.53465  8729.65093 35661.10807 35933.86239 34120.60791 34517.81018 
    ##         253         254         255         256         257         258 
    ## 37711.82419  8666.16710  3402.35370  8679.22871  7749.00616  5897.61847 
    ##         259         260         261         262         263         264 
    ##  7273.64170  6134.99840 13894.69071  9837.91722   545.58980 14381.90537 
    ##         265         266         267         268         269         270 
    ## 27934.99096  3411.89699 31989.55695 31233.83469 12410.98555  1167.44750 
    ##         271         272         273         274         275         276 
    ## 10127.43516  8302.71631 15758.22368 14060.67506  8689.35132  5684.66488 
    ##         277         278         279         280         281         282 
    ## 15373.42572  3074.46940  4950.17751  3900.48140 14479.53636 29194.39005 
    ##         283         284         285         286         287         288 
    ##  1271.21246  8251.31285 11612.09291  6595.40500 27057.14323  7425.75830 
    ##         289         290         291         292         293         294 
    ## 15480.26369 28387.35487  2077.18227  9315.92913  5986.07367  7304.15845 
    ##         295         296         297         298         299         300 
    ## 15579.19656  6410.70149  6501.57589 15007.55896  5307.43579    28.33155 
    ##         301         302         303         304         305         306 
    ## 29995.83519 34129.78374  3482.23985 30376.94442 32146.65855  7696.29850 
    ##         307         308         309         310         311         312 
    ## 12013.32800 10961.99446  6648.60410 11215.96388  7875.84336  5272.34841 
    ##         313         314         315         316         317         318 
    ## 14542.67474  3700.40603 12582.21981 14788.32509 29791.98667 16555.36028 
    ##         319         320         321         322         323         324 
    ## 13194.11090  3999.09930 11864.01052 11553.74674 13729.92286  4413.60525 
    ##         325         326         327         328         329         330 
    ## 34860.03581  2278.02085 12290.93288 31853.63376  6587.23805 12352.91349 
    ##         331         332         333         334         335         336 
    ## 11158.43044 15986.85192  6296.10118 11452.84338  5567.16515 12509.27623 
    ##         337         338         339         340         341         342 
    ##  3922.05300  9318.56314 34415.63962  6299.77856  9406.15871 10974.59228 
    ##         343         344         345         346         347         348 
    ##  8391.66624  6052.09506 14907.53899  9322.86012 26438.45462  2261.02660 
    ##         349         350         351         352         353         354 
    ##  4254.49558  4072.03032 27199.26722  8322.98883  3280.41771 27056.94663 
    ##         355         356         357         358         359         360 
    ## 26435.77667 30817.99655 14990.38703  7750.33267  9224.89859  5885.50343 
    ##         361         362         363         364         365         366 
    ##  5898.20658 35187.67744  3859.12657  6437.80864  8153.48225  7011.65446 
    ##         367         368         369         370         371         372 
    ## 12683.31273  9710.58222 12150.59891  8217.30813 39037.61805 40415.69943 
    ##         373         374         375         376         377         378 
    ##  5264.56335 28311.74964 25595.80921  3441.34247  7272.53610  9196.25377 
    ##         379         380         381         382         383         384 
    ##  6271.61251  5629.04250  4237.16796 32519.63084 10575.29328 24350.62715 
    ##         385         386         387         388         389         390 
    ## 30503.18632 10101.02487  9417.74534  6308.01733 27152.40124 31179.55816 
    ##         391         392         393         394         395         396 
    ##  2738.68894  -647.34563  9441.14283 12087.50706 15640.24835 36321.93588 
    ##         397         398         399         400 
    ## 10417.18634 12151.09722  1579.76698 37197.48072

``` r
predictions <- ifelse(probabilities > 0.5, "pos", "neg")
print(predictions)
```

    ##     1     2     3     4     5     6     7     8     9    10    11    12    13 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##    14    15    16    17    18    19    20    21    22    23    24    25    26 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##    27    28    29    30    31    32    33    34    35    36    37    38    39 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##    40    41    42    43    44    45    46    47    48    49    50    51    52 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##    53    54    55    56    57    58    59    60    61    62    63    64    65 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##    66    67    68    69    70    71    72    73    74    75    76    77    78 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##    79    80    81    82    83    84    85    86    87    88    89    90    91 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##    92    93    94    95    96    97    98    99   100   101   102   103   104 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   105   106   107   108   109   110   111   112   113   114   115   116   117 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   118   119   120   121   122   123   124   125   126   127   128   129   130 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   131   132   133   134   135   136   137   138   139   140   141   142   143 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   144   145   146   147   148   149   150   151   152   153   154   155   156 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   157   158   159   160   161   162   163   164   165   166   167   168   169 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   170   171   172   173   174   175   176   177   178   179   180   181   182 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   183   184   185   186   187   188   189   190   191   192   193   194   195 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   196   197   198   199   200   201   202   203   204   205   206   207   208 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "neg" "pos" "pos" "pos" "pos" "pos" 
    ##   209   210   211   212   213   214   215   216   217   218   219   220   221 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   222   223   224   225   226   227   228   229   230   231   232   233   234 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   235   236   237   238   239   240   241   242   243   244   245   246   247 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   248   249   250   251   252   253   254   255   256   257   258   259   260 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   261   262   263   264   265   266   267   268   269   270   271   272   273 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   274   275   276   277   278   279   280   281   282   283   284   285   286 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   287   288   289   290   291   292   293   294   295   296   297   298   299 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   300   301   302   303   304   305   306   307   308   309   310   311   312 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   313   314   315   316   317   318   319   320   321   322   323   324   325 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   326   327   328   329   330   331   332   333   334   335   336   337   338 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   339   340   341   342   343   344   345   346   347   348   349   350   351 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   352   353   354   355   356   357   358   359   360   361   362   363   364 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   365   366   367   368   369   370   371   372   373   374   375   376   377 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   378   379   380   381   382   383   384   385   386   387   388   389   390 
    ## "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos" 
    ##   391   392   393   394   395   396   397   398   399   400 
    ## "pos" "neg" "pos" "pos" "pos" "pos" "pos" "pos" "pos" "pos"

``` r
#### Display the model's evaluation metrics ----
table(predictions, data_test$charges)
```

    ##            
    ## predictions 1163.4627 1253.936 1256.299 1391.5287 1534.3045 1622.1885
    ##         neg         0        0        0         0         0         0
    ##         pos         1        1        1         1         1         1
    ##            
    ## predictions 1627.28245 1631.8212 1633.9618 1639.5631 1664.9996 1674.6323
    ##         neg          0         0         0         0         0         0
    ##         pos          1         1         1         1         1         1
    ##            
    ## predictions 1682.597 1727.54 1731.677 1837.2819 1909.52745 1972.95 1977.815
    ##         neg        0       0        1         0          0       0        0
    ##         pos        1       1        0         1          1       1        1
    ##            
    ## predictions 1980.07 1984.4533 2007.945 2026.9741 2104.1134 2117.33885
    ##         neg       0         0        0         0         0          0
    ##         pos       1         1        1         1         1          1
    ##            
    ## predictions 2128.43105 2130.6759 2136.88225 2138.0707 2150.469 2154.361
    ##         neg          0         0          0         0        0        0
    ##         pos          1         1          1         1        1        1
    ##            
    ## predictions 2166.732 2196.4732 2198.18985 2211.13075 2250.8352 2261.5688 2302.3
    ##         neg        0         0          0          0         0         0      0
    ##         pos        1         1          1          1         1         1      1
    ##            
    ## predictions 2352.96845 2396.0959 2457.502 2480.9791 2523.1695 2534.39375
    ##         neg          0         0        0         0         0          0
    ##         pos          1         1        1         1         1          1
    ##            
    ## predictions 2585.269 2632.992 2639.0429 2643.2685 2689.4954 2719.27975
    ##         neg        1        0         0         0         0          0
    ##         pos        0        1         1         1         1          1
    ##            
    ## predictions 2727.3951 2731.9122 2741.948 2842.76075 2850.68375 2855.43755
    ##         neg         0         0        0          0          0          0
    ##         pos         1         1        1          1          1          1
    ##            
    ## predictions 2902.9065 2904.088 2913.569 3044.2133 3062.50825 3213.62205
    ##         neg         0        0        0         0          0          0
    ##         pos         1        1        1         1          1          1
    ##            
    ## predictions 3238.4357 3277.161 3279.86855 3292.52985 3309.7926 3366.6697
    ##         neg         0        0          0          0         0         0
    ##         pos         1        1          1          1         1         1
    ##            
    ## predictions 3378.91 3385.39915 3443.064 3490.5491 3556.9223 3704.3545 3757.8448
    ##         neg       0          0        0         0         0         0         0
    ##         pos       1          1        1         1         1         1         1
    ##            
    ## predictions 3761.292 3847.674 3857.75925 3866.8552 3925.7582 3956.07145
    ##         neg        0        0          0         0         0          0
    ##         pos        1        1          1         1         1          1
    ##            
    ## predictions 3987.926 3989.841 4040.55825 4074.4537 4134.08245 4151.0287
    ##         neg        0        0          0         0          0         0
    ##         pos        1        1          1         1          1         1
    ##            
    ## predictions 4185.0979 4347.02335 4391.652 4428.88785 4438.2634 4449.462
    ##         neg         0          0        0          0         0        0
    ##         pos         1          1        1          1         1        1
    ##            
    ## predictions 4463.2051 4527.18295 4544.2348 4618.0799 4667.60765 4718.20355
    ##         neg         0          0         0         0          0          0
    ##         pos         1          1         1         1          1          1
    ##            
    ## predictions 4719.52405 4747.0529 4753.6368 4779.6023 4922.9159 4992.3764
    ##         neg          0         0         0         0         0         0
    ##         pos          1         1         1         1         1         1
    ##            
    ## predictions 5080.096 5125.2157 5227.98875 5261.46945 5266.3656 5272.1758
    ##         neg        0         0          0          0         0         0
    ##         pos        1         1          1          1         1         1
    ##            
    ## predictions 5325.651 5373.36425 5375.038 5377.4578 5383.536 5428.7277 5484.4673
    ##         neg        0          0        0         0        0         0         0
    ##         pos        1          1        1         1        1         1         1
    ##            
    ## predictions 5708.867 5920.1041 5934.3798 5969.723 5972.378 5974.3847 5979.731
    ##         neg        0         0         0        0        0         0        0
    ##         pos        1         1         1        1        1         1        1
    ##            
    ## predictions 6112.35295 6128.79745 6184.2994 6186.127 6282.235 6373.55735
    ##         neg          0          0         0        0        0          0
    ##         pos          1          1         1        1        1          1
    ##            
    ## predictions 6414.178 6548.19505 6571.544 6593.5083 6600.20595 6610.1097
    ##         neg        0          0        0         0          0         0
    ##         pos        1          1        1         1          1         1
    ##            
    ## predictions 6652.5288 6710.1919 6753.038 6799.458 6849.026 6858.4796 7144.86265
    ##         neg         0         0        0        0        0         0          0
    ##         pos         1         1        1        1        1         1          1
    ##            
    ## predictions 7147.4728 7153.5539 7196.867 7228.21565 7265.7025 7281.5056
    ##         neg         0         0        0          0         0         0
    ##         pos         1         1        1          1         1         1
    ##            
    ## predictions 7325.0482 7419.4779 7421.19455 7448.40395 7639.41745 7640.3092
    ##         neg         0         0          0          0          0         0
    ##         pos         1         1          1          1          1         1
    ##            
    ## predictions 7726.854 7727.2532 7789.635 7935.29115 7986.47525 8017.06115
    ##         neg        0         0        0          0          0          0
    ##         pos        1         1        1          1          1          1
    ##            
    ## predictions 8023.13545 8026.6666 8027.968 8059.6791 8062.764 8083.9198
    ##         neg          0         0        0         0        0         0
    ##         pos          1         1        1         1        1         1
    ##            
    ## predictions 8116.26885 8219.2039 8233.0975 8240.5896 8269.044 8283.6807
    ##         neg          0         0         0         0        0         0
    ##         pos          1         1         1         1        1         1
    ##            
    ## predictions 8334.5896 8342.90875 8413.46305 8442.667 8538.28845 8547.6913
    ##         neg         0          0          0        0          0         0
    ##         pos         1          1          1        1          1         1
    ##            
    ## predictions 8603.8234 8604.48365 8615.3 8703.456 8782.469 8823.279 8930.93455
    ##         neg         0          0      0        0        0        0          0
    ##         pos         1          1      1        1        1        1          1
    ##            
    ## predictions 8932.084 8965.79575 9048.0273 9058.7303 9225.2564 9249.4952
    ##         neg        0          0         0         0         0         0
    ##         pos        1          1         1         1         1         1
    ##            
    ## predictions 9264.797 9282.4806 9288.0267 9290.1395 9301.89355 9304.7019
    ##         neg        0         0         0         0          0         0
    ##         pos        1         1         1         1          1         1
    ##            
    ## predictions 9377.9047 9391.346 9504.3103 9549.5651 9634.538 9644.2525
    ##         neg         0        0         0         0        0         0
    ##         pos         1        1         1         1        1         1
    ##            
    ## predictions 9704.66805 9724.53 9748.9106 9855.1314 9861.025 9863.4718 9877.6077
    ##         neg          0       0         0         0        0         0         0
    ##         pos          1       1         1         1        1         1         1
    ##            
    ## predictions 9910.35985 10065.413 10085.846 10107.2206 10118.424 10141.1362
    ##         neg          0         0         0          0         0          0
    ##         pos          1         1         1          1         1          1
    ##            
    ## predictions 10214.636 10381.4787 10407.08585 10422.91665 10435.06525 10436.096
    ##         neg         0          0           0           0           0         0
    ##         pos         1          1           1           1           1         1
    ##            
    ## predictions 10450.552 10579.711 10594.2257 10600.5483 10602.385 10713.644
    ##         neg         0         0          0          0         0         0
    ##         pos         1         1          1          1         1         1
    ##            
    ## predictions 10736.87075 10807.4863 10923.9332 10976.24575 10982.5013 11085.5868
    ##         neg           0          0          0           0          0          0
    ##         pos           1          1          1           1          1          1
    ##            
    ## predictions 11090.7178 11165.41765 11253.421 11272.33139 11299.343 11345.519
    ##         neg          0           0         0           0         0         0
    ##         pos          1           1         1           1         1         1
    ##            
    ## predictions 11363.2832 11365.952 11381.3254 11396.9002 11520.09985 11534.87265
    ##         neg          0         0          0          0           0           0
    ##         pos          1         1          1          1           1           1
    ##            
    ## predictions 11554.2236 11674.13 11743.299 11743.9341 11830.6072 11833.7823
    ##         neg          0        0         0          0          0          0
    ##         pos          1        1         1          1          1          1
    ##            
    ## predictions 11840.77505 11842.442 11842.62375 11856.4115 11881.358 11945.1327
    ##         neg           0         0           0          0         0          0
    ##         pos           1         1           1          1         1          1
    ##            
    ## predictions 11946.6259 11987.1682 12044.342 12096.6512 12105.32 12129.61415
    ##         neg          0          0         0          0        0           0
    ##         pos          1          1         1          1        1           1
    ##            
    ## predictions 12222.8983 12224.35085 12231.6136 12347.172 12495.29085 12574.049
    ##         neg          0           0          0         0           0         0
    ##         pos          1           1          1         1           1         1
    ##            
    ## predictions 12638.195 12644.589 12648.7034 12890.05765 12913.9924 12928.7911
    ##         neg         0         0          0           0          0          0
    ##         pos         1         1          1           1          1          1
    ##            
    ## predictions 12957.118 12981.3457 13224.05705 13405.3903 13415.0381 13635.6379
    ##         neg         0          0           0          0          0          0
    ##         pos         1          1           1          1          1          1
    ##            
    ## predictions 13887.9685 13974.45555 13981.85035 14001.1338 14133.03775
    ##         neg          0           0           0          0           0
    ##         pos          1           1           1          1           1
    ##            
    ## predictions 14254.6082 14283.4594 14474.675 14711.7438 14988.432 15019.76005
    ##         neg          0          0         0          0         0           0
    ##         pos          1          1         1          1         1           1
    ##            
    ## predictions 15359.1045 16085.1275 16115.3045 16232.847 16420.49455 16884.924
    ##         neg          0          0          0         0           0         0
    ##         pos          1          1          1         1           1         1
    ##            
    ## predictions 17178.6824 17352.6803 17496.306 17560.37975 17748.5062 17904.52705
    ##         neg          0          0         0           0          0           0
    ##         pos          1          1         1           1          1           1
    ##            
    ## predictions 18157.876 18223.4512 18328.2381 18648.4217 18804.7524 18903.49141
    ##         neg         0          0          0          0          0           0
    ##         pos         1          1          1          1          1           1
    ##            
    ## predictions 18955.22017 19023.26 19144.57652 19199.944 19361.9988 19442.3535
    ##         neg           0        0           0         0          0          0
    ##         pos           1        1           1         1          1          1
    ##            
    ## predictions 19496.71917 19673.33573 20234.85475 20296.86345 20709.02034
    ##         neg           0           0           0           0           0
    ##         pos           1           1           1           1           1
    ##            
    ## predictions 20781.48892 20878.78443 21082.16 21098.55405 21223.6758 21232.18226
    ##         neg           0           0        0           0          0           0
    ##         pos           1           1        1           1          1           1
    ##            
    ## predictions 21472.4788 21595.38229 21774.32215 21797.0004 21880.82 22462.04375
    ##         neg          0           0           0          0        0           0
    ##         pos          1           1           1          1        1           1
    ##            
    ## predictions 23045.56616 23306.547 23563.01618 24106.91255 24520.264 24603.04837
    ##         neg           0         0           0           0         0           0
    ##         pos           1         1           1           1         1           1
    ##            
    ## predictions 25333.33284 25382.297 26018.95052 26109.32905 26392.26029
    ##         neg           0         0           0           0           0
    ##         pos           1         1           1           1           1
    ##            
    ## predictions 27322.73386 27533.9129 27724.28875 27808.7251 27941.28758
    ##         neg           0          0           0          0           0
    ##         pos           1          1           1          1           1
    ##            
    ## predictions 28950.4692 29141.3603 30166.61817 30259.99556 30284.64294
    ##         neg          0          0           0           0           0
    ##         pos          1          1           1           1           1
    ##            
    ## predictions 32108.66282 33307.5508 33750.2918 34472.841 35069.37452 35160.13457
    ##         neg           0          0          0         0           0           0
    ##         pos           1          1          1         1           1           1
    ##            
    ## predictions 36149.4835 36307.7983 36580.28216 36837.467 36950.2567 37484.4493
    ##         neg          0          0           0         0          0          0
    ##         pos          1          1           1         1          1          1
    ##            
    ## predictions 37701.8768 38126.2465 38282.7495 38344.566 38511.6283 38709.176
    ##         neg          0          0          0         0          0         0
    ##         pos          1          1          1         1          1         1
    ##            
    ## predictions 38792.6856 39725.51805 40720.55105 40941.2854 40974.1649
    ##         neg          0           0           0          0          0
    ##         pos          1           1           1          1          1
    ##            
    ## predictions 41097.16175 41661.602 41949.2441 42111.6647 42112.2356 42969.8527
    ##         neg           0         0          0          0          0          0
    ##         pos           1         1          1          1          1          1
    ##            
    ## predictions 43254.41795 43896.3763 43943.8761 45702.02235 45710.20785 46113.511
    ##         neg           0          0          0           0           0         0
    ##         pos           1          1          1           1           1         1
    ##            
    ## predictions 46151.1245 47055.5321 47269.854 48173.361 48824.45 49577.6624
    ##         neg          0          0         0         0        0          0
    ##         pos          1          1         1         1        1          1
    ##            
    ## predictions 55135.40209 63770.42801
    ##         neg           0           0
    ##         pos           1           1
