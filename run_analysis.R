## project for Coursera/JH's Cleaning Data course
library(plyr)
library(dplyr)

features <- tbl_df(read.table("UCI HAR Dataset/features.txt"))

a <- tbl_df(read.table("UCI HAR Dataset/test/X_test.txt"))
b <- tbl_df(read.table("UCI HAR Dataset/test/y_test.txt"))
c <- tbl_df(read.table("UCI HAR Dataset/test/subject_test.txt"))

## descriptive column names added
colnames(a)  <- features$V2
colnames(b) <- c("Activity")
colnames(c) <- c("Subject")

## affix subjects and activities
test <- cbind(b,c,a)

d <- tbl_df(read.table("UCI HAR Dataset/train/X_train.txt"))
e <- tbl_df(read.table("UCI HAR Dataset/train/y_train.txt"))
f <- tbl_df(read.table("UCI HAR Dataset/train/subject_train.txt"))
colnames(e) <- c("Activity")
colnames(f) <- c("Subject")

## descriptive column names added
colnames(d)  <- features$V2

train <- cbind(e,f,d)


## merge test and train data
testandtrain  <- rbind(test,train)

## descriptive name lookup
act_names <- c("walking", "walking upstairs", "walking downstairs", "sitting", "standing", "laying")



## eliminate duplicates
testandtrain_nodup  <- tbl_df(testandtrain[, !duplicated(colnames(testandtrain))])

## select the cols containing means or std devs
sel_tt_data  <- tbl_df(select(testandtrain_nodup, contains("Subject"), contains("Activity"),contains("mean"), contains("std")))

## add descriptive names for activity column
sel_tt_final  <- mutate(sel_tt_data, Activity = act_names[Activity])

## group by activity and subject
sel_grouped <- group_by(sel_tt_final, Activity, Subject)

## see the summarized mean data of the groups
sel_gr_summary <- summarize_each(sel_grouped, funs(mean))
