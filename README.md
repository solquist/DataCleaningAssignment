# Cleaning the Samsung Galaxy smartphone accelerometer data

The source data were collected from Samsung Galaxy smartphones and obtained indirectly through the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#) (data were provided in a zipped format as part of the Coursera Data Cleaning course). It contains information from a group of 30 volunteers performing various activities such as walking up stairs, laying down, sitting, and more.

The data cleaning was done through the script [run_analysis.R](https://github.com/solquist/DataCleaningAssignment/blob/master/run_analysis.R). At a high level, the script performs the following required tasks from the data cleaning assignment:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

In addition to the data processing steps, the analysis script also takes care of reading in the data and saving out the final tidy data set as AverageValueBySubjectAndActivity.txt. The variables for the resulting data set are defined in [CodeBook.md](https://github.com/solquist/DataCleaningAssignment/blob/master/CodeBook.md)

## Script Requirements

The package `reshape2` is required to run the script. It is used to perform the final reshaping step to create the tidy data set.

## Processing the data

### Reading in the data

It is assumed the required data already exists in the working directory and having the same directory structure obtained when unzipping the source to the working directory (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). The script checks to see if the expected directories exist. If they don't, an error is thrown with a message indicating the directory that was expected.

The following files (with relative path included), needed to piece together the required data set, are read in using `read.table()`.

#### General
  * "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt" - vector of 561 feature labels for the sensor data blocks. Since this will be used to label the data, it is read in with the option `stringsAsFactors = FALSE`. The results are assigned to the variable `feature.labels`.
  
#### Training data set
  * "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt" - vector of 7,352 subject ID's from the training set. Each of these represents an observation, or row, in the data set we are piecing together. The results are assigned to the variable `subject.train`.
  * "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt" - vector of 7,352 activity ID's that matches with the vector of subject ID's above. The results are assigned to the variable `activity.train`.
  * "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt" - table of sensor data from the training set. It has 561 columns and 7,352 rows. The results are assigned to the variable `dat.train`.
  
#### Test data set
  * "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt" - vector of 2,947 subject ID's from the test set. Each of these represents an observation, or row, in the data set we are piecing together. The results are assigned to the variable `subject.test`.
  * "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt" - vector of 2,947 activity ID's that matches with the vector of subject ID's above. The results are assigned to the variable `activity.test`.
  * "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_test.txt" - table of sensor data from the test set. It has 561 columns and 2947 rows. The results are assigned to the variable `dat.test`.

### Merging the training and test sets

Now that we have the pieces of data we need, putting them together is pretty straight forward. The training data set has a total of 7,352 obervations and the test data set has 2,947. When combining the two, we will have a total of 10,299 (7,352 + 2,947) observations. We also need to add a column for the subject ID's and the activity ID's. This will give us a total of 563 columns (561 for the sensor data variables and 2 more for the subject ID and activity ID).

we want to make sure the order of rows remains the same as we piece the blocks together so the right data is joined together. We use `cbind()` to paste the columns together. The data frame is built out from left to right by binding the activity column to the subject ID column and finally the data block to the previous result. We start with the subject ID and activity ID columns as those are our identifiers for an observation. This is first done for the training data set, building a data frame of the form:

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

For the mean and standard deviation columns, we keep the columns that are specifically named with the pattern "mean()" or "std()" in their title. We also need to make sure we keep the subject ID and activity ID columns. The function `grep("mean\\(\\)", column.names)` was used to get the indices of the columns that contain "mean()" and `grep("std\\(\\)", column.names)` to get the indices of the columns that contain "std()". These were combined, along with the indices 1 and 2 for the subject and activity ID columns, using the `c()` function.

`df` is then subset using this list of indices and assigned back to `df`. This results in keeping 66 data columns (68 total columns with the subject ID and activity ID).

Note: there are other forms of "mean" that show up in some of the labels, e.g. with "meanFreq()" and as part of the "angle()" label. I chose to use "mean()" and "std()" as that appeared to be the form where the calculation was directly applied to an existing measure. It also gives mean equal treatment as standard deviation as there were no other forms of standard deviation in the labels. The [guidance](https://class.coursera.org/getdata-007/forum/thread?thread_id=188) from the discussion list is to just make sure and document your choices.

### Providing desriptive activity names

The data set contains a set of descriptive activity names. As they are already good descriptive names, they are a good source for the labels. The activity labels exist in the file "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt". The labels are read in using the function `read.table()` with the option `stringAsFactors = FALSE` (these are turned to factors later) and saved into the variable `activity.labels`. The activity ID numbers in `df` are replaced with the labels from a lookup into `activity.labels` through the function `sapply()`.

Finally, the column `df$Activity` is turned into factors as the activity labels really are categorical values. Note, the `levels` options is not specified in the scsript, so the new factors will be ordered alphabetically. If it were necessary to easily get back to the original activity ID's, passing the option `levels = activity.labels$V2` would make it easy to keep the labels in the original order. However, since that is not needed to produce the final set of data and would introduce an extra step to re-order the data to make an "easier to read" alphabetical sorting, we chose to stick with the default alphabetical ordering of the factors.

### Creating descriptive variable names

For descriptive names, a nomenclature is defined to add some consistency to the naming. The choices in the ordering are in trying to represent the more general aspect of the variable to the more specific. This required re-ordering of the components rather than just a straight substitution. To do this I start with a reference of the column names to build a vector of selection indices and build up a new label according to the rules below. Also note some of the labels have the sub-string "BodyBody" in them. That appears to be a mistake in the coding of the variable (when you look at the patterns of the other variables) and so there is also a step to replace "BodyBody" with "Body" so it can be treated with the same logic as the others. Also note it is important that the step above has already been filtered to labels containing "mean()" or "std()" as the name parsing logic is built on that assumption.

The names are rebuilt using the following nomenclature:

  \<sensor type\>.\<acceleration type\>.\<component\>.\<domain\>.\<statistic\>

where these are the possible values

  * \<sensor type\>
    * Accelerometer -- measurement comes from an accelerometer
    * Gyroscope -- measurement comes from a gyroscope
  * \<acceleration type\>
    * Body -- acceleration component from the movement of the body
    * Gravity -- acceleration componenet due to gravity
    * Jerk -- calculated value incorporating linear body acceleration plus angular
  * \<component\>
    * X -- x-component of the measurement
    * Y -- y-component of the measurement
    * Z -- z-component of the measurement
    * Length -- length of the (x, y, z) measurement
  * \<domain\>
    * Time -- measurement is in the time domain
    * Freq -- measurement is in the frequency domain
  * \<statistic\>
    * Mean -- mean of the measurements
    * Std -- standard deviation of the measurements
    
For example, the name "tBodyAcc-mean()-X" would become "Accelerometer.Body.X.Time.Mean". "Length" made most sense to include along with "X", "Y", and "Z", as they essentially describe which geometric aspect of the vector the variable describes."Jerk" was included as an acceleration type (rather than an optional identifier) as it is combining information from the linear acceleration along with angular information to get a new measure. It was verified that "Jerk" and "Body" always occur together to make sure no information was lost. To keep the "Jerk" logic as simple as possible, the script goes through the normal "Body" logic first and then just replaces "Body." with "Jerk." in this case. This keeps the nomenclature consistent by not adding an additional label for "Jerk".

The following utility function was defined in the script to encapsulate the same step that needed to be done over and over. It essentially looks for columns that contain the string of interest and builds up the new strings by appending the appropriate piece of the nomenclature defined above on equivalent rows.

```
## Utility function to parse out a portion of the original string and append the
## new label. This function assumes the new labels go in 'column.names.new' and
## the originals come from 'column.names'
ParseAndAppendLabel <- function(find.str, append.str)
{
  indices <- grep(find.str, column.names)
  column.names.new[indices] <<- paste(column.names.new[indices], append.str, sep = "")
}
```

### Creating the final tidy data set

Using the `reshape` package, the reshaped version of the data was pretty straight forward. We essentially want to have one row for each unique `Subjet.ID` and `Activity` combination, aggregating multiple measurements using the average (the `mean()` function).

In order to indicate which columns are to be used as our identifiers, we use the `melt()` function on `df` with the option `id = c("Subject.ID", "Activity")`. This creates a data frame with the right meta-data for the identifier columns and "melts" all of the sensor measurements into `variable` and `value` pairs so that we can leverage other reshaping functions within the package. The results are assigned to the variable `df.melt`.

The final reshape is done using the function `dcast()`. The data frame we want to create is showing `Subject.ID` and `Activity` by `variable` and aggregating the data using the `mean()` function. This is assigned to the variable `df.reshape` and the operation is performed simply by the following:

```
df.reshape <- dcast(df.melt, Subject.ID + Activity ~ variable, mean)

```

### Saving the tidy data

The data frame created in the step above, `df.reshape` is saved to the current working directory with a file name of "AverageValueBySubjectAndActivity.txt" using the `write.table()` function. As we do not want row labels, the option `row.names = FALSE` is used.
