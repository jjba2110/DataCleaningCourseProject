# program inits
# set root working directory, NOTE: you will likely have to modify this to run on your machine
setwd("C:\\RData\\CleaningDataProject\\Data")

# load all data
#read in the test data
test_subjects <- read.table(".\\test\\subject_test.txt") #subjects
test_data     <- read.table(".\\test\\x_test.txt") #data
test_activity <- read.table(".\\test\\y_test.txt") #activity

#read in the training data
subjects <- read.table(".\\train\\subject_train.txt") #subjects
data     <- read.table(".\\train\\x_train.txt") #data
activity <- read.table(".\\train\\y_train.txt") #activity

#join the data sets together
subjects <- rbind(subjects, test_subjects)
data     <- rbind(data, test_data)
activity <- rbind(activity, test_activity)

#free up unused memory
test_subjects <- NULL
test_data     <- NULL
test_activity <- NULL

#read features data and rename columns to the correct values
features <- read.table(".\\features.txt")
cols <- as.vector(features$V2)
colnames(data) <- cols

#read in activity values, build and append activity codes and labels
data["activity_no"] <- activity                             #store the act. code
activity_labels <- read.table(".\\activity_labels.txt")     #read in act. labels
activity <- activity_labels[strtoi(activity$V1) ,2]         #build out a vector of act. labels (561x1)
data["activity"] <- as.vector(activity)                     #append the vector column to the master data

#append subjects column to data
data["subjects"] <- as.vector(subjects)

#lay in the first three columns of the a data set
newData <- subset(data, select = c(subjects, activity, activity_no))

#copy only the remaining columns we want from the master data set to the new one
for(i in names(data)){
    if(grepl("mean()", i, fixed=TRUE) | grepl("std()", i, fixed=TRUE)){
        newData[i] <- data[i]
    }
}
 
#sort data - not necessary, but cleaner for validation
newData <- newData[order(newData[, 1], newData[, 2]), ]

#summarize the output data by subject, activity and measure(features)
output <- aggregate(newData[4:69], by=newData[c("activity", "subjects")], FUN=mean)

#write the output file
write.csv(output, file = "output.csv")


