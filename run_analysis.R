rawDataDir <- "./rawData"
rawDataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
rawDataFilename <- "rawData.zip"
rawDataDFn <- paste(rawDataDir, "/", "rawData.zip", sep = "")
dataDir <- "./data"

if (!file.exists(rawDataDir)) {
  dir.create(rawDataDir)
  download.file(url = rawDataUrl, destfile = rawDataDFn)
}
if (!file.exists(dataDir)) {
  dir.create(dataDir)
  unzip(zipfile = rawDataDFn, exdir = dataDir)
}

activity_label <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/activity_labels.txt"),col.names = c("id", "activity"))
features <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/features.txt"),col.names = c("n","functions"))
subject_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/subject_test.txt"), col.names = "subject")
X_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/X_test.txt"), col.names = features$functions)
y_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/Y_test.txt"), col.names = "id")
subject_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/subject_train.txt"), col.names = "subject")
X_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/X_train.txt"), col.names = features$functions)
y_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/Y_train.txt"), col.names = "id")


#Step 1
X <- rbind(X_train, X_test)
Y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
df <- cbind(subject, Y, X)

#Step 2
library(dplyr)
df1 <- select(.data = df, subject, id, contains("mean"), contains("std"))

#Step 3
df1$id <- activity_label[df1$id, 2]


#Step 4
names(df1)[names(df1) == 'id'] <- 'activity'

#Step 5
result <- aggregate( . ~ activity + subject, data = df1, FUN = mean )

write.table(result, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)
