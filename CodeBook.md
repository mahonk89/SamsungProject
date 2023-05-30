## Samsung Accelerometer Data Cleaning CodeBook

### Process of getting clean data

Data was obtained from the source

```         
datadl<-https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
```

Then downloaded to the "data" folder within the current working directory.

Relevant data was found in 
```
fileloc<-"./data/UCI HAR Dataset/"
```

### Transformations
The package "dplyr" is required.
```
library(dplyr)
```
Relevant data was read into R using the .txt files provided and saved as variables.

```{r}
activity_labels<-read.table(paste0(fileloc,"activity_labels.txt"))
features<-read.table(paste0(fileloc,"features.txt"))
x_train<-read.table(paste0(fileloc,"/train/X_train.txt"))
y_train<-read.table(paste0(fileloc,"/train/Y_train.txt"))
s_train<-read.table(paste0(fileloc,"/train/subject_train.txt"))
x_test<-read.table(paste0(fileloc,"/test/X_test.txt"))
y_test<-read.table(paste0(fileloc,"/test/Y_test.txt"))
s_test<-read.table(paste0(fileloc,"/test/subject_test.txt"))
```

The y_ and s_ data frames for the test and train data contain the identifiers for
the measured activity and the person who performed it respectively. They must be
combined with the data in the x_ test and train variables so that each observation
is associated with a person and activity

```
testdata<-cbind(x_test,y_test,s_test)
traindata<-cbind(x_train,y_train,s_train)
```

The columns are then named using the second column of the features data containing
named variables and assigned to each testdata and traindata
```
col_names<-c(features[,2],"Activity","SubjectID")
```

Data from both the test and train set can now be combined into a single data set
```
samsung<-rbind(traindata,testdata)
```

Change the activity ID from a number to the description, and change the 
activity and subject columns to factors.
```
samsung$Activity<-factor(samsung$Activity,activity_labels[,1],activity_labels[,2])
samsung$SubjectID<-factor(samsung$SubjectID,1:30)
```

Remove the unnecessary columns by selecting only the required mean and std
columns, plus the subject and activity columns for identification
```
tidydata<-
  samsung %>% 
  select(SubjectID,Activity,contains("mean"),contains("std"))
```

Rename the columns by using information from features_info.txt
```
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
```

Using the clean set of data, create a new data set containing the means of each
variable for each subject and activity. 
```
subject_activity_means<-
  tidydata %>%
  group_by(subjectID,activityID) %>%
  select(where(is.numeric)) %>%
  summarize_all(mean)
```



