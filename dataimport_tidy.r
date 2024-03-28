#library function loads all packages, assuming they've already been downloaded
library(tidyr)
library(readxl)
library(dplyr)
library(stringr)
library(writexl)
library(googledrive)

#set directory
setwd("/Users/markrandyreid/Library/Mobile Documents/com~apple~CloudDocs/Data")

#assign variable to read excel file
random_df = read_excel("/Users/markrandyreid/Library/Mobile Documents/com~apple~CloudDocs/Data/random_df.xlsx")

#view dataframe
View(random_df)

#start manipulatting the dataframe to "tidy" the dataset
#aggregate years in one column and associated values in another
random_df.v1 = pivot_longer(midterm_data, cols = starts_with("2"),
                             names_to = "year", values_to = "value")

#view new manipulated dataframe
View(random_df.v1)

#seperate measure column elements into columns for each element with quantitative elements from values column
random_df.v2 = pivot_wider(random_df.v1, names_from = "measure",
                            values_from = "value")

#view new manipulated dataframe 
View(random_df.v2)

#seperate or spread country/state into seperate fields
split_only_county_state = str_split(random_df.v2$State_County_Name,',')

#add the extra separated out County/State fields to the data frame:
random_df.v2$State = sapply(split_county_state, '[[', 2)
random_df.v2$County = sapply(split_county_state, '[[', 1)

#view new manipulated dataframe 
View(midterm_data_v2)

#reorder columns in the dataframe
random_df.v3 = random_df.v2[, c(1,2,3,7,8,4,5,6)]

#view new order
View(random_df.v3)

#assignment requirement
#write name to new column
random_df.v3 = random_df.v2 %>% mutate(Student = 'Mark Reid')

#view manupulated dataeframe
View(random_df.v2)

#write new file to excel
write_xlsx(random_df.v3,"/Users/markrandyreid/Library/Mobile Documents/com~apple~CloudDocs/Data/random_df.v2.xlsx")

#ADDITIONAL WORK
#remove aggregated county/state column
#variety of builtin methods and library methods can be used here
#note positive index isolates column and negative index removes column from df
random_df.v4 = random_df.v3[ ,-2]

#view manupulated dataeframe
View(random_df.v4)
