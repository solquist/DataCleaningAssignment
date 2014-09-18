##
## This script reads a set of accelerometer data and processes it to meet the following
## conditions:
##
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set.
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the
##    average of each variable for each activity and each subject.
##
## The resulting data is saved in the file 'AverageValueBySubjectAndActivity.txt'
##

##
## Reading the data we need
##

root.path <- ".\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset"
test.path <- paste(root.path, "\\test", sep = "")
train.path <- paste(root.path, "\\train", sep = "")

# Check to see if the expected locations exist first and throw an error if not
if (!file.exists(root.path)) {
  stop(paste("Expected to find data at", root.path))
}

if (!file.exists(test.path)) {
  stop(paste("Expected to find data at", test.path))
}

if (!file.exists(train.path)) {
  stop(paste("Expected to find data at", train.path))
}

# feature labels (column labels for dat.test and dat.train)
file.name <- paste(root.path, "\\features.txt", sep = "")
feature.labels <- read.table(file.name, stringsAsFactors = FALSE)

# train subjects
file.name <- paste(train.path, "\\subject_train.txt", sep = "")
subject.train <- read.table(file.name)

# train activities
file.name <- paste(train.path, "\\Y_train.txt", sep = "")
activity.train <- read.table(file.name)

# train data set
file.name <- paste(train.path, "\\X_train.txt", sep = "")
dat.train <- read.table(file.name)

# test subjects
file.name <- paste(test.path, "\\subject_test.txt", sep = "")
subject.test <- read.table(file.name)

# test activities
file.name <- paste(test.path, "\\Y_test.txt", sep = "")
activity.test <- read.table(file.name)

# test data set
file.name <- paste(test.path, "\\X_test.txt", sep = "")
dat.test <- read.table(file.name)

##
## Build the combined data set. We will make it more readable in a later step.
##
## 1. Merges the training and the test sets to create one data set.
##

# Put together the ID and activity as columns, add the data columns,
# and finally add column names
df.train <- cbind(subject.train, activity.train)
df.train <- cbind(df.train, dat.train)

df.test <- cbind(subject.test, activity.test)
df.test <- cbind(df.test, dat.test)

df <- rbind(df.train, df.test)
column.names <- c("Subject.ID", "Activity", feature.labels$V2)
names(df) <- column.names

# Do some memory cleanup
rm(feature.labels, subject.train, activity.train, dat.train,
   subject.test, activity.test, dat.test, df.train, df.test)

##
## Remove the data columns which do not contain mean() or std() measurements.
##
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
##

# Calculate column ids containing mean() or std() -- need to also keep the subject ID and
# activity columns
keep.columns <- c(1, 2, grep("mean\\(\\)", column.names), grep("std\\(\\)", column.names))
df <- df[, keep.columns]

##
## Map the activity ID's to more readable labels. This mapping already exists in
## the file 'activity_labels.txt'
##
## 3. Uses descriptive activity names to name the activities in the data set.
##

file.name <- paste(root.path, "\\activity_labels.txt", sep = "")
activity.labels <- read.table(file.name, stringsAsFactors = FALSE)

# Use the activity label mapping to turn the activity ID into a label
df$Activity <- sapply(df$Activity, function(x) activity.labels[x, 2])
df$Activity <- factor(df$Activity)

##
## Provide more descriptive variable names
##
## 4. Appropriately labels the data set with descriptive variable names.
##
## General pattern for the label
##   <sensor type>.<acceleration type>.<component>.<domain>.<statistic>
##
## where
##   <sensor type>
##     Accelerometer - measurement comes from an accelerometer
##     Gyroscope - measurement comes from a gyroscope
##   <acceleration type>
##     Body - acceleration component from the movement of the body
##     Gravity - acceleration componenet due to gravity
##     Jerk - calculated value incorporating linear body acceleration plus angular
##   <component>
##     X - x-component of the measurement
##     Y - y-component of the measurement
##     Z - z-component of the measurement
##     Length - length of the (x, y, z) measurement
##   <domain>
##     Time - measurement is in the time domain
##     Freq - measurement is in the frequency domain
##   <statistic>
##     Mean - mean of the measurements
##     Std - standard deviation of the measurements
##
## Note: this nomenclature also requires a re-ordering of name components, so we
## rebuild the new titles rather than just substitute
##

column.names <- names(df)
column.names.new <- rep("", length(column.names))
column.names.new[1:2] <- column.names[1:2]

## Utility function to parse out a portion of the original string and append the
## new label. This function assumes the new labels go in 'column.names.new' and
## the originals come from 'column.names'
ParseAndAppendLabel <- function(find.str, append.str)
{
  indices <- grep(find.str, column.names)
  column.names.new[indices] <<- paste(column.names.new[indices], append.str, sep = "")
}

## sensor type
ParseAndAppendLabel("Acc", "Accelerometer.")
ParseAndAppendLabel("Gyro", "Gyroscope.")

## acceleration type (handle "jerk" differently as it also has Body in the label)
ParseAndAppendLabel("Body", "Body.")
ParseAndAppendLabel("Gravity", "Gravity.")
indices <- grep("Jerk", column.names)
column.names.new[indices] <- sub("Body\\.", "Jerk.", column.names.new[indices])

## component
ParseAndAppendLabel("-X", "X.")
ParseAndAppendLabel("-Y", "Y.")
ParseAndAppendLabel("-Z", "Z.")
ParseAndAppendLabel("Mag", "Length.")

## domain
ParseAndAppendLabel("^t", "Time.")
ParseAndAppendLabel("^f", "Freq.")

## statistic
ParseAndAppendLabel("mean\\(\\)", "Mean")
ParseAndAppendLabel("std\\(\\)", "Std")

## Apply these labels back to the data set
names(df) <- column.names.new

##
## Reshape the data to show average values per subject and activity
##
## 5. From the data set in step 4, creates a second, independent tidy data set with the
##    average of each variable for each activity and each subject.
##
## Note: this step is going to leverage the reshape2 library
##

library(reshape2)

# Melt the data and reshape using the reshape2 package
df.melt <- melt(df, id = c("Subject.ID", "Activity"))
df.reshape <- dcast(df.melt, Subject.ID + Activity ~ variable, mean)

##
## Finally, save out the tidy data set using 'write.table()' with 'row.names = FALSE'
##

write.table(df.reshape, file = "AverageValueBySubjectAndActivity.txt", row.names = FALSE)
