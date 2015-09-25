
# You should create one R script called run_analysis.R that does the following.
library(plyr)

#download data set and extract file from dataset
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

fileDest <- "dataset.zip"

download.file(fileUrl, fileDest);

unzip(fileDest, exdir = ".")



# 1. Merges the training and the test sets to create one data set.

    #read training files
    xTraining <- read.table("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
    yTraining <- read.table("UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE)
    subjectTraining <- read.table("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

    #read test files
    xTest <- read.table("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
    yTest <- read.table("UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE)
    subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

    # merge all training files in one data set
    training <- cbind(subjectTraining, yTraining, xTraining)

    # merge all test files in one data set
    test <- cbind(subjectTest, yTest, xTest)

    # training and test in one data set
    allData <- rbind(training, test)

    #apply label to merged data set
    featureNames <- read.table("UCI HAR Dataset/features.txt")[, 2]
    names(allData) <- featureNames

    
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    
    featureExtract <- grep("(mean|std)\\(\\)", names(allData))
    
    #Limit to columns with feature names matching mean() or std()
    featureLimited <- allData[, featureExtract]


# 3. Uses descriptive activity names to name the activities in the data set
    
    #read activity_labes file  
    activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
    
    # create merged 'y' data set
    yMerged <- rbind(yTraining, yTest)
    
    # update values with correct activity names
    yMerged[, 1] <- activityLabels[yMerged[, 1], 2]
    
    # adjust column name
    names(yMerged) <- "activity"


# 4. Appropriately labels the data set with descriptive variable names. 
    
    # create "subject" data set
    subjectSet <- rbind(subjectTraining, subjectTest)
    
    # adjust column name
    names(subjectSet) <- "subject"
    
    # bind all the data in a single data set
    allDataRev <- cbind(featureLimited, yMerged, subjectSet)



# 5. From the data set in step 4, creates a second, independent tidy data set with the average
#    of each variable for each activity and each subject
    
    # original dataset 66 columns, allDataRev 68 columns (added activity & subject)
    averageSet <- ddply(allDataRev, .(subject, activity), function(x) colMeans(x[, 1:66]))
    
    # second indipendent tidy data set averageSet.txt
    write.table(averageSet, "averageSet.txt", row.name=FALSE)
    
    
    
    
    