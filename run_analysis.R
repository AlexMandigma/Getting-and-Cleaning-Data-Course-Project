
#1 Merges the training and the test sets to create one data set.

#1.a.Read the Train data Sets
label_train <- read.table("C:/UCIHARDataset/train/y_train.txt")
table(label_train)
data_train <- read.table("C:/UCIHARDataset/train/X_train.txt")
subject_train <- read.table("C:/UCIHARDataset/train/subject_train.txt")

#1.b.Read the Test Data Sets
label_test <- read.table("C:/UCIHARDataset/test/y_test.txt") 
table(label_test)
data_test <- read.table("C:/UCIHARDataset/test/X_test.txt")
subject_test <- read.table("C:/UCIHARDataset/test/subject_test.txt")


#1.c.Merge the train and test data sets
binddata <- rbind(data_train, data_test)
bindlabel <- rbind(label_train, label_test)
bindsubject <- rbind(subject_train, subject_test)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("C:/UCIHARDataset/features.txt")
features[,2] <- as.character(features[,2])
meanstd <- grep("mean\\(\\)|std\\(\\)", features[, 2]) #gets the mean and std
binddata <- binddata[, meanstd]
names(binddata) <- gsub('[-()]', '',  features[meanstd, 2])


#3. Uses descriptive activity names to name the activities in the data set
activity <- read.table("C:/UCIHARDataset/activity_labels.txt")
activity[,2] <- as.character(activity[,2])
activityLabel <- activity[bindlabel[, 1], 2]
bindlabel[, 1] <- activityLabel
names(bindlabel) <- "activity"

#4. Appropriately labels the data set with descriptive variable names.
names(bindsubject) <- "subject"
mergeddata <- cbind(bindsubject, bindlabel, binddata)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
subjectlength <- length(table(bindsubject))
activitydimension <- dim(activity)[1] 
columnlength <- dim(mergeddata)[2]
result <- matrix(NA, nrow=subjectlength*activitydimension, ncol=columnlength) 
result <- as.data.frame(result)
colnames(result) <- colnames(mergeddata)
row <- 1
for(i in 1:subjectlength) {
  for(j in 1:activitydimension) {
    result[row, 1] <- sort(unique(bindsubject)[, 1])[i]
    result[row, 2] <- activity[j, 2]
    k <- i == mergeddata$subject
    l <- activity[j, 2] == mergeddata$activity
    result[row, 3:columnlength] <- colMeans(mergeddata[k&l, 3:columnlength])
    row <- row + 1
  }
}
write.table(result, "tidy_data_set.txt", row.names = FALSE) 