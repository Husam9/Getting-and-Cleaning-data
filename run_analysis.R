## 1- load packages
library(reshape2)

## 2-read train and test set and merge them to a one data set 
test_subject <- read.table("subject_test.txt")
test_y <- read.table("Y_test.txt")
test_x <- read.table("X_test.txt")

train_subject <- read.table("subject_train.txt")
train_y <- read.table("Y_train.txt")
train_x <- read.table("X_train.txt")

## 3- Read measurement file and add column names
features <- read.table("features.txt")
names(train_x) <- features$V2
names(test_x) <- features$V2

## 4- Add subject_id column name for subject file
names(train_subject) <- "subject_id"
names(test_subject) <- "subject_id"

## 5- Add activity column name for label files
names(train_y) <- "activity"
names(test_y) <- "activity"

## 6- Merged train files together,test files together, and merge the two data sets oin one data set
train <- cbind(train_subject,train_y,train_x)
test <- cbind(test_subject,test_y,test_x)
merged <- rbind(train, test)

## 7- Choose only the mean and std measurements
mean_or_std <- grepl("mean\\(\\)", names(merged)) | grepl("std\\(\\)",names(merged))
mean_or_std[1:2] <- TRUE

## 8- Remove unwanted columns
merged <- merged[,mean_or_std]

## 9- label the data set with descriptive activity names and convert activity column to a factor
merged$activity <- factor(merged$activity,labels = c("Walking","Walking_Upstairs","Walking_Downstairs", "Sitting", "Standing", "Laying"))

melted2 <- melt(merged, id=c("subject_id","activity"))
tidy_data <- dcast(melted2, subject_id+activity ~ variable, mean)

write.table(tidy_data,"tidy_data.txt",row.names = FALSE)


