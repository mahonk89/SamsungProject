## Initial testing space -- copy over to run_analysis.R once finished. 

getwd()
file.edit("../CleaningData/NFL_Drafts.R")

mypackages<-list("tidyverse","dplyr",)
to_install<-mypackages[!(mypackages %in% installed.packages()[,1])]
install.packages(to_install)
sapply(mypackages,library,character.only=T,quiet=T)
rm(list=ls())

library(tidyverse)
library(dplyr)


datadl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir.create("./data")
download.file(datadl,"./data/dataset.zip")
unzip("./data/dataset.zip",exdir="./data/")

fileloc<-"./data/UCI HAR Dataset/"

activity_labels2<-read.table(paste0(fileloc,"activity_labels.txt"))
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
testdata<-cbind(x_test,y_test,s_test,rep("test",length(x_test[,1])))
traindata<-cbind(x_train,y_train,s_train,rep("train",length(x_train[,1])))

#X#X#X#X DO NOT COPY, ADDED TO MAIN DFS AFTER REMOVING INITIAL DFS #x#x#x#x
testdata<-cbind(testdata,rep("test",length(testdata[,1])))
traindata<-cbind(traindata,rep("data",length(traindata[,1])))
#X#X#X#X DO NOT COPY, ADDED TO MAIN DFS AFTER REMOVING INITIAL DFS #x#x#x#x

col_names<-c(features[,2],"activityID","subjectID")
names(testdata)<-col_names
names(traindata)<-col_names



# remove DFs that have been merged, all data exists in testdata and traindata
rm(x_test,y_test,s_test,x_train,y_train,s_train) 

samsung<-rbind(traindata,testdata)

tidydata<-
  samsung %>% 
  select(subjectID,activityID,contains("mean"),contains("std"))

names(tidydata) # visual inspection of remaining column names
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

subject_activity_means<-
  tidydata %>%
  group_by(subjectID,activityID) %>%
  select(where(is.numeric)) %>%
  summarize_all(mean)


getwd()

