#set workspace
setwd("C:/Users/Bingz/Documents/R_data/UCI HAR Dataset")

#load data sets into R
x_train <- read.table("./train/X_train.txt")
subject_train <- read.table("./train/subject_train.txt")
y_train <- read.table("./train/y_train.txt")

x_test <- read.table("./test/X_test.txt")
subject_test <- read.table("./test/subject_test.txt")
y_test <- read.table("./test/y_test.txt")

features <- read.table("./features.txt")
activity_labels <- read.table("./activity_labels.txt")

#merge the train and test data, label descriptive variable names
dim(x_train)
dim(x_test)

x_train$group <- "train" 
x_test$group <- "test"

x_combine <- rbind(x_train, x_test)
names(x_combine)[1:561] <- as.character(features$V2)
subject <- c(subject_train$V1, subject_test$V1)
activity <- c(y_train$V1, y_test$V1)
x_all <- cbind(x_combine, subject, activity)

#select variables with "-mean()" and "-std()"
index_mean <- grep("-mean\\(\\)", features[,2])
index_std <- grep("-std\\(\\)", features[,2])
index <- c(index_mean, index_std, 562:564)

x_sel_temp1 <- x_all[, index]
x_order_act <- x_sel_temp1[order(x_sel_temp1$activity, x_sel_temp1$subject),]

#use descriptive activity names
x_sel_temp2 <- merge(x_order_act, activity_labels, by.x = "activity", by.y = "V1")
x_tidy <- x_sel_temp2[, -1]
names(x_tidy)[ncol(x_tidy)] <- "activity"

#creat an independent data set calculating variable mean for each subject and each activity
x_mean_sub_act <- aggregate(.~ activity + subject, data = x_tidy[, -67], FUN = mean)
write.table(x_mean_sub_act, file = "./final_dataset.txt", row.names = F)

