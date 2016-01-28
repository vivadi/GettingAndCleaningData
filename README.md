# GettingAndCleaningData
This shouldn't seriously require more explination than the comments in the code itself, but okay:

Goal 1:
Load the datasets from the directory they are in, combining the columns from subject, activity (y), and the many features recorded (x). After you combine Test data and Train data in the same way, combine the two on top of one another (using rbind). While you are busy loading everything, you may as well load the activity labels and features files.

Goal 4:
Since changing the column names is easy at this point, change them into Subject, Activity, and the list of features names. 

Goal 2:
To keep only the mean and standard deviation measurements, I grepl'd to find the features that had "mean" or "std" in the name. This was placed in a logical vector (T/F only). I replaced the dataset with the same dataset containing only the first 2 columns, as well as the columns that have "mean" or "std" as described in the logical vector.

Goal 3:
Make the activity column into a factor, then replace the factor 1 through 6 into the 6 activities described in activity labels file.

Goal 5:
This is clearly a job for aggregate since we want to do a function for each unique subject and activity value. Aggregate all of the other data by subject and activity. Note that aggregate will place the by columns at the front of the data set calculated on, so it will look exactly the same as long as we name our by variables the same way.

Goal 6:
Order the first dataset to have the same order as the tiny data set, which is by subject and activity, the by variables. This is actually not a class goal, but it looks better this way. 
