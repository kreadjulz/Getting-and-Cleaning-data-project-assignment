#Downloaded the zipped folder. Unzipped the folder and set unzipped folder as working directory

#Test data clean up and merging
library(dplyr)
test_main <- read.table("./test/X_test.txt", header = FALSE)
features <- read.table("features.txt")
names(test_main) <- as.character(features[,2])
subjects_for_testset <- read.table("./test/subject_test.txt", header = FALSE)
names(subjects_for_testset) <- "Subject_ID"
test_labels <- read.table("./test/y_test.txt")
activities <- read.table("activity_labels.txt")
names(test_labels) <- "activity"
test_labels$activity <- factor(test_labels$activity, levels = c(1,2,3,4,5,6), labels = c("WALKING", "WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING", "LAYING"))
testgroup_df <- as.data.frame(rep("test", nrow(test_main)))
names(testgroup_df) <- "group"
full_test_data <- cbind(testgroup_df,subjects_for_testset,test_labels,test_main)


#Training dataset cleanup and merging
training_main <- read.table("./train/X_train.txt", header = FALSE)
names(training_main) <- as.character(features[,2])
subjects_for_trainingset <- read.table("./train/subject_train.txt", header = FALSE)
names(subjects_for_trainingset) <- "Subject_ID"
train_labels <- read.table("./train/y_train.txt")
names(train_labels) <- "activity"
train_labels$activity <- factor(train_labels$activity, levels = c(1,2,3,4,5,6), labels = c("WALKING", "WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING", "LAYING"))
traininggroup_df <- as.data.frame(rep("training", nrow(training_main)))
names(traininggroup_df) <- "group"
full_training_data <- cbind(traininggroup_df,subjects_for_trainingset,train_labels,training_main)

#merging test and training datasets
full_dataset <- rbind(full_test_data,full_training_data)

#subsetting for mean and standard deviation on fulldataset
columns <- names(full_dataset)
dataset_mean_std <- full_dataset[, columns[grep("group|Subject_ID|activity|std|mean\\(\\)", columns)]]

#Grouping by Subject Id and activity & summarring data by average for each variable

Averages_dataset <- dataset_mean_std %>%
        group_by(Subject_ID, activity) %>%
        summarise_each(funs(mean), vars = -c(1:3))
names(Averages_dataset)[3:68] <- paste("avg",names(Averages_dataset)[3:68], sep = "_")

Averages_dataset
