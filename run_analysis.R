# Project file
# Author: Mark Johnson
#
# Specify libraries required to tiddy up the data set
setwd("~/R_Coursera_Course/gettingAndCleaning/UCI HAR Dataset")

library(plyr)
library(dplyr)

# Step 0: Load the UCI HAR Dataset files and specify the column names and column types
features <-
  read.table(
    "features.txt", colClasses = c("numeric","factor"), col.names = c("colId","featureLabel")
  )
features$featureLabel <- sapply(features$featureLabel, function(x) sub("[[:punct:]][[:punct:]][[:punct:]]","_",x))
features$featureLabel <- sapply(features$featureLabel, function(x) sub("[[:punct:]]","",x))
featureLabels <- as.vector(features$featureLabel)


X_test <- read.table("test/X_test.txt", col.names=featureLabels)
Y_test <-
  read.table(
    "test/y_test.txt", colClasses = c("factor"), col.names = c("activityId")
  )
X_train <- read.table("train/X_train.txt", col.names = featureLabels)
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
activity_labels <-
  read.table(
    "activity_labels.txt", colClasses = c("numeric","factor"), col.names = c("activityId","activityLabel")
  )

# Step #1: Merge the trainng and test sets to create on Dataset
tiddyData <-
  rbind(cbind(subject_Test, Y_test, X_test), cbind(subject_Train, Y_train, X_train))

# Step #2: Extract only the measurements on the mean and standard deviation for each measurement.
#         This step reduces the working dataset to just the principlal fields required for the
#         assignment.
tiddyDataFieldNames <- data.frame(featureLabel = names(tiddyData), colId = 1:ncol(tiddyData))
#tiddyDataFieldNames$colId <- ifelse(tiddyDataFieldNames$featureLabel=='subjectId',)
#tiddyDataFieldNames <- rbind(c("1","SubjectId"), focusedFeatures)
#tiddyDataFieldNames <- rbind(c("2","activityId"), focusedFeatures)
focusedFeatures <- tiddyDataFieldNames %>%  filter(
  grepl("mean", featureLabel) |
    grepl("std", featureLabel) |
    grepl("activityId", featureLabel) |
    grepl("subjectId", featureLabel)
)

tiddyData <- subset(tiddyData, select = c(focusedFeatures$colId))



# Step #3: Uses descriptive activity names to name the activities in the data set
tiddyData$activityLabel <-
  activity_labels[tiddyData$activityId,]$activityLabel
rm(Y_test)
rm(subject_Test)
rm(subject_Train)
rm(focusedFeatures)
rm(tiddyDataFieldNames)
rm(Y_train)

# Step #4: Appropriately labels the data set with descriptive variable names. 
origNames <- names(tiddyData)
origNames <- lapply(names(tiddyData), function(x) {
  gsub("Acc","Accelleration", x)
  })

# Step #5: From the data set in step 4, creates a second, independent tidy data set with the
#          average of each variable for each activity and each subject.
tiddyMean <-
  ddply(tiddyData,.(activityLabel, subjectId),numcolwise(mean,na.rm = TRUE))
tiddyMean <-
  arrange(tiddyMean, activityLabel, as.numeric(levels(subjectId)[subjectId]))

# Step #6: Output the tiddy data and the mean of the tiddy numeric variables to a file for upload
write.table(tiddyData, file = "Tiddy_data.txt")
write.table(tiddyMean, file = "Tiddy_mean.txt")
