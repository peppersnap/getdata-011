# This script assumes the dataset has already been downloaded and
# unzipped into the working directory:
#
# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
#               destfile="dataset.zip", mode="wb")
# unzip("dataset.zip")
require(reshape2)
require(plyr)

# read the feature labels (only the 2nd column, as we don't need the
# row number/ID)

features <- read.table("UCI HAR Dataset/features.txt",
                       col.names=c(NA, "Feature"),
                       colClasses=c(NA,"factor"))[,2]

# read the activity labels. We keep the ID here as we'll use it to merge
# with the feature records later
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",
                              col.names=c("Activity.ID", "Activity"),
                              colClasses=c("factor", "factor"))

###############################################################################

# get the test feature records
X_test <- read.table("UCI HAR Dataset/test/X_test.txt",
                     col.names=features)

# get activity identifiers for the test data
y_test <- read.table("UCI HAR Dataset/test/y_test.txt",
                     col.names=c("Activity.ID"))

# get subject identifiers for the test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",
                           col.names=c("Subject.ID"),
                           colClasses=c("integer"))

# Combine the activity IDs and subject IDs with the test data set
test.data <- cbind(y_test, X_test, subject_test)

###############################################################################

# get the training data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt",
                     col.names=features)

# get activity identifiers to the training data
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",
                     col.names=c("Activity.ID"))

# get subject identifiers for the test data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",
                           col.names=c("Subject.ID"),
                           colClasses=c("factor"))

# Combine the activity IDs and subject IDs with the training data set
train.data <- cbind(y_train, X_train, subject_train)

###############################################################################

# Combine test and training data into one dataset 
all.data <- rbind(test.data, train.data)

# Incorporate the Activity description into the test data set.
# Since both dataframes activity_labels and test.data have one column with
# the same name, Activity.ID, the merge function by default will join
# the tables based on this column.
all.data <- merge(activity_labels, all.data, all=TRUE)

# Tidy up the column names
# The pattern below looks for a period followed by either another period
# or the end of the column name, and replaces it with "" (i.e. removes it)
names(all.data) <- gsub(names(all.data), pattern="\\.(\\.|$)", replacement="")

# Extract only the measurements on the mean and standard deviation, i.e.
# that contain the word 'mean' or 'std'
# '\\b' represents a word boundary.
required.colnames <- names(all.data)[grepl("\\b(mean|std)\\b",
                                           names(all.data))]

# create a dataset of the means of the data, grouped by Activity and Subject
melted <- melt(all.data, id=c("Activity","Subject.ID"),
               measure.vars=required.colnames)
tidy <- dcast(melted, Activity + Subject.ID ~ variable, mean)

# sort the data by Activity and Subject
tidy <- arrange(tidy, Activity, as.integer(Subject.ID))

# output the data to CSV
write.table(tidy, "tidy.txt", row.names = FALSE)
