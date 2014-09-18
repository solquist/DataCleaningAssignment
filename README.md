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

#### General
  * "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt" - vector of 561 feature labels for the sensor data blocks. Since this will be used to label the data, it is read in with the option `stringsAsFactors = FALSE`. The results are assigned to the variable `feature.lables`.
  
#### Training data set
  * "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt" - vector of 7,352 subject ID's from the training set. Each of these represents an observation, or row, in the data set we are piecing together. The results are assigned to the variable `subject.train`.
  * "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt" - vector of 7,352 activity ID's that matches with the vector of subject ID's above. The results are assigned to the variable `activity.train`.
  * "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt" - table of sensor data from the training set. It has 561 columns and 7,352 rows. The results are assigned to the variable `dat.train`.
  
#### Test data set
  * "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt" - vector of 2,947 subject ID's from the test set. Each of these represents an observation, or row, in the data set we are piecing together. The results are assigned to the variable `subject.test`.
  * "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt" - vector of 2,947 activity ID's that matches with the vector of subject ID's above. The results are assigned to the variable `activity.test`.
  * "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_test.txt" - table of sensor data from the test set. It has 561 columns and 2947 rows. The results are assigned to the variable `dat.test`.

### Merging the training and test sets

Now that we have the pieces of data we need, putting them together is pretty straight forward. The training data set has a total of 7,352 obervations and the test data set has 2,947. When combining the two, we will have a total of 10,299 (7,352 + 2,947) observations. We also need to add a column for the subject ID's and the activity ID's. This will give us a total of 563 columns (561 for the sensor data variables anad 2 more for the subject ID an activity ID).

To avoid any problems with order, we just use `cbind()` to paste the columns together. The data frame is built out from left to right by binding the activity column to the subject ID column and finally the data block to the previous result. This is first done for the training data set, building a data frame of the form:

| Subject.ID                 | Activity                    | Data block (561 variables)         |
|:---------------------------|:----------------------------|:-----------------------------------|
| 7,352 rows of subject ID's | 7,352 rows of activity ID's | 7,352 rows of 561 sensor variables |

Going through the same process for the test data, we get a data frame of the form:

| Subject.ID                 | Activity                    | Data block (561 variables)         |
|:---------------------------|:----------------------------|:-----------------------------------|
| 2,947 rows of subject ID's | 2,947 rows of activity ID's | 2,947 rows of 561 sensor variables |

We then use `rbind()` to append the test data frame to the training data frame to end up with a final data frame `df` of the form:

| Subject.ID                 | Activity                    | Data block (561 variables)         |
|:---------------------------|:----------------------------|:-----------------------------------|
| 10,299 rows of subject ID's | 10,299 rows of activity ID's | 10,299 rows of 561 sensor variables |

Finally, the name of the first column is set to "Subject.ID", the second to "Activity", and the remaining 561 are set to the feature labels (`feature.labels`) we read in above. The temporary data frames we used to build up `df` and the pieces we read in are cleaned up using `rm()` as we no longer need these pieces.

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
