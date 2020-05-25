####reading in the data

#6 activity labels
activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

#list of all the feature variables, can be matched with xtest and xtrain columns
features <- read.table("./UCI HAR Dataset/features.txt")

###test set 

#2947 by 1 dataframe, all test subjects with repeats
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subjectid")

#2947 obs of 561 variables
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
colnames(xtest) <- as.character(features[, 2])

#2947 obs of 1 variable, one through 6 so likely corresponds with activity 
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "activity")

testset <- cbind(subjecttest, ytest, xtest)


##training set

#7352 obs of 1 variable
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                          col.names = "subjectid")

#7352 obs of 561 variables
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
colnames(xtrain) <- as.character(features[, 2])

#7352 obs of 1 variable, match with activity 
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                     col.names = "activity")

trainset <- cbind(subjecttrain, ytrain, xtrain)


#row binding the two data frames to create a single data frame
mergedset <- rbind.data.frame(testset, trainset)

## extract the columns that measure mean or std 
meanindex <- grep("-mean()", colnames(mergedset))
stdindex <- grep("-std()", colnames(mergedset))
colindex <- c(meanindex, stdindex)
colindex <- sort(colindex)

#subsetting merged dataframe to only include mean and std columns, as
#well as subjectid and activity columns
mergedset <- mergedset[, c(1, 2, colindex)]

## matching activity numbers with name

#function that matches the activity integer in the mergedset
#with the name of the activity in activitylabels

activitymatch <- function(x){
        for(i in activitylabels[, 1]){
                if(x == i){
                        return(as.character(activitylabels[i,2]))
                }
        }
}

#replacing integer activity column with activity names
activitynames <- lapply(mergedset$activity, activitymatch)
mergedset$activity <- activitynames


###creating new dataframe which contains the average of each
###variable for each activity and each subject

#setting a vector to represent the column names, which are now the unique
#activities and subject ids
colnames <- c(unique(mergedset$activity), unique(sort(mergedset$subjectid)))

#create new dataframe, whose first row is the 79 factor variables
averages <- data.frame(colnames(mergedset)[3:81])
colnames(averages) <- "variables"



#takes single activity and returns the mean 
#of every variable for that activity
activitymatch <- function(x){
        rownums <- c()
        i = 1 
        
        #loop through activity column in mergedset,
        #if it is identical to the input to the function input,
        #appends row number to rownums vector 
        while(i <= length(mergedset$activity)){
                if(x[[1]] == mergedset$activity[[i]]){
                        rownums <- append(rownums, i)
                }
                i <- i + 1
        }
        
        #subsets mergedset to contain only rows that correspond 
        #with the function input, creates a vector of the column means 
        #of the subsetted dataframe
        subset <- mergedset[rownums, ]
        means <- apply(subset[, -c(1,2)], 2, mean)
        means <- unname(means)
        invisible(means)
}


#loop all unique activites, creating a vector of the factor variable means 
#for each. Append the vector as a column to the new "averages" dataframe
for(x in colnames[1:6]){
        colmean <- activitymatch(x)
        averages[, x] <- colmean
}

#follow the same process but for the subject ids 

idmatch <- function(x){
        rownums <- c()
        i = 1 
        
        #loop through id column in merged set,
        #if it is identical to the input to the function,
        #appends row number to rownums vector 
        while(i <= length(mergedset$subjectid)){
                if(x[[1]] == mergedset$subjectid[[i]]){
                        rownums <- append(rownums, i)
                }
                i <- i + 1
        }
        
        #subsets mergedset to contain only rows that correspond 
        #with the function input, creates a vector of the column means 
        #of the subsetted dataframe
        subset <- mergedset[rownums, ]
        means <- apply(subset[, -c(1,2)], 2, mean)
        means <- unname(means)
        invisible(means)
}

#loop through subjectids and create a vector of factor variable means for 
#each id. Add each vector as a column to the averages dataframe.
for(x in colnames[7:36]){
        colmean <- idmatch(x)
        averages[, as.character(x)] <- colmean
}



