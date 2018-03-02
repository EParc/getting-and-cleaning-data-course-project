run_analysis <- function() {
  
  #load all required packages
  library("stringr");
  library("dplyr");
  library("qdap");
  
  #Load both data sets and clean them
  test_data <- load_data("test");
  train_data <- load_data("train");
  
  #Combind the data sets
  all_data <- rbind(test_data, train_data);
  
  #Read in feature names and set them  
  features <- read.csv("./features.txt",
                       sep=" ",
                       header = FALSE,
                       stringsAsFactors=FALSE);
  
  features_df <- tbl_df(features);
  #Select all mean() and std() column names
  wanted <- filter(features_df, str_detect(V2, "mean()") == TRUE | str_detect(V2, "std()") == TRUE)
  
  #Set the column names so that they can be selected
  colnames(all_data) <- c("subject_no", "activity", 1:561);
  
  #Select only the columns which we choose earlier
  all_data <- select(all_data, 'subject_no', 'activity', wanted$V1+2);
  
  #Set the column names
  colnames(all_data) <- c('subject_no', 'activity', unlist(wanted$V2));
  
  #read in the activity labels
  activity_labels <- read.csv("./activity_labels.txt",sep=" ",header = FALSE, stringsAsFactors=FALSE);
  
  #set the activity labels
  for(number in activity_labels[,1]){
    if(!is.null(all_data[all_data$activity == as.character(number),]$activity)){
      all_data[all_data$activity == as.character(number),]$activity = activity_labels$V2[number];
    }
  }
  
  #group the data by subject number and activity
  #then summarise the other columns by mean or average
  summarised <- all_data %>%
    group_by(subject_no, activity) %>%
    summarise_at(unlist(wanted$V2), funs(mean));
  
  #write the tidy data out in the specified format
  write.table(summarised, "tidy_smartphone_sensor_data.txt", row.names=FALSE);
}

#Load all data and column bind it
load_data <- function(data_type){
  
  lines <- readLines(
     paste("./",data_type,"/X_",data_type,".txt", sep = ""));
  
  #remove double spacing in lines
  cleaned_lines<- str_trim(clean(lines));
  
  #now that the data has been cleaned read it again
  data <- read.csv(text = cleaned_lines, sep = " ", header = FALSE, stringsAsFactors=FALSE);
  
  y <- read.csv(paste("./",data_type,"/y_",data_type,".txt", sep =""),
     sep=" ",
     header = FALSE,
     stringsAsFactors=FALSE);
  
  subject <- read.csv(
     paste("./",data_type,"/subject_",data_type,".txt", sep = ""),
     sep=" ", header = FALSE);
  
  #combine all the data
  sub_y <- cbind(subject, y);
  data <- cbind(sub_y, data);
  
  return(data);
}