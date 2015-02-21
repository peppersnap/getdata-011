# getdata-011
## Coursework for Coursera class getdata-011: Getting and Cleaning Data

The purpose of this project is to merge, process and output the Human Activity Recognition Using Smartphones Data Set is from the Univercity of California, Irvine's Machine Learning Repository (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

This repo contains:
* README.md - this README file.
* CODEBOOK.md - a description of the variables, the data and the clean-up process.
* run_analysis.R - The script to process the UCI HAR dataset and output it 
in a tidy format to tidy.txt.  

The script run_analysis.R requires that requires that the Samsung data set is extracted to the working directory.  It works as follows:

1. Loads all relevant data into data tables:
  * UCI HAR Dataset/features.txt: the lists of features being recorded
  * UCI HAR Dataset/activity_labels.txt: the list of activites recorded
  * UCI HAR Dataset/test/X_test.txt: the measurements for the test data set
  * UCI HAR Dataset/test/y_test.txt: the activity identifiers for the test data set
  * UCI HAR Dataset/test/subject_test.txt: the subject identifiers for the test data set
  * UCI HAR Dataset/train/X_train.txt: the measurements for the training data set
  * UCI HAR Dataset/train/y_train.txt: the activity identifiers for the training data set
  * UCI HAR Dataset/train/subject_train.txt: the subject identifiers for the training data set
2. Merges the activity identifier and subject data with the test and training data sets.
3. Combines the test and training data sets together.
4. Merges the activity names into the data set.
5. Cleans up the column names (based on the names given in the features.txt file)
6. Selects only the mean and standard deviation measurements
7. Creates a dataset of the means of this data, grouped by Activity and Subject ID.
8. Sorts the data by Activity and Subject.
9. Writes the data table to the file tidy.txt