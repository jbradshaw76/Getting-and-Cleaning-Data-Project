library("data.table")
library("reshape2")

# Load the activity labels
activity_labels <- read.table("activity_labels.txt")[,2]

# Load the features
features <- read.table("features.txt")[,2]

# Extract the mean and standard deviation features
extract_features <- grepl("mean|std", features)

# Load the test data
X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

names(X_test) = features

# Extract the mean and standard deviation from the test set
X_test = X_test[,extract_features]

# Apply the activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("activity_id", "activity_name")
names(subject_test) = "subject"

# Combine
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Load the training set
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")

subject_train <- read.table("train/subject_train.txt")

names(X_train) = features

# Extract the mean and standard deviation from the training set
X_train = X_train[,extract_features]

# Apply the activity labels
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("activity_id", "activity_name")
names(subject_train) = "subject"

# Combine
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge test and training sets
data = rbind(test_data, train_data)

id_labels   = c("subject", "activity_id", "activity_name")
data_labels = setdiff(colnames(data), id_labels)
melt_data   = melt(data, id = id_labels, measure.vars = data_labels)

# Compute the mean
tidy_data = dcast(melt_data, subject + activity_name ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")
