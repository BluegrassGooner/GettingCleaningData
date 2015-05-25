#Download the data file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./Dataset.zip", method = "curl")
unzip("Dataset.zip")

#Create intial dataframes
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features.df <-read.table("./UCI HAR Dataset//features.txt")
subject_test.df <- read.table("./UCI HAR Dataset//test//subject_test.txt")
X_test.df <- read.table("./UCI HAR Dataset//test//X_test.txt")
y_test.df <- read.table("./UCI HAR Dataset//test//y_test.txt")
subject_train.df <- read.table("./UCI HAR Dataset//train//subject_train.txt")
X_train.df <- read.table("./UCI HAR Dataset//train//X_train.txt")
y_train.df <- read.table("./UCI HAR Dataset//train//y_train.txt")

#Add varialble names to X_test and X_train
variable_names <- features.df[,2]
names(X_test.df) <- variable_names
names(X_train.df) <- variable_names

#Add respective subject and test columns to the front of X_test and X_train
column_names <- c("Subject", "Activity")
subject_test_test.df <-cbind(subject_test.df,y_test.df)
subject_test_train.df <-cbind(subject_train.df,y_train.df)
names(subject_test_test.df) <- column_names
names(subject_test_train.df) <- column_names
test.df <- cbind(subject_test_test.df,X_test.df)
train.df <- cbind(subject_test_train.df,X_train.df)

#Combine the test and train data sets into one dataframe
dataset.df <- rbind(test.df,train.df)

#Create a character vector of all variable names with 'mean()', 'Mean', or 'std().'
mean_std <- grep("mean()|Mean|std()", names(dataset.df), value = T)

#Create a final dataset with only the required measurements
final <- dataset.df[,c(names(dataset.df)[1:2],mean_std)]

#Rename the variables in the Activity column
library(plyr)
final$Activity <- mapvalues(final$Activity,activity_labels[,1],as.character(activity_labels[,2]))

#Create tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
tidy_data_set <- group_by(final,Subject,Activity) %>% summarise_each(funs(mean))

write.table(tidy_data_set, "./tidydata.txt", row.name=F)

