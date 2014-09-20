# Aggregation of Samsung Galaxy smartphone accelerometer data

## Introduction

This data set is a derivation of data from a study of 30 volunteers wearing a smartphone while performing various activities such as walking up stairs, laying down, and sitting.<sup>1</sup> More information about the study can be found at the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#).

This codebook explains the derived data found in "AverageValueBySubjectAndActivity.txt". At a high level, this data set is an aggregation of some of the measurements (explained in more detail in the Processed Data section) found in the raw data for each unique volunteer and activity combination. 

## Raw Data

The raw data for the above study was provided as a [zipped file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) as part of the Coursera [Getting and Cleaning Data](https://www.coursera.org/course/getdata) course. Much of the raw data is already processed data -- more can be learned in the file features_info.txt. The actual data is divided into a training set and test set of data. Following is a summary of the data available in the zipped file:

### General

  * features_info.txt -- this is essentially a codebook for the data from the study. Some portions of this information are reproduced below.
  * README.txt -- overview of the study and files contained in the data set
  * activity_labels.txt -- mapping from an activity label factor (1 - 6) to a descriptive label (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
  * features.txt -- vector of 561 labels corresponding to the processed variables in the data set. This is the pool of variables we will draw our subset from.

### Training set

  * train/subject_train.txt -- 7,352 subject ID's (unique volunteer ID) for the data in the training set. Values are integers in the range of 1 to 30.
  * train/X_train.txt -- 7,352 rows of 561 processed variables in the training set. Values are normalized to the range [-1, 1].
  * train/Y_train.txt -- 7,352 activity factors for the training set. Values are integers in the range of 1 to 6.
  * train/Inertial Signals/\*.txt -- raw sensor data for the training set (not used for the processed data)

### Test set

  * test/subject_test.txt -- 2,947 subject ID's (unique volunteer ID) for the data in the test set. Values are integers in the range of 1 to 30.
  * test/X_test.txt -- 2,947 rows of 561 processed variables in the test set. Values are normalized to the range [-1, 1].
  * test/Y_test.txt -- 2,947 activity factors for the test set. Values are integers in the range of 1 to 6.
  * test/Inertial Signals/\*.txt -- raw sensor data for the test set (not used for the processed data)

### Feature definitions in original data

Directly from the codebook for the raw data<sup>2</sup>, here is a description of the feature data:

"The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

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

The complete list of variables of each feature vector is available in 'features.txt'"

## Processed Data

For details on how the processing was done, please refer to the [Readme](https://github.com/solquist/DataCleaningAssignment/blob/master/README.md) for the processing script.

Following are some general processing notes:

  * The raw sensor data is not used in processing the data. So, the files "train/Inertial Signals/\*.txt" and "test/Inertial Signals/\*.txt" are not used.
  * The training data set and the test data set are combined into one data set, producing 10,299 rows of data (7,352 + 2,947)
  * Only the features having labels that contain "mean()" or "std()" are kept, reducing the number of features from 561 down to 66 (covered in more detail below). There are other forms of "mean" that show up in some of the labels, e.g. with "meanFreq()" and as part of the "angle()" label. Those with "mean()" and "std()" were chosen as that appeared to be the form where the calculation was directly applied to an existing measure. It also gives mean equal treatment as standard deviation as there were no other forms of standard deviation in the labels. The [guidance](https://class.coursera.org/getdata-007/forum/thread?thread_id=188) from the discussion list is to just make sure and document your choices.
  
The data set is first sorted by Subject.ID followed by Activity and only has one row of data for each unique combination of Subject.ID and Activity. As there are 30 volunteers and 6 activities, this data set has 180 rows of data. Mean is the aggregation used to combine all instances of a given Subject.ID and Activity.
  
### Variables

#### Subject.ID (column 1)

Integer ID that uniquely represents a volunteer. The value ranges from 1 to 30 and does not have units. The only transformation from the original data set is the combination of the training data and test data into one.

#### Activity (column 2)

Categorical variable indicating the activity that was performed. Valid values come from the set (LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS). The raw data set represents the activity with an integer factor ranging from 1 to 6. The descriptive labels in activity_labels.txt were used to replace the integer factor.

#### \<sensor type\>.\<acceleration type\>.\<component\>.\<domain\>.\<statistic\> (columns 3 - 68)

The feature variables are first described in a more general fashion. The full 66 feature names are also included below for completeness.

This variable is a floating point value that is the average of all measures of this type for a given Subject.ID and Activity in the original data set (it is an aggregation using mean). Since the original data was limited to already calculated means or standard deviations, these values will either be a mean of a mean or a mean of a standard deviation. Also, since the original feature values were normalized to the range of [-1, 1] and were unitless (since they were normalized), these variables also lie in the range [-1, 1] and are unitless.

The encoding for the variable names is as follows. Note this encoding was based on the original names but structured to provide a more consistent nomenclature.

  * \<sensor type\>
    * Accelerometer -- measurement comes from an accelerometer (Acc in the original)
    * Gyroscope -- measurement comes from a gyroscope (Gyro in the original)
  * \<acceleration type\>
    * Body -- acceleration component from the movement of the body (Body in the original)
    * Gravity -- acceleration componenet due to gravity (Gravity in the original)
    * Jerk -- calculated value incorporating linear body acceleration plus angular (Jerk in the original)
  * \<component\>
    * X -- x-component of the measurement (X in the original)
    * Y -- y-component of the measurement (Y in the original)
    * Z -- z-component of the measurement (Z in the original)
    * Length -- length of the (x, y, z) measurement (Mag in the original)
  * \<domain\>
    * Time -- measurement is in the time domain (t in the original)
    * Freq -- measurement is in the frequency domain (f in the original)
  * \<statistic\>
    * Mean -- mean of the measurements (mean() in the original)
    * Std -- standard deviation of the measurements (std() in the original)
    
For example, the name "tBodyAcc-mean()-X" from the original data set would become "Accelerometer.Body.X.Time.Mean". "Length" made most sense to include along with "X", "Y", and "Z", as they essentially describe which geometric aspect of the vector the variable describes."Jerk" was included as an acceleration type (rather than an optional identifier) as it is combining information from the linear acceleration along with angular information to get a new measure. It was verified that "Jerk" and "Body" always occur together to make sure no information was lost. This keeps the nomenclature consistent by not adding an additional label for "Jerk".

One other transformation to mention is that some variables had an incorrect "BodyBody" in the original dat set. This was treated as just "Body" for the creation of this aggregated data set.

Following is the full list of feature variable names and column numbers:

| Feature Variable name                  | Column |
|:---------------------------------------|:------:|
| Accelerometer.Body.X.Time.Mean         |  3     |
| Accelerometer.Body.Y.Time.Mean         |  4     |
| Accelerometer.Body.Z.Time.Mean         |  5     |
| Accelerometer.Gravity.X.Time.Mean      |  6     |
| Accelerometer.Gravity.Y.Time.Mean      |  7     |
| Accelerometer.Gravity.Z.Time.Mean      |  8     |
| Accelerometer.Jerk.X.Time.Mean         |  9     |
| Accelerometer.Jerk.Y.Time.Mean         | 10     |
| Accelerometer.Jerk.Z.Time.Mean         | 11     |
| Gyroscope.Body.X.Time.Mean             | 12     |
| Gyroscope.Body.Y.Time.Mean             | 13     |
| Gyroscope.Body.Z.Time.Mean             | 14     |
| Gyroscope.Jerk.X.Time.Mean             | 15     |
| Gyroscope.Jerk.Y.Time.Mean             | 16     |
| Gyroscope.Jerk.Z.Time.Mean             | 17     |
| Accelerometer.Body.Length.Time.Mean    | 18     |
| Accelerometer.Gravity.Length.Time.Mean | 19     |
| Accelerometer.Jerk.Length.Time.Mean    | 20     |
| Gyroscope.Body.Length.Time.Mean        | 21     |
| Gyroscope.Jerk.Length.Time.Mean        | 22     |
| Accelerometer.Body.X.Freq.Mean         | 23     |
| Accelerometer.Body.Y.Freq.Mean         | 24     |
| Accelerometer.Body.Z.Freq.Mean         | 25     |
| Accelerometer.Jerk.X.Freq.Mean         | 26     |
| Accelerometer.Jerk.Y.Freq.Mean         | 27     |
| Accelerometer.Jerk.Z.Freq.Mean         | 28     |
| Gyroscope.Body.X.Freq.Mean             | 29     |
| Gyroscope.Body.Y.Freq.Mean             | 30     |
| Gyroscope.Body.Z.Freq.Mean             | 31     |
| Accelerometer.Body.Length.Freq.Mean    | 32     |
| Accelerometer.Jerk.Length.Freq.Mean    | 33     |
| Gyroscope.Body.Length.Freq.Mean        | 34     |
| Gyroscope.Jerk.Length.Freq.Mean        | 35     |
| Accelerometer.Body.X.Time.Std          | 36     |
| Accelerometer.Body.Y.Time.Std          | 37     |
| Accelerometer.Body.Z.Time.Std          | 38     |
| Accelerometer.Gravity.X.Time.Std       | 39     |
| Accelerometer.Gravity.Y.Time.Std       | 40     |
| Accelerometer.Gravity.Z.Time.Std       | 41     |
| Accelerometer.Jerk.X.Time.Std          | 42     |
| Accelerometer.Jerk.Y.Time.Std          | 43     |
| Accelerometer.Jerk.Z.Time.Std          | 44     |
| Gyroscope.Body.X.Time.Std              | 45     |
| Gyroscope.Body.Y.Time.Std              | 46     |
| Gyroscope.Body.Z.Time.Std              | 47     |
| Gyroscope.Jerk.X.Time.Std              | 48     |
| Gyroscope.Jerk.Y.Time.Std              | 49     |
| Gyroscope.Jerk.Z.Time.Std              | 50     |
| Accelerometer.Body.Length.Time.Std     | 51     |
| Accelerometer.Gravity.Length.Time.Std  | 52     |
| Accelerometer.Jerk.Length.Time.Std     | 53     |
| Gyroscope.Body.Length.Time.Std         | 54     |
| Gyroscope.Jerk.Length.Time.Std         | 55     |
| Accelerometer.Body.X.Freq.Std          | 56     |
| Accelerometer.Body.Y.Freq.Std          | 57     |
| Accelerometer.Body.Z.Freq.Std          | 58     |
| Accelerometer.Jerk.X.Freq.Std          | 59     |
| Accelerometer.Jerk.Y.Freq.Std          | 60     |
| Accelerometer.Jerk.Z.Freq.Std          | 61     |
| Gyroscope.Body.X.Freq.Std              | 62     |
| Gyroscope.Body.Y.Freq.Std              | 63     |
| Gyroscope.Body.Z.Freq.Std              | 64     |
| Accelerometer.Body.Length.Freq.Std     | 65     |
| Accelerometer.Jerk.Length.Freq.Std     | 66     |
| Gyroscope.Body.Length.Freq.Std         | 67     |
| Gyroscope.Jerk.Length.Freq.Std         | 68     |

## Bibliography

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

[2] From features.txt in zipped file https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip