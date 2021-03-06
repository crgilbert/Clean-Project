#!/usr/bin/env Rscript
#-- start with reading in the test and train text file as tables
#    without factor coercing or whitespaces
## =============  CHECK FOR FILES (working dir)  ==============================
run_analysis <-function(){
##package requirements
  library(reshape2,plyr)
  
file_list <- c("features.txt","activity_labels.txt",
               "train/X_train.txt","train/y_train.txt","train/subject_train.txt",             
               "test/X_test.txt","test/y_test.txt","test/subject_test.txt")
#ok is true unless a file isn't located
ok=TRUE

for( i in file_list){
  if(file.exists(i)){
    cat("Found ",i,"\n")
    
  }
  else{
    cat("Can't find: ",i,"\n")
    ok = FALSE
  }
}  
  if(ok==F){
    cat("\nThis script must be run in a working directory containing the above file list.\n",
        "If you downloaded the 'UCI HAR Dataset' use >setwd('[path to UCI HAR Dataset]')")
    stop()
  }
  else{
    cat(" good to go PLEASE WAIT!")
  }
  
 

#OK load in files as tables
testtb <- read.table("./test/X_test.txt",stringsAsFactors=FALSE)
traintb <- read.table("./train/X_train.txt",stringsAsFactors=FALSE)
heads <- read.table("./features.txt",stringsAsFactors=FALSE)
#get the activity labels
actnames <- scan("./activity_labels.txt",what=list(numeric(),character()))


#strip off - ( and ) to avoid col name errors
headr <- gsub("[[:punct:]]",'',heads[ ,2])

#use the headr vector to make col names
names(testtb)<-headr
names(traintb)<-headr

#read in the test and train subject numbers
test_sublist <- scan("./test/subject_test.txt",what=numeric())
train_sublist <- scan("./train/subject_train.txt",what=numeric())

#add the subjects to the corresponding tables
testtb$subject<-test_sublist
traintb$subject<-train_sublist

# Do the same with the activity numers
test_actlist <- scan("./test/y_test.txt",what=numeric())
train_actlist <- scan("./train/y_train.txt",what=numeric())

testtb$activity=test_actlist
traintb$activity=train_actlist

#combine the tables
fulltb <- rbind(testtb,traintb)

#prepare a list of the columns we're interested in
col_list<-  c( "subject",
              "activity",
              "tBodyAccmeanX",
               "tBodyAccmeanY",
               "tBodyAccmeanZ",
               "tBodyAccstdX",
               "tBodyAccstdY",
               "tBodyAccstdZ",
               "tGravityAccmeanX",
               "tGravityAccmeanY",
               "tGravityAccmeanZ",
               "tGravityAccstdX",
               "tGravityAccstdY",
               "tGravityAccstdZ",
               "tBodyAccJerkmeanX",
               "tBodyAccJerkmeanY",
               "tBodyAccJerkmeanZ",
               "tBodyAccJerkstdX",
               "tBodyAccJerkstdY",
               "tBodyAccJerkstdZ",
               "tBodyGyromeanX",
               "tBodyGyromeanY",
               "tBodyGyromeanZ",
               "tBodyGyrostdX",
               "tBodyGyrostdY",
               "tBodyGyrostdZ",
               "tBodyGyroJerkmeanX",
               "tBodyGyroJerkmeanY",
               "tBodyGyroJerkmeanZ",
               "tBodyGyroJerkstdX",
               "tBodyGyroJerkstdY",
               "tBodyGyroJerkstdZ",
               "tBodyAccMagmean",
               "tBodyAccMagstd",
               "tGravityAccMagmean",
               "tGravityAccMagstd",
               "tBodyAccJerkMagmean",
               "tBodyAccJerkMagstd",
               "tBodyGyroMagmean",
               "tBodyGyroMagstd",
               "tBodyGyroJerkMagmean",
               "tBodyGyroJerkMagstd",
               "fBodyAccmeanX",
               "fBodyAccmeanY",
               "fBodyAccmeanZ",
               "fBodyAccstdX",
               "fBodyAccstdY",
               "fBodyAccstdZ",
               "fBodyAccmeanFreqX",
               "fBodyAccmeanFreqY",
               "fBodyAccmeanFreqZ",
               "fBodyAccJerkmeanX",
               "fBodyAccJerkmeanY",
               "fBodyAccJerkmeanZ",
               "fBodyAccJerkstdX",
               "fBodyAccJerkstdY",
               "fBodyAccJerkstdZ",
               "fBodyAccJerkmeanFreqX",
               "fBodyAccJerkmeanFreqY",
               "fBodyAccJerkmeanFreqZ",
               "fBodyGyromeanX",
               "fBodyGyromeanY",
               "fBodyGyromeanZ",
               "fBodyGyrostdX",
               "fBodyGyrostdY",
               "fBodyGyrostdZ",
               "fBodyGyromeanFreqX",
               "fBodyGyromeanFreqY",
               "fBodyGyromeanFreqZ",
               "fBodyAccMagmean",
               "fBodyAccMagstd",
               "fBodyAccMagmeanFreq",
               "fBodyBodyAccJerkMagmean",
               "fBodyBodyAccJerkMagstd",
               "fBodyBodyAccJerkMagmeanFreq",
               "fBodyBodyGyroMagmean",
               "fBodyBodyGyroMagstd",
               "fBodyBodyGyroMagmeanFreq",
               "fBodyBodyGyroJerkMagmean",
               "fBodyBodyGyroJerkMagstd",
               "fBodyBodyGyroJerkMagmeanFreq"
               
)

shorttb <- data.frame(fulltb[ ,col_list])

#list of numeric obs (we dont want the mean of text variables etc)
nobs <- col_list[3:81]

#melt the data so we have measurement types in a column
shorttb <- melt(shorttb,id.vars=(c("subject","activity")),measure.vars=nobs,
           variable.name="feature", measure.value="value")

#replace the activity indexes with the activity text
shorttb$activity_name <- actnames[[2]][shorttb$activity]

#print(shorttb) #just for checking


cdata <- ddply(shorttb, c("activity", "subject","feature"), summarize,
                mean = mean(value,na.rm=TRUE)
               )

}
#NOT using these
#angle(tBodyAccMean,gravity),
#angle(tBodyAccJerkMean),gravityMean),
#angle(tBodyGyroMean,gravityMean),
#angle(tBodyGyroJerkMean,gravityMean),
#angle(X,gravityMean),
#angle(Y,gravityMean),
#angle(Z,gravityMean),