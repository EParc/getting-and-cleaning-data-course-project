README for getting and cleaning data course project
===================================================

The script starts by loading all required libraries, we then load the data-sets from both folders one after the other.
I have created a function to load the data in called "load data" this means that the process can easily be repeated for both test data sets.
The function reads in the "X_" data set first, the script then removes all double spacing to clean the data before reading the result in using read.csv.
The data is then read in all other required data and combine it.
One the process has been repeated for both data sets the two data sets are combined.

The script then reads in the features names and then users a filter to select only the columns which include the mean() and std() as requested by the assesment.
Next the script sets column names so that they can be used the selected columns to choose only the columns which are required.
Once the required columns have been selected the column names can be set.

Next the activity labels are read in and used in a for loop to set the activty names for all columns.

Then the data is grouped by subject and activity before being summarised by all the other columns using the mean function which will give the average as requested.

Finally the data is writen to a txt file as requested by the assignment.