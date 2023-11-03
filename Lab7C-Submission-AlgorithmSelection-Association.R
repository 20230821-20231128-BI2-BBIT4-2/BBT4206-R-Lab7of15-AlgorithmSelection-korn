# Install and Load the Required Packages ----
renv::restore()

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
# We will use the Groceries dataset for Market Basket Analysis available on Kaggle
# here: https://www.kaggle.com/datasets/heeraldedhia/groceries-dataset/data

# Abstract:
# The dataset has 38765 rows of the purchase orders of people from the grocery stores. These orders can be analysed and association rules can be generated using Market Basket Analysis by algorithms like Apriori Algorithm.

### Step One: Loading the Dataset

# We can read data from the Excel spreadsheet as follows:
mba2 <- read.csv(file = "data/mba2.csv")
dim(mba2)

# We have 38,765 observations and 3 variables

#Step Two: Handling missing values and Data Transformation
# Are there missing values in the dataset?
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


#Step Three: Basic EDA ----
## Create an item frequency plot for the top 10 items
itemFrequencyPlot(transactions, topN = 10, type = "absolute",
                  col = brewer.pal(8, "Pastel2"),
                  main = "Absolute Item Frequency Plot",
                  horiz = TRUE,
                  mai = c(2, 2, 2, 2))

association_rules <- apriori(transactions, 
                             parameter = list(supp = 0.005, conf = 0.8, maxlen = 10))




# Print the association rules ----
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

