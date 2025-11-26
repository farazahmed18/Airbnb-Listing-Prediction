airbnb_data = read.csv("listings.csv", stringsAsFactors = FALSE)
listings <- read.csv("~/Downloads/listings.csv", header=FALSE, comment.char="#")
View(listings)
airbnb_data = read.csv("listings.csv", stringsAsFactors = FALSE)
listings <- read.csv("~/Downloads/listings.csv", header = TRUE, stringsAsFactors = FALSE)
names(listings)
listings$price_clean = as.numeric(gsub("[\\$,]", "", listings$price))
listings$reviews_per_month[is.na(listings$reviews_per_month)] = 0
listings$estimated_revenue = listings$price_clean * listings$reviews_per_month
revenue_threshold = median(listings$estimated_revenue, na.rm = TRUE)
listings$success = ifelse(listings$estimated_revenue > revenue_threshold, "Good", "Bad")
listings$success = as.factor(listings$success)
table(listings$success)
# Data Preprocessing & Cleaning
cols_to_keep <- c("success",
"price_clean",
"neighbourhood_cleansed",
"room_type",
"property_type",
"accommodates",
"bedrooms",
"beds",
"number_of_reviews",
"review_scores_rating")
model_data = listings[, cols_to_keep]
model_data$neighbourhood_cleansed <- as.factor(model_data$neighbourhood_cleansed)
model_data$room_type <- as.factor(model_data$room_type)
model_data$property_type <- as.factor(model_data$property_type)
# Handle Missing Values
model_data = na.omit(model_data)
str(model_data)
#  Hypotheses Visualization
# Visualizing Hypothesis 1: Room Type vs Success
counts = table(model_data$success, model_data$room_type)
barplot(counts, main="Success Distribution by Room Type",
xlab="Room Type", col=c("red","green"),
legend = rownames(counts), beside=TRUE)
# Visualizing Hypothesis 2: Review Scores vs Success
boxplot(review_scores_rating ~ success, data = model_data,
main = "Review Ratings by Success Category",
xlab = "Success Class", ylab = "Review Rating",
col = c("salmon", "lightgreen"))
# Visualizing Hypothesis 3: Capacity vs Success
boxplot(accommodates ~ success, data = model_data,
main = "Accommodation Capacity by Success Category",
xlab = "Success Class", ylab = "People Accommodated",
col = c("salmon", "lightgreen"))
# Model Training and Evaluation
# 1. Split the data into Training (70%) and Testing (30%)
set.seed(123)
index = sample(c(TRUE, FALSE), nrow(model_data), replace=TRUE, prob=c(0.7, 0.3))
train_set = model_data[index, ]
test_set  = model_data[!index, ]
# 2. Train the Logistic Regression Model
logit_model = glm(success ~ ., data = train_set, family = "binomial")
# 3. Make Predictions on the Test Set
predictions_prob = predict(logit_model, newdata = test_set, type = "response")
> # Model Training and Evaluation
# Model Training and Evaluation
# 1. Select ONLY valid predictors
final_data <- model_data[, c("success", "neighbourhood_cleansed", "room_type",
"accommodates", "bedrooms", "beds", "review_scores_rating")]
# 2. Split the data into Training (70%) and Testing (30%)
set.seed(123)
index = sample(c(TRUE, FALSE), nrow(final_data), replace=TRUE, prob=c(0.7, 0.3))
train_set = final_data[index, ]
test_set  = final_data[!index, ]
# 3. Train the Logistic Regression Model
logit_model = glm(success ~ ., data = train_set, family = "binomial")
# 4. Make Predictions on the Test Set
predictions_prob = predict(logit_model, newdata = test_set, type = "response")
# 5. Convert Probabilities to Classes
predictions_class = ifelse(predictions_prob > 0.5, "Good", "Bad")
# 6. Evaluate Accuracy
conf_matrix = table(Predicted = predictions_class, Actual = test_set$success)
print(conf_matrix)
accuracy = sum(diag(conf_matrix)) / sum(conf_matrix)
print(paste("Model Accuracy:", round(accuracy * 100, 2), "%"))
# Advanced High Accuracy Version
# 1: Feature Engineering
# A. Create "Amenities Count"
listings$amenities_count = lengths(strsplit(listings$amenities, ","))
# B. Fix Property Type (Preventing the crash)
top_props = names(sort(table(listings$property_type), decreasing=TRUE)[1:5])
listings$property_simple = ifelse(listings$property_type %in% top_props, listings$property_type, "Other")
listings$property_simple = as.factor(listings$property_simple)
# C. Handle Missing Ratings
avg_rating = mean(listings$review_scores_rating, na.rm = TRUE)
listings$review_scores_rating[is.na(listings$review_scores_rating)] = avg_rating
# 2: Select the Best Variables
advanced_data <- listings[, c("success", "neighbourhood_cleansed", "property_simple",
"room_type", "accommodates", "beds",
"review_scores_rating", "amenities_count")]
advanced_data <- na.omit(advanced_data)
# 3: Train and Test (70/30 Split)
set.seed(123)
index = sample(c(TRUE, FALSE), nrow(advanced_data), replace=TRUE, prob=c(0.7, 0.3))
train_set = advanced_data[index, ]
test_set  = advanced_data[!index, ]
# Train the Logistic Regression Model
logit_model = glm(success ~ ., data = train_set, family = "binomial")
# 4: Evaluate
predictions_prob = predict(logit_model, newdata = test_set, type = "response")
predictions_class = ifelse(predictions_prob > 0.5, "Good", "Bad")
# Confusion Matrix
conf_matrix = table(Predicted = predictions_class, Actual = test_set$success)
print(conf_matrix)
# Calculate New Accuracy
accuracy = sum(diag(conf_matrix)) / sum(conf_matrix)
print(paste("New Model Accuracy:", round(accuracy * 100, 2), "%"))
#  Decision Tree Approach]
library(rpart)
# 1. Train a Decision Tree Model
tree_model = rpart(success ~ ., data = train_set, method = "class", cp = 0.001)
tree_preds = predict(tree_model, newdata = test_set, type = "class")
conf_matrix_tree = table(Predicted = tree_preds, Actual = test_set$success)
print(conf_matrix_tree)
accuracy_tree = sum(diag(conf_matrix_tree)) / sum(conf_matrix_tree)
print(paste("Decision Tree Accuracy:", round(accuracy_tree * 100, 2), "%"))
# Detailed Model Interpretation
# 1. Variable Importance
print("--- Variable Importance (Ranked) ---")
print("--- Variable Importance (Ranked) ---")
print(tree_model$variable.importance)
# 2. Examining the Decision Rules
print("--- Decision Tree Logic ---")
print(tree_model)
# 3. Visualizing the Tree
plot(tree_model, uniform=TRUE, main="Decision Tree for Airbnb Success")
text(tree_model, use.n=TRUE, all=TRUE, cex=.7)