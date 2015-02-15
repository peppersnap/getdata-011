require(dplyr)
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
#              destfile="dataset.zip", mode="wb")
#unzip("dataset.zip")

features <- read.table("UCI HAR Dataset/features.txt",
                       col.names=c("Feature.ID", "Feature"),
                       colClasses=c("factor","factor"))

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",
                              col.names=c("Activity.ID", "Activity"),
                              colClasses=c("factor", "factor"))

# get the test data
X_test <- read.table("UCI HAR Dataset/test/X_test.txt",
                     col.names=features$Feature)

#label this data as "test"
test.data <- cbind(c("test"),X_test)
names(test.data)[1] <- "dataset"

# get activity identifiers for the test data
y_test <- read.table("UCI HAR Dataset/test/y_test.txt",
                     col.names=c("Activity.ID"))

# get subject identifiers for the test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",
                           col.names=c("Subject.ID"),
                           colClasses=c("factor"))
g
# Combine the activity IDs and subject IDs with the test data set
test.data <- cbind(y_test, X_test, subject_test)

# get the training data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt",
                     col.names=features$Feature)

#label this data as "train"
train.data <- cbind(c("train"),X_test)
names(train.data)[1] <- "dataset"

# get activity identifiers to the training data
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",
                     col.names=c("Activity.ID"))

# get subject identifiers for the test data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",
                           col.names=c("Subject.ID"),
                           colClasses=c("factor"))

# Combine the activity IDs and subject IDs with the training data set
train.data <- cbind(y_train, X_train, subject_train)

# Combine test and training data into one dataset 
all.data <- rbind(test.data, train.data)

# Incorporate the Activity description into the test data set.
# Since both dataframes activity_labels and test.data have one column with
# the same name, Activity.ID, the merge function by default will join
# the tables based on this column.
all.data <- merge(activity_labels, all.data)

# Extract only the measurements on the mean and standard deviation.
# 1) get the names of columns that contain means,
# i.e. the name contains '.mean'
mean.colnames <- names(all.data)[grep(".mean",names(all.data))]

# 2) get the names of columns that contain standard deviations,
# i.e. the name contains '.std'
std.colnames <- names(all.data)[grep(".std",names(all.data))]

# 3) Combine these, and include the subject ID and activity column names
required.colnames <- c(mean.colnames, std.colnames)

# Take a subset of the all.data dataframe including only the previously
# specified columns
factor.colnames <- c("Activity", "Subject.ID")

subset.data <- all.data[,c(factor.colnames, required.colnames)]

mean.data <- by(subset.data[,required.colnames],subset.data[,factor.colnames],
                colMeans)

