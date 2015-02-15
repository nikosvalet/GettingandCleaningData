## R-scipt for Course 'Getting and Cleaning Data'

## Load dplyr if needed

# library(dplyr)

## Download data and unzip in a new folder called CourseProjectData

# Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# dir.create("./CourseProjectData")

# download.file(Url,"./CourseProjectData/zipped_data.zip")

# zipdata <- "./CourseProjectData/zipped_data.zip"

# unzip(zipdata,exdir="./CourseProjectData")

## Datasets

## Test Dataset

X_test <- read.table("./CourseProjectData/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./CourseProjectData/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./CourseProjectData/UCI HAR Dataset/test/subject_test.txt")

## Train Dataset


X_train <- read.table("./CourseProjectData/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./CourseProjectData/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./CourseProjectData/UCI HAR Dataset/train/subject_train.txt")

## Labels

features <- read.table("./CourseProjectData/UCI HAR Dataset/features.txt")
activity_labels <- read.table("./CourseProjectData/UCI HAR Dataset/activity_labels.txt")

## Part 1 : Create a Dataset with all data 
#  by merging train and test sets

#  First assign names to columns

colnames(subject_test) <- "Subject"
colnames(subject_train) <- "Subject"
colnames(y_test) <- "Activity"
colnames(y_train) <- "Activity"

#  Then create the data frames for both sets

C_X_test <- data.frame(subject_test,y_test,X_test)
C_X_train <- data.frame(subject_train,y_train,X_train)

rm(subject_test,y_test,X_test,subject_train,y_train,X_train)

#  Now merge into the new Dataset

Dataset <- merge(C_X_test,C_X_train,all.x=TRUE,all.y=TRUE)

rm(C_X_test,C_X_train)

# Assign names to columns V1 to V561

for (i in 1:561){
        
        colnames(Dataset)[i+2] <- as.character(features[i,2])
        
        
}

# Part 1 & 4 finished - View the Dataset (with descriptibe variable labels)

View(Dataset)

# Part 2 - Extract only mean and standard deviation of measurements from the data set

Extracted_Dataset <- Dataset[ ,grep("mean|std",colnames(Dataset))]
Extracted_Dataset <- data.frame(Subject = Dataset$Subject,Activity = Dataset$Activity,Extracted_Dataset)

# Part 2 finished - View Extracted_Dataset

View(Extracted_Dataset)

# Part 3 Descriptive activity names

Activity_names <- as.character(activity_labels[Dataset$Activity,2])

Dataset$Activity <- as.character(Dataset$Activity)

Dataset$Activity <- Activity_names

# Part 3 finished - View fixed Dataset

View(Dataset)

# Part 4 was already done

# Part 5 Tidy Data

Tidy <- group_by(Extracted_Dataset,Subject,Activity)

Tidy_Data_Set <- summarise_each(Tidy,funs(mean))

rm(Tidy)

# Part 5 finished - View Tidy_Data_Set

View(Tidy_Data_Set)

write.table(Tidy_Data_Set,file="Tidy_Data_Set.txt",row.name=FALSE)
