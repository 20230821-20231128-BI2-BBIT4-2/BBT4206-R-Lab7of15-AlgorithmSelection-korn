
if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# Install and Load the Required Packages ----
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
# We will use the Market Basket Analysis dataset available on Kaggle
# here: https://www.kaggle.com/datasets/aslanahmedov/market-basket-analysis/data

# Abstract:
# This is a dataset containing retail data with details concerning all the transactions that have happened over a period of time.

### Loading the Dataset

# We can read data from the Excel spreadsheet as follows:
mba <- read_excel("data/mba.xlsx")
dim(mba)

# We have 522,064 observations and 7 variables

### Handling missing values ----
# Are there missing values in the dataset?
any_na(mba)

# How many? 135,499 missing values
n_miss(mba)

# What is the proportion of missing data in the entire dataset?
prop_miss(mba)

# What is the number and percentage of missing values grouped by
# each variable?
miss_var_summary(mba)

# Which variables contain the most missing values?
gg_miss_var(mba)

# Which combinations of variables are missing together?
gg_miss_upset(mba)

# Removing the variables with missing values ----
mba_removed_vars <-
  mba %>% dplyr::select(-CustomerID)

dim(mba_removed_vars)

# Are there missing values in the dataset?
any_na(mba_removed_vars)

# What is the number and percentage of missing values grouped by
# each variable?
miss_var_summary(mba_removed_vars)

# We now remove the observations that do not have a value for the Itemname
# variable.
mba_removed_vars_obs <- mba_removed_vars %>% filter(complete.cases(.))

# We end up with 520,606 observations to create the association rules
dim(mba_removed_vars_obs)

## Identifying categorical variables ----
# Ensuring the customer's country is recorded as categorical data
mba_removed_vars_obs %>% mutate(Country = as.factor(Country))

# Ensuring the Itemname (name of the product purchased) is recorded
# as categorical data
mba_removed_vars_obs %>% mutate(Itemname = as.factor(Itemname))
str(mba_removed_vars_obs)

dim(mba_removed_vars_obs)
head(mba_removed_vars_obs)

## Record the date and time variables in the correct format by seperating them 
mba_removed_vars_obs$trans_date <-
  as.Date(mba_removed_vars_obs$Date)

# Extract time from InvoiceDate and store it in another variable
mba_removed_vars_obs$trans_time <-
  format(mba_removed_vars_obs$Date, "%H:%M:%S")

## Record the InvoiceNo in the correct format (numeric) ----
# Convert InvoiceNo into numeric
mba_removed_vars_obs$invoice_no <-
  as.numeric(as.character(mba_removed_vars_obs$BillNo))

# Are there missing values in the dataset?
any_na(mba_removed_vars_obs)

# What is the number and percentage of missing values grouped by
# each variable?
miss_var_summary(mba_removed_vars_obs)
dim(mba_removed_vars_obs)

# We now remove the observations that do not have a numeric value for the
# BillNo variable, i.e., the cancelled invoices that did not lead to a
# complete purchase. There are a total of 9,291 cancelled invoices.
mba_removed_vars_obs <- mba_removed_vars_obs %>% filter(complete.cases(.))

# This leads to the dataset now having 520,606 observations to use to create the
# association rules.
dim(mba_removed_vars_obs)

# We then remove the duplicate variables that we do not need
# (BillNo and Date) and we also remove all commas to make it easier
# to identify individual products (some products have commas in their names).
mba_removed_vars_obs <-
  mba_removed_vars_obs %>%
  select(-BillNo,-Date) %>%
  mutate_all(~str_replace_all(., ",", " "))

# The pre-processed data frame now has 520,606 observations and 7 variables.
dim(mba_removed_vars_obs)
View(mba_removed_vars_obs)

# We can save the pre-processing progress made so far
write.csv(mba_removed_vars_obs,
          file = "data/mba_data_before_single_transaction_format.csv",
          row.names = FALSE)

mba_removed_vars_obs <-
  read.csv(file = "data/mba_data_before_single_transaction_format.csv")

## Create a transaction data frame using the "basket format" ----
str(mba_removed_vars_obs)

# ddply is used to split a data frame, apply a function to the split data,
# and then return the result back in a data frame.

transaction_data <-
  plyr::ddply(mba_removed_vars_obs,
              c("invoice_no", "trans_date"),
              function(df1) {
                paste(df1$Itemname, collapse = ",")
              }
  )

View(transaction_data)

## Recording only the `items` variable ----
transaction_data <-
  transaction_data %>%
  dplyr::select("items" = V1)
#  %>% mutate(items = paste("{", items, "}", sep = ""))

View(transaction_data)

## Save the transactions in CSV format ----

write.csv(transaction_data,
          "data/transactions_basket_format_online_mba.csv",
          quote = FALSE, row.names = FALSE)


## Read the transactions fromm the CSV file ----
# We can now, finally, read the basket format transaction data as a
# transaction object.

tr <-
  read.transactions("data/transactions_basket_format_online_mba.csv",
                    format = "basket",
                    header = TRUE,
                    rm.duplicates = TRUE,
                    sep = ","
  )

# This shows there are 20,205 transactions that have been identified
# and 8,906 items
print(tr)
summary(tr)

# Basic EDA ----
# Create an item frequency plot for the top 10 items
itemFrequencyPlot(tr, topN = 10, type = "absolute",
                  col = brewer.pal(8, "Pastel2"),
                  main = "Absolute Item Frequency Plot",
                  horiz = TRUE,
                  mai = c(2, 2, 2, 2))

association_rules <- apriori(tr,
                                       parameter = list(support = 0.01,
                                                        confidence = 0.8,
                                                        maxlen = 10))

# Print the association rules ----
# Threshold values of support = 0.01, confidence = 0.8, and
# maxlen = 10 results in a total of 14 rules when using the
# product name to identify the products.
summary(association_rules)
inspect(association_rules)
# To view the top 10 rules
inspect(association_rules[1:10])
plot(association_rules)

### Remove redundant rules ----
# We can remove the redundant rules as follows:
subset_rules <-
  which(colSums(is.subset(association_rules,
                          association_rules)) > 1)
length(subset_rules)
association_rules_no_reps <- association_rules[-subset_rules]

# This results in 6 non-redundant rules (instead of the initial 8 rules)
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

