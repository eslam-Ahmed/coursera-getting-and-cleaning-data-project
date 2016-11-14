# Getting and Cleaning Data Course Project

#--------  Downlowading the data set
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")



# Merges the training and the test sets to create one data set.

#-------- Reading the different files


# Reading training data
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

# Reading testing data

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# reading features 

features <- read.table("features.txt")

# reading activity labels

activity_labels <- read.table("activity_labels.txt")


#-------------- Assiging Colum Names

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"


colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(activity_labels) <- c('activityID', 'acitvityType')


#------------ 1. Merging Data into one data set
test_data <- cbind(x_test, y_test, subject_test)
train_data <- cbind(x_train, y_train, subject_train)
merged_data <- rbind(test_data,train_data)


#------------ 2. Extracts only the measurements on the mean and standard deviation for each measurement.

col_Names <- colnames(merged_data)
mean_and_std <- (grepl("subjectID", col_Names) |
  grepl ("activityID", col_Names)|
    grepl("mean..", col_Names)|
    grepl("std..", col_Names))


mean_and_std_data <- merged_data[, mean_and_std == TRUE]

#------------ 3. Uses descriptive activity names to name the activities in the data set

dataWithActivityNames <- merge(mean_and_std_data, activity_labels,
                               by = 'activityID',
                               all.x = True)

#------------ 4. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidyDataSet <- aggregate(. ~subjectID + activityID, dataWithActivityNames, mean)
tidyDataSet <- tidyDataSet[order(tidyDataSet$subjectID, tidyDataSet$activityID),]

#------------ 5. Writing tidy data in text file

write.table(tidyDataSet, "tidyDataSet.txt", row.name=FALSE)
