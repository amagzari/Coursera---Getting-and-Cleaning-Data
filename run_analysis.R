# Coursera - Johns Hopkins Data Science Specialization
# Course 3 - Getting and Cleaning Data- Week 4 - Assignment  
# https://github.com/gangxu79/Getting-and-Cleaning-Data-Week-4-Assignment/blob/master/run_analysis.R

# SET WORKING DIRECTORY ACCORDINGLY

# Load dplyr library

library(dplyr)

# Read training data

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Read test data

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Merge the training and test set to create one data set

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Read features file

features <- read.table("UCI HAR Dataset/features.txt")

# Extract only the measurements on the mean and standard deviation for each measurement

# Use the grep function to search for the patterns "mean" and "std"

features_extracted <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
x_data <- x_data[,features_extracted[,1]]

# Read activity labels

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

# Use descriptive activity names to name the activities in the data set

colnames(y_data) <- "Activity"
y_data$Activity <- factor(y_data$Activity, labels = as.character(activity_labels[,2]))

# Appropriately label the data set with descriptive variable names

colnames(x_data) <- features_extracted[,2]

# Create a second, independent tidy data set with the average of each variable for each activity and each subject

# Name the subject column

colnames(subject_data) <- "Subject"

# Combine the columns of subjects, activities and extracted measurements
data_combined <- cbind(subject_data, y_data, x_data)

# Calculate the mean of the measurements according to activity and subject
data_mean <- data_combined %>% group_by(Activity, Subject) %>% summarize_all(mean)

# Output result to text file
write.table(data_mean, "tidy_set.txt", row.name=FALSE)
