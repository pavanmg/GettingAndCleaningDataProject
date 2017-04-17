setwd("/Users/bhavanamunshi/Documents/DataScientistTrack/GettingAndCleaningData/Week4/")

########################################
##list of activities 
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
cat("Reading \"activity_labels.txt\" it contains list of different activities the data was collected for Activity lables are : ", activityLabels[,2], " respectively")

#######################################
### list of all the various measurements that are measured and calculated
dataColNames_features <- read.table("UCI HAR Dataset/features.txt")
dataColNames_features[,2] <- as.character(dataColNames_features[,2] )
cat("Reading \"features.txt\" it contians Column names for the data in X_test.txt and X_train.txt are stored features.txt, So the total columns in both the files should be" ,nrow(dataColNames_features), "each")



#as the per the http://archive.ics.uci.edu/ml/datasets/Smartphone-Based+Recognition+of+Human+Activities+and+Postural+Transitions
# total number of subject are 30
#checking the number of subject in the test set is 30% of total subject 30
#######TData checking 

test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")


cat("30 % of the total is thats is 30 is : " ,30*30/100,
    "\n number of unique testing subject are: ", nrow(unique(test_subject)) )

X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
cat ("Total number of columns in \"X_test.txt\":",ncol(X_test),
     "\n Total number of rows in \"features.txt\"",nrow(dataColNames_features), 
     "\n We notice that these are equal" )


# y_test.txt describes which "activity"(from the 6 total activities 1.walking, 2.walking_upstairs, 3.walking_downstairs, 4.sitting, 5.standing and 6.laying) data has been represented in the corresponding row of X_test.txt
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")


cat("Total number of rows present in the X_test.txt should be same as y_test so lets check : ",
    "\n Number of rows in X_test:", nrow(X_test),
    "\n Number of rows in y_test:", nrow(y_test),
    "\n We notice that these are equal")

#######Training  Data checking 
#as the per the http://archive.ics.uci.edu/ml/datasets/Smartphone-Based+Recognition+of+Human+Activities+and+Postural+Transitions
# total number of subject are 30
# checking the number of subject in the training set is 70% of total subject 30 

training_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")

cat("70 % of the total is thats is 30 is : " ,70*30/100,
    "\n number of unique training subject are: ", nrow(unique(training_subject)) )

X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
cat ("Total number of columns in \"X_train.txt\":",ncol(X_train),
     "\n Total number of rows in \"features.txt\"",nrow(dataColNames_features), 
     "\n We notice that these are equal" )


# y_test.txt describes which "activity"(from the 6 total activities 1.walking, 2.walking_upstairs, 3.walking_downstairs, 4.sitting, 5.standing and 6.laying) data has been represented in the corresponding row of X_test.txt
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")


cat("Total number of rows present in the X_test.txt should be same as y_test so lets check : ",
    "\n Number of rows in \"X_train.txt\"", nrow(X_train),
    "\n Number of rows in \"y_train:\"", nrow(y_train),
    "\n We notice that these are equal")

############ The above code shows the data is ready to be merged 

# Step 1
# Merges the training and the test sets to create one data set.

# create 'X' data set
X_data <- rbind(X_train, X_test)


# create 'y' data set
y_data <- rbind(y_train, y_test)


# create 'subject' data set
subject_data <- rbind(training_subject, test_subject)



#################################################

#### # Step 2
# Extracts only the measurements on the mean and standard deviation for each measurement.


dataColNames_mean_std_filter<- grep(".*mean.*|.*std.*", dataColNames_features[,2])

cat ("Total number of features that have mean and standard deviation in their names : ", length(dataColNames_mean_std_filter))


# subset the desired columns
X_data_subset_mean_std_selected <- X_data[, dataColNames_mean_std_filter]
cat ("Total number of columns after filtering out unwanted columns  : ", ncol(X_data_subset_mean_std_selected))

# Add the column names to the subset data after the mean and std filter
names(X_data_subset_mean_std_selected) <- dataColNames_features[dataColNames_mean_std_filter, 2]


#####################################################

# Step 3
# Use descriptive activity names to name the activities in the data set
###############################################################################



# substitue the values with  activity names
y_data[, 1] <- activityLabels[y_data[, 1], 2]



# Step 4
# Appropriately label the data set with descriptive variable names
###############################################################################
# give the column name for y_data
names(y_data) <- "activity"

names(subject_data) <- "subject"

# adding two extra columns containing the activity information and the subject information.
all_data_mean_std_selected <- cbind(X_data_subset_mean_std_selected, y_data, subject_data)


cat ("Total number of columsn after adding two columns  : ", ncol(all_data_mean_std_selected))

cat ("Total number of rows after adding two columns should be same as before  : ", nrow(all_data_mean_std_selected))


# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################



all_data_mean_std_selected$activity <- as.factor(all_data_mean_std_selected$activity)
all_data_mean_std_selected$subject <- as.factor(all_data_mean_std_selected$subject)

library(plyr)
library(reshape2)
all_data_mean_std_selected.melted <- melt(all_data_mean_std_selected, id = c("subject", "activity"))

AVG_data_perUser_perActivity_col_selected <- ddply(all_data_mean_std_selected, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(AVG_data_perUser_perActivity_col_selected, "AVG_data_perUser_perActivity_col_selected.txt", row.name=FALSE)


