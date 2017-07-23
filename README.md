## run_analysis.R

Code is divided into parts according to the instructions

**1st instruction:**

> Merges the training and the test sets to create one data set

Get the data set from the web and make it readable

```R
zip_url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(zip_url,'dataset.zip')
unzip('dataset.zip')
```

Read test files and convert each one of them in a dataframe

```R
test_s <- read.table('UCI HAR Dataset/test/subject_test.txt')
test_x <- read.table('UCI HAR Dataset/test/X_test.txt')
test_y <- read.table('UCI HAR Dataset/test/y_test.txt')
```

Combine test files in a specific dataframe

```R
all_test <- cbind(test_s,test_y,test_x)
```

Read training files and convert each one of them in a dataframe

```R
train_s <- read.table('UCI HAR Dataset/train/subject_train.txt')
train_x <- read.table('UCI HAR Dataset/train/X_train.txt')
train_y <- read.table('UCI HAR Dataset/train/y_train.txt')
```

Combine training files in a specific dataframe

```R
all_train <- cbind(train_s,train_y,train_x)
```

Combine trainings and tests dataframe in a single dataframe

```R
all <- rbind(all_train,all_test)
```

Save the dataframe containing trainings and tests data in a file
for security reasons. In this way is also possible to clear the 
current session in order to avoid memory overload

```R
saveRDS(all,file = 'all_train_and_test')
```

Load dataframe if previous session was cleared

```R
all <- readRDS('all_train_and_test')
```

Read features with the purpose of adding columns to dataframe
containing trainings and tests data

```R
features <- read.table('UCI HAR Dataset/features.txt')
```

Add names for subjects and actions

```R
all_names <- c('subject','action',as.vector(features$V2))
```

Insert column names to dataframe
containing trainings and tests data

```R
colnames(all) <- all_names
```

**2nd instruction:**

> Extracts only the measurements on the mean and standard deviation for each measurement

Extract measurements for mean and standard deviation

```R
all_mean_std <- all[, grep("(subject|action|.+(mean|std).+)", colnames(all))]
```

**3rd instruction:**

> Uses descriptive activity names to name the activities in the data set

Read descriptive activity names in dataframe

```R
activity_names_table <- read.table('UCI HAR Dataset/activity_labels.txt')
```

Modify activity names dataframe column names in order to
use descriptive activity names to name the activities in the data set

```R
colnames(activity_names_table) <- c('action','description')
all_mean_std <- join(activity_names_table,all_mean_std,by = 'action')
```

**4th instruction:**

> Appropriately labels the data set with descriptive variable names

Appropriately labels the data set with descriptive variable names

```R
all_mean_std$action <- NULL
colnames(all_mean_std)[1] <- 'activity'
```

Save dataframe with measurements for mean and standard deviation to file

```R
write.csv(all_mean_std,'all_mean_std.csv')
```

**5th instruction:**

> From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

Grouping dataframe by activity and subject

```R
grouped_all_mean_std <- group_by(all_mean_std,activity,subject)
```

Create dataframe with the average of each variable for each activity and each subject

```R
average_grouped_all_mean_std <- summarise_all(grouped_all_mean_std,mean)
```

Save dataframe with average of each variable for each activity and each subject

```R
write.csv(average_grouped_all_mean_std,'average_grouped_all_mean_std.csv')
```

