#Libraries:
library(data.table)

# # # # # # # # #
# Goal One
# # # # # # # # #

#File paths for all of the files.
DIR="X:/Getting and Cleaning Data/UCI HAR Dataset/"

#Create Test dataset
X=             fread(paste0(DIR,"test/X_test.txt"         ))
Y=             fread(paste0(DIR,"test/Y_test.txt"         ))
Subject=       fread(paste0(DIR,"test/subject_test.txt"   ))
Test=cbind(Subject,Y,X)
rm(Subject,Y,X)

#Create Train dataset
X=             fread(paste0(DIR,"train/X_train.txt"       ))
Y=             fread(paste0(DIR,"train/Y_train.txt"       ))
Subject=       fread(paste0(DIR,"train/subject_train.txt" ))
Train=cbind(Subject,Y,X)
rm(Subject,Y,X)

#Combine the Test and Train data
Data=rbind(Test,Train)
rm(Test,Train)

#Load Features into a Data.Table
features=      fread(paste0(DIR,"features.txt"            ))
features$V2=sub(  "BodyBody","Body"            ,features$V2, fixed=TRUE)
features$V2=sub(  "Body"    ,"Body "           ,features$V2, fixed=TRUE)
features$V2=sub(  "Gyro"    ,"Gyroscope "      ,features$V2, fixed=TRUE)
features$V2=sub(  "Jerk"    ,"Jerk "           ,features$V2, fixed=TRUE)
features$V2=sub(  "Freq"    ,"Frequency "      ,features$V2, fixed=TRUE)
features$V2=sub(  "f"       ,"Frequency "      ,features$V2, fixed=TRUE)
features$V2=sub(  "t"       ,"Time "           ,features$V2, fixed=TRUE)
features$V2=sub(  "Mag"     ,"Magnitude "      ,features$V2, fixed=TRUE)
features$V2=sub(  "Acc"     ,"Accelerometer "  ,features$V2, fixed=TRUE)
features$V2=sub(  "Gravity" ,"Gravity "        ,features$V2, fixed=TRUE)
features$V2=sub(  "mean"    ,"Mean "           ,features$V2, fixed=TRUE)
features$V2=sub(  "std"     ,"STD "            ,features$V2, fixed=TRUE)
features$V2=sub(  "angle"   ,"Angle "          ,features$V2, fixed=TRUE)
features$V2=sub(  "gravity" ,"Gravity "        ,features$V2, fixed=TRUE)
features$V2=gsub( ")"       ,""                ,features$V2, fixed=TRUE)
features$V2=gsub( "("       ,""                ,features$V2, fixed=TRUE)
features$V2=gsub( "-"       ,""                ,features$V2, fixed=TRUE)
features$V2=gsub( ","       ," "               ,features$V2, fixed=TRUE)

#Make Activity a factor, with new labels from activity_label
activity_label=fread(paste0(DIR,"activity_labels.txt"     ))

# # # # # # # # #
# Goal Four
# # # # # # # # #
###Yes I know this is not in order, thanks.

#Change column names to represent their data
colnames(Data)=c("Subject", "Activity", features$V2)

# # # # # # # # #
# Goal Two
# # # # # # # # #
#Keep only Mean and Standard deviation of each measurement

#vector of TRUE/FALSE if it has mean or std in the measurement
KeepColumns=grepl("Mean",features$V2) | grepl("STD",features$V2)

#Keep the first two columns, and columns that had mean or std
#Which is used to convert TRUE FALSE into the positions on the vector that have TRUE
#+2 is used because features data.table doesn't include the first two columns
Data=Data[,c(1,2,which(KeepColumns==TRUE)+2),with=FALSE]

# # # # # # # # #
# Goal Three
# # # # # # # # #

#Make Activity a factor, so the levels can be replaced with the names in activity labels
Data$Activity=as.factor(Data$Activity)
levels(Data$Activity)=activity_label$V2

# # # # # # # # #
# Goal Five
# # # # # # # # #
#Create another dataset, containing average calue for each variable within an activity and subject
TinyData=aggregate(Data[,3:ncol(Data),with=FALSE],
                   by=list("Subject"=Data$Subject,"Activity"=Data$Activity),
                   FUN=mean)

#For organization.. sort rows by subject and activity like TinyData is
#not necessary..it just bothers me.
Data=Data[order(Data$Subject,Data$Activity),]
