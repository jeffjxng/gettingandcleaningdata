## 1. Merges the training and the test sets to create one data set.

## Make subject dataset
subject_test <- read.table('~/UCI HAR Dataset/test/subject_test.txt')
subject_train <- read.table('~/UCI HAR Dataset/train/subject_train.txt')
subject_merged <- rbind(subject_train, subject_test)

## Make X dataset
X_test <- read.table('~/UCI HAR Dataset/test/X_test.txt')
X_train <- read.table('~/UCI HAR Dataset/train/X_train.txt')
X_merged  <- rbind(X_train, X_test)

## Make Y dataset
y_test <- read.table('~/UCI HAR Dataset/test/y_test.txt')
y_train <- read.table('~/UCI HAR Dataset/train/y_train.txt')
y_merged  <- rbind(y_train, y_test)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement                  
features <- read.table("~/UCI HAR Dataset/features.txt")
meanStdIndices <- grep("mean\\(\\)|std\\(\\)", features[, 2])
X_merged <- X_merged[, meanStdIndices]
names(X_merged) <- gsub("\\(\\)", "", features[meanStdIndices, 2])
names(X_merged) <- gsub("mean", "Mean", names(joinData))
names(X_merged) <- gsub("mean", "Mean", names(X_merged))
names(X_merged) <- gsub("std", "Std", names(X_merged))
names(X_merged) <- gsub("-", "", names(X_merged))

## 3. Uses descriptive activity names to name the activities in 
# the data set
names(y_merged) <- "activity"
activity <- read.table("~/UCI HAR Dataset/activity_labels.txt")
activity[, 2] <- tolower(gsub("_", "", activity[, 2]))
substr(activity[2, 2], 8, 8) <- toupper(substr(activity[2, 2], 8, 8))
substr(activity[3, 2], 8, 8) <- toupper(substr(activity[3, 2], 8, 8))
activityLabel <- activity[y_merged[, 1], 2]
y_merged[, 1] <- activityLabel

## 4. Appropriately labels the data set with descriptive variable names. 
names(subject_merged) <- "subject"
ucihardatabase <- cbind(subject_merged, X_merged, y_merged)
write.table(ucihardatabase, "ucihardatabase.txt")

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
mean_database <- ucihardatabase[, 3:dim(ucihardatabase)[2]]
tidy_database <- aggregate(mean_database, list(ucihardatabase$subject, ucihardatabase$activity), mean)
names(tidy_database)[1:2] <- c('subject', 'activity')
write.table(tidy_database, "~/UCI HAR Dataset/tidy_database.txt")



