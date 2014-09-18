# Cleaning the Samsung Galaxy smartphone accelerometer data

The source data were collected from Samsung Galazy smartphones and obtained indirectly through the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#) (data were provided in a zipped format as part of the Coursera Data Cleaning course). It contains information from a group of 30 volunteers performing various activities such as walking up stairs, laying down, sitting, and more.

The data cleaning was done through the script [run_analysis.R](https://github.com/solquist/DataCleaningAssignment). At a high level, the script performs the following required tasks from the data cleaning assignment:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

In addition to the data processing steps, the analysis script also takes care of reading in the data and saving out the final tidy data set as AverageValueBySubjectAndActivity.txt. The variables for the resulting data set are defined in [CodeBook.md](https://github.com/solquist/DataCleaningAssignment)

## Script Requirements

The package `reshape2` is required to run the script. It is used to perform the final reshaping step to create the tidy data set.

## Processing the data

### Reading in the data

It is assumed the required data already exists in the working directory and having the same directory structure obtained when unzipping the source (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). The script checks to see if the expected directories exist. If they don't, an error is thrown with a message indicating the directory that was expected.

The following files (with relative path included), needed to piece together the required data set, are read in using `read.table()`.

  * "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt" - vector of 561 feature labels for the raw sensor data blocks. Since this will be used to label the data, it is read in with the option `stringsAsFactors = FALSE`.

### Merging the training and test sets

Descriptions to come.

### Extracting only the mean and standard deviation for each measurement

Descriptions to come.

### Providing desriptive activity names

Descriptions to come.

### Creating descriptive variable names

Descriptions to come.

### Creating the final tidy data set

Descriptions to come.

### Saving the tidy data

Descriptions to come.
