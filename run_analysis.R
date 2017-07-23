# Set working directory
setwd('./Documents/datascience/Week4/04/assignment')
# Download data source
zip_url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(zip_url,'dataset.zip')
unzip('dataset.zip')
# read test files and convert each one of them in a dataframe
test_s <- read.table('UCI HAR Dataset/test/subject_test.txt')
test_x <- read.table('UCI HAR Dataset/test/X_test.txt')
test_y <- read.table('UCI HAR Dataset/test/y_test.txt')
# combine test files in a specific dataframe
all_test <- cbind(test_s,test_y,test_x)
# read training files and convert each one of them in a dataframe
train_s <- read.table('UCI HAR Dataset/train/subject_train.txt')
train_x <- read.table('UCI HAR Dataset/train/X_train.txt')
train_y <- read.table('UCI HAR Dataset/train/y_train.txt')
# combine training files in a specific dataframe
all_train <- cbind(train_s,train_y,train_x)
# combine trainings and tests dataframe in a single dataframe
all <- rbind(all_train,all_test)
# save the dataframe containing trainings and tests data in a file
# for security reasons. In this way is also possible to clear the 
# current session in order to avoid memory overload
saveRDS(all,file = 'all_train_and_test')
# load dataframe if previous session was cleared
all <- readRDS('all_train_and_test')
# read features with the purpose of adding columns to dataframe
# containing trainings and tests data
features <- read.table('UCI HAR Dataset/features.txt')
# add names for subjects and actions
all_names <- c('subject','action',as.vector(features$V2))
# insert column names to dataframe
# containing trainings and tests data
colnames(all) <- all_names
# extract measurements for mean and standard deviation
all_mean_std <- all[, grep("(subject|action|.+(mean|std).+)", colnames(all))]
# read descriptive activity names in dataframe
activity_names_table <- read.table('UCI HAR Dataset/activity_labels.txt')
# modify activity names dataframe column names in order to
# use descriptive activity names to name the activities in the data set
colnames(activity_names_table) <- c('action','description')
all_mean_std <- join(activity_names_table,all_mean_std,by = 'action')
# Appropriately labels the data set with descriptive variable names 
all_mean_std$action <- NULL
colnames(all_mean_std)[1] <- 'activity'
# Save dataframe with measurements for mean and standard deviation to file
write.csv(all_mean_std,'all_mean_std.csv')
# Grouping dataframe by activity and subject
grouped_all_mean_std <- group_by(all_mean_std,activity,subject)
# Create dataframe with the average of each variable for each activity
# and each subject
average_grouped_all_mean_std <- summarise_all(grouped_all_mean_std,mean)
# Save dataframe with average of each variable for each activity
# and each subject
write.csv(average_grouped_all_mean_std,'average_grouped_all_mean_std.csv')


