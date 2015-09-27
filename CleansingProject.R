# Project file
# Author: Mark Johnson
#
# Specify libraries required to tiddy up the data set
setwd("~/R_Coursera_Course/gettingAndCleaning/UCI HAR Dataset")


library(reshape2)
library(plyr)

# Load x&y data sets for both the Test and Train instances
x_Test <- read.table("test/X_test.txt")
y_Test <- read.table("test/y_test.txt")
x_Train <- read.table("train/X_train.txt")
y_Train <- read.table("train/y_train.txt")
subject_Test <- read.table("test/subject_test.txt")
subject_Train <- read.table("train/subject_train.txt")
# Make certain the test and training data is identifiable post-merge step to support audit operations
x_Train$DataType <- "TRAIN"
x_Test$DataType <- "TEST"

# Load the support data frames (features, subject_test and activity Labels)
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")


# Step #1: Appropriately labels the data set with descriptive variable names. (Note: Listed as 
#         step #4 in the original instrucitons.  Placed at the front of the processing cycle to 
#         trim down the data set early for performance advantages.)
names(x_Test) <- as.vector(features$V2)
names(x_Train) <- as.vector(features$V2)
names(y_Train) <- c("ActivityId")
names(y_Test) <- c("ActivityId")
names(subject_Test) <- c("SubjectId")
names(subject_Train) <- c("SubjectId")

# Step #2: Extract only the measurements on the mean and standard deviation for each measurement. 
#         This step reduces the working dataset to just the principlal fields required for the
#         assignment.
focusFeatures <- subset(features, (!grepl("meanfreq", tolower(features$V2)) 
                        & !grepl("angle", tolower(features$V2)))
             & 
               (grepl("mean", tolower(features$V2)) | grepl("std", tolower(features$V2)) | 
                  grepl("ActivityId", tolower(features$V2)) | grepl("SubjectId", tolower(features$V2))))
             
xTrain <- x_Train[,c(focusFeatures$V1)] 
xTest <- x_Test[,c(focusFeatures$V1)]

# Step #3: Merge the trainng and test sets to create on Dataset
tiddy_Data <- rbind(cbind(subject_Test, y_Test, xTest), cbind(subject_Train, y_Train, xTrain))

# Step #4: Name the activites in the dataset
tiddy_Data$Activity <- activity_labels[tiddy_Data$ActivityId,]$V2


# Step #5: From the data set in step 4, creates a second, independent tidy data set with the 
#          average of each variable for each activity and each subject.
tiddy_mean <- ddply(tiddy_Data,.(Activity),numcolwise(mean,na.rm = TRUE))
tiddy_mean$SubjectId <- NULL 

