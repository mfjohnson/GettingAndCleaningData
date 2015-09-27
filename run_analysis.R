# Project file
# Author: Mark Johnson
#
# Specify libraries required to tiddy up the data set
setwd("~/R_Coursera_Course/gettingAndCleaning/UCI HAR Dataset")

library(plyr)

# Step 0: Load the UCI HAR Dataset files and specify the column names and column types
X_test <- read.table("test/X_test.txt")
Y_test <-
  read.table(
    "test/y_test.txt", colClasses = c("factor"), col.names = c("activityId")
  )
X_train <- read.table("train/X_train.txt")
Y_train <-
  read.table(
    "train/y_train.txt", colClasses = c("factor"), col.names = c("activityId")
  )
subject_Test <-
  read.table(
    "test/subject_test.txt", colClasses = c("factor"), col.names = c("subjectId")
  )
subject_Train <-
  read.table(
    "train/subject_train.txt", colClasses = c("factor"), col.names = c("subjectId")
  )

# Make certain the test and training data is identifiable post-merge step to support audit operations
X_train$DataType <- "TRAIN"
X_test$DataType <- "TEST"

# Load the support data frames (features, subject_test and activity Labels)
features <-
  read.table(
    "features.txt", colClasses = c("numeric","factor"), col.names = c("colId","featureLabel")
  )
activity_labels <-
  read.table(
    "activity_labels.txt", colClasses = c("numeric","factor"), col.names = c("activityId","activityLabel")
  )


# Step #1: Appropriately labels the TRAIN and TEST data sets with descriptive variable names. (Note: Listed as
#         step #4 in the original instrucitons.  Placed at the front of the processing cycle to
#         trim down the data set early for performance advantages.)
names(X_train) <- as.vector(features$featureLabel)
names(X_test) <- as.vector(features$featureLabel)

# Step #2: Extract only the measurements on the mean and standard deviation for each measurement.
#         This step reduces the working dataset to just the principlal fields required for the
#         assignment.
focusFeatures <-
  subset(features, (!grepl(
    "meanfreq", tolower(features$featureLabel)
  )
  &
    !grepl("angle", tolower(
      features$featureLabel
    )))
  &
    (
      grepl("mean", tolower(features$featureLabel)) |
        grepl("std", tolower(features$featureLabel)) |
        grepl("ActivityId", tolower(features$featureLabel)) |
        grepl("SubjectId", tolower(features$featureLabel))
    ))

xTrain <- X_train[,c(focusFeatures$colId)]
xTest <- X_test[,c(focusFeatures$colId)]
rm(X_train)
rm(X_test)

# Step #3: Merge the trainng and test sets to create on Dataset
tiddyData <-
  rbind(cbind(subject_Test, Y_test, xTest), cbind(subject_Train, Y_train, xTrain))

# Step #4: Name the activites in the dataset
tiddyData$activityLabel <-
  activity_labels[tiddyData$activityId,]$activityLabel
rm(Y_test)
rm(subject_Test)
rm(subject_Train)
rm(Y_train)


# Step #5: From the data set in step 4, creates a second, independent tidy data set with the
#          average of each variable for each activity and each subject.
tiddyMean <-
  ddply(tiddyData,.(activityLabel, subjectId),numcolwise(mean,na.rm = TRUE))
tiddyMean <-
  arrange(tiddyMean, activityLabel, as.numeric(levels(subjectId)[subjectId]))

# Step #6: Output the tiddy data and the mean of the tiddy numeric variables to a file for upload
write.table(tiddyData, file = "Tiddy_data.csv", sep = ",")
write.table(tiddyMean, file = "Tiddy_mean.csv", sep = ",")
