## run_analysis.R

library(tidyverse)
library(dplyr)

# Download and unzip data to parent folder ./data
if(!file.exists("./data")) dir.create("./data")
datadl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(datadl,"./data/dataset.zip")
unzip("./data/dataset.zip",exdir="./data/")
dir("./data") # locate dataset information after unzip
fileloc<-"./data/UCI HAR Dataset/"

# pulling data into R
activity_labels<-read.table(paste0(fileloc,"activity_labels.txt"))
features<-read.table(paste0(fileloc,"features.txt"))

# train data
x_train<-read.table(paste0(fileloc,"/train/X_train.txt"))
y_train<-read.table(paste0(fileloc,"/train/Y_train.txt"))
s_train<-read.table(paste0(fileloc,"/train/subject_train.txt"))

# test data
x_test<-read.table(paste0(fileloc,"/test/X_test.txt"))
y_test<-read.table(paste0(fileloc,"/test/Y_test.txt"))
s_test<-read.table(paste0(fileloc,"/test/subject_test.txt"))

# add activity identifier, subject ID to test and train data
testdata<-cbind(x_test,y_test,s_test)
traindata<-cbind(x_train,y_train,s_train)

# Naming columns based on features
col_names<-c(features[,2],"Activity","SubjectID")
names(testdata)<-col_names
names(traindata)<-col_names

# Combine test and train data by rows
samsung<-rbind(traindata,testdata)

# Clearing data variables that have been merged to free memory
rm(x_test,y_test,s_test,x_train,y_train,s_train,traindata,testdata)

# Changing activity ID from number to descriptions as factors, subject as factor
samsung$Activity<-factor(samsung$Activity,activity_labels[,1],activity_labels[,2])
samsung$SubjectID<-factor(samsung$SubjectID,1:30)

# Removing unnecessary columns from complete data set, keeping mean, std 
# and identifier columns
tidydata<-
  samsung %>% 
  select(SubjectID,Activity,contains("mean"),contains("std"))

# Renaming columns to be more descriptive using the files features.txt and 
# features_info.txt 

names(tidydata) #visual inspection in R
names(tidydata)<-gsub("^t","Time",names(tidydata))
names(tidydata)<-gsub("angle(t","Angle(Time",names(tidydata),fixed=T)
names(tidydata)<-gsub("Freq()","Frequency",names(tidydata),fixed=T)
names(tidydata)<-gsub("^f","Frequency",names(tidydata))
names(tidydata)<-gsub("-mean()","Mean",names(tidydata),fixed=T)
names(tidydata)<-gsub("mean","Mean",names(tidydata))
names(tidydata)<-gsub("-std()","Std",names(tidydata),fixed=T)
names(tidydata)<-gsub("[Bb]ody[Bb]ody","Body",names(tidydata))
names(tidydata)<-gsub("Acc","Accelerometer",names(tidydata))
names(tidydata)<-gsub("Gyro","Gyroscope",names(tidydata))
names(tidydata)<-gsub("Mag","Magnitude",names(tidydata))
names(tidydata)<-gsub("-","",names(tidydata),fixed=T)

# A new set of data which calculates the mean of each feature for each subject
# and activity. i.e. mean(tidydata[(SubjectID == n & Activity == m),i])
subject_activity_means<-
  tidydata %>%
  group_by(SubjectID,Activity) %>%
  select(where(is.numeric)) %>%
  summarize_all(mean)

# save to .csv for future use without having to go through the steps again.
write.csv(subject_activity_means,"./data/subject_activity_means.csv")





  
  