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


Add a new chunk by clicking the *Insert Chunk* button on the toolbar or by pressing *Ctrl+Alt+I*.

When you save the notebook, an HTML file containing the code and output will be saved alongside it (click the *Preview* button or press *Ctrl+Shift+K* to preview the HTML file).

The preview shows you a rendered HTML copy of the contents of the editor. Consequently, unlike *Knit*, *Preview* does not run any R code chunks. Instead, the output of the chunk when it was last run in the editor is displayed.
