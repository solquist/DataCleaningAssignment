# Aggregation of Samsung Galaxy smartphone accelerometer data

## Introduction

This data set is a derivation of data from a study of 30 volunteers wearing a smartphone while performing various activities such as walking up stairs, laying down, and sitting.<sup>1</sup> More information about the study can be found at the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#).

This codebook explains the derived data found in "AverageValueBySubjectAndActivity.txt". At a high level, this data set is an aggregation of some of the measurements (explained in more detail in the Processed Data section) found in the raw data for each unique volunteer and activity combination. 

## Raw Data

The raw data for the above study was provided as a [zipped file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) as part of the Coursera [Getting and Cleaning Data](https://www.coursera.org/course/getdata) course. Much of the raw data is already processed data -- more can be learned in the file features_info.txt. The actual data is divided into a training set and test set of data. Following is a summary of the data available in the zipped file:

  * features_info.txt -- this is essentially a codebook for the data from the study. Some portions of this information are reproduced below.
  * README.txt -- overview of the study and files contained in the data set
  * activity_labels.txt -- mapping from an activity label factor (1 - 6) to a descriptive label (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
  * features.txt -- vector of 561 labels corresponding to the processed variables in the data set. This is the pool of variables we will draw our subset from.
  
  * train/subject_train.txt -- 7,352 subject ID's (unique volunteer ID) for the data in the training set.
  * train/X_train.txt -- 7,352 rows of 561 processed variables in the training set
  * train/Y_train.txt -- 7,352 activity factors for the training set
  * train/Inertial Signals/*.txt -- raw sensor data for the training set (not used for the processed data)
  
  * test/subject_test.txt -- 2,947 subject ID's (unique volunteer ID) for the data in the test set.
  * test/X_test.txt -- 2,947 rows of 561 processed variables in the test set
  * test/Y_test.txt -- 2,947 activity factors for the test set
  * test/Inertial Signals/*.txt -- raw sensor data for the test set (not used for the processed data)

Directly from the codebook for the raw data<sup>2</sup>, here is a description of the feature data:

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'

## Processed Data



## Bibliography

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

[2] From features.txt in zipped file https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip