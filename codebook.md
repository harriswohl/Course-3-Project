#### Codebook

The process of transforming the given dataset is as follows:

1. Reading the Raw Data
2. Merging the Training and Validation sets
3. Extracting Measurements of Mean and Standard Deviation
4. Labeling the dataset
5. Creation of a Second Dataset of Averages of All Measures Across Activity and Subject ID

### 1. Reading the Raw Data
The raw text files "activity_labels.txt" and "features.txt" were read using read.table, and were named **activitylabels** and **features** respectively. 

**activitylabels** is a 2 by 6 table with the integers 1 through 6 in the first column, and a unique activiy in the second column.

**features** is a 561 by 2 table with the integers one through 561 in the first column, and a unique feature variable in the second column. These variables included measures such as the following:

tBodyAcc-mean()-X,
tBodyAcc-mean()-Y,
tBodyAcc-mean()-Z,
tBodyAcc-std()-X,
tBodyAcc-std()-Y,
tBodyAcc-std()-Z,
tBodyAcc-mad()-X,
tBodyAcc-mad()-Y,
tBodyAcc-mad()-Z

There were many more variables (561 in total) included in the dataset. 

Next, the text files for the test set and validation set were read in as tables. 

"subject_test.txt" was read in as a table named **subjecttest**. It is a 2947 by 1 table, and its single column contained 9 unique subject id numbers repeated in a seemingly random pattern. The column was renamed as *subjectid*. Renaming the column aided in later merging the test and training sets. 

"X_test.txt" was read in as a 2947 by 561 table named **xtest**. The 561 column names of **xtest** were then renamed as the 561 feature variables from **feature**.  

"y_test.txt" was read in as a 2947 by 1 table called **ytest**. The single column was renamed as *activiy* to aid in later merging. The column contained the integers 1 through 6 repeated in a seemingly random pattern. 

These three tables were binded into a single table called **test** set using cbind().

An identical process was followed for the training set, producing the tables **subjecttrain**, **xtrain**, and **ytrain**. These were binded into a single table called **trainset** using cbind(). 

## 2. Merging the Training and Validation Sets

Using rbind.data.frame(), **testset** and **trainset** were binded by row, to create **mergedset**. 

## 3. Extracting Measurements of Mean and Standard Deviation

Using grep(), the column names of **mergedset** were searched for the strings "-mean()" and "-std()". A numerical vector called **meanindex** was created to represent the column indices that contained a measure of the mean, and **stdindex** was created for column indices that contained a measure of the standard deviation. The variable **colindex** combines these indices into a single vector and sorts the integers in ascending order. 

**mergedset** is then subset to contain only the first and second columns (which are the subject IDs and activity integers respectively), plus any other columns that correspond to the integers in the **colindex**. 

## 4. Labeling the dataset

In **mergedset**, the *activity* column needed to be transformed from the numeric activity labels to a more descriptive character activity label. This was accomplished using lapply() on the respective **mergedset** column and calling the **activitymatch** function for each value in the column. This matched each activity integer value with its descriptive character representation, returning a vector of activities called **activitynames**. The *activity* column in **mergedset** was then replaced by the newly created **activitynames**.

For the other columns, the variables are unchanged from the raw data, since they are sufficiently descriptive. 

## 5. Creation of a Second Dataset of Averages of All Measures Across Activity and Subject ID

For the new dataset called **averages**, each column corresponds to a unique activity name or subject id. Each row corresponds to a factor variable. **colnames** is the variable that represents the column names, which were extracted from the respective columns of **mergedset** using the unique() function. 

The first function, **activitymatch**, takes a single activity name as input, and returns a vector of the mean for every factor variable of that activity using **mergedset**. Using a for loop, the function is applied to each activity, returning the vector of means as **colmean**. the vector **colmean** then replaces the corresponding column in **averages**. 

An identical process is followed for the subject ids, which are the remaining columns in the **averages** dataset. A seperate function **idmatch** is created to obtain the means for each factor variable for each unique id. 

The final **averages** dataframe contains the averages for each factor variable for each activity and subject id. 