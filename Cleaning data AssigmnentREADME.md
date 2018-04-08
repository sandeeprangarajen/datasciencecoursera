Data Set to be used
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


## URL from here the file needs to be downloaded
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Setting up a working directory

setwd("D:/SANDY/Enter The Dragon/Data Science")

if(!file.exists("./DATA")){dir.create("./DATA")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./DATA/Dataset.zip",exdir="./DATA")
-------------------------------------------------------------------------

Making the Test and Training Set Data
The objective here is to make the test and training data as per the sequence stated above. 4 basic level data sets will be defined and created:

test data set
train data set
features data set
activity labels data set


x_train_proj <- read.table("./DATA/UCI HAR Dataset/train/X_train.txt")
y_train_proj <- read.table("./DATA/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./DATA/UCI HAR Dataset/train/subject_train.txt")


x_test_proj <- read.table("./DATA/UCI HAR Dataset/test/X_test.txt")
y_test_proj <- read.table("./DATA/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./DATA/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./DATA/UCI HAR Dataset/features.txt')

activityLabels = read.table('./DATA/UCI HAR Dataset/activity_labels.txt')
-------------------------------------------------------------------------
Tagging the test and train data sets

colnames(x_train_proj) <- features[,2] 
colnames(y_train_proj) <-"activityId"
colnames(subject_train) <- "subjectId"
      
colnames(x_test_proj) <- features[,2] 
colnames(y_test_proj) <- "activityId"
colnames(subject_test) <- "subjectId"
      
colnames(activityLabels) <- c('activityId','activityType')
-------------------------------------------------------------------------
The main objective was to merge the test and train data

mrg_train <- cbind(y_train_proj, subject_train, x_train_proj)
mrg_test <- cbind(y_test_proj, subject_test, x_test_proj)
setAllInOne <- rbind(mrg_train, mrg_test)

-------------------------------------------------------------------------

Extracting only the measurements on the mean and standard deviation for each measurement

colNames <- colnames(setAllInOne)

mean_and_std <- (grepl("activityId" , colNames) | 
                 grepl("subjectId" , colNames) | 
                 grepl("mean.." , colNames) | 
                 grepl("std.." , colNames) 
                 )
                 
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]
                 
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,by='activityId',all.x=TRUE)
  
-------------------------------------------------------------------------
Creatring tidy data set

secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)