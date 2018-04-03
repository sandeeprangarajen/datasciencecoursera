https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

setwd("<current DIR>")

if(!file.exists("./DATA")){dir.create("./DATA")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./DATA/Dataset.zip",exdir="./DATA")


x_train <- read.table("./DATA/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./DATA/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./DATA/UCI HAR Dataset/train/subject_train.txt")


x_test <- read.table("./DATA/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./DATA/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./DATA/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./DATA/UCI HAR Dataset/features.txt')

activityLabels = read.table('./DATA/UCI HAR Dataset/activity_labels.txt')

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
      
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
      
colnames(activityLabels) <- c('activityId','activityType')

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)
colNames <- colnames(setAllInOne)

mean_and_std <- (grepl("activityId" , colNames) | 
                 grepl("subjectId" , colNames) | 
                 grepl("mean.." , colNames) | 
                 grepl("std.." , colNames) 
                 )
                 
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]
                 
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,by='activityId',all.x=TRUE)
                              
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)