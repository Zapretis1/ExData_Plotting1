## 2016-11-06 Created by Zapretis1
## 
## This R script called plot2.R does the following:
## 1) Download the data into a custom folder
## 2) Load the relevant data into R
## 3) Create a graphic plot2.png similar to the target Plot 2
## 
## Plot 2 is time series representing the values of global active power
## measurements over time

################################################
## 1) Download the data into a custom folder
################################################

## Custom parameters
data_dir_name <- "04_week1_peer_graded_assignment_zapretis1" #name of the directory to store the data
data_zip_name <- "exdata_data_household_power_consumption.zip" #name of the zip file
data_unzip_name <- "household_power_consumption.txt" #name of the unzip location
plot_name <- "plot2.png" #name of the plot

## Assign name of the URL where data can be retrieved
file_URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

## Create the destination file relative path name for the zipped and unzipped files
my_destzip <- paste(".", data_dir_name, data_zip_name, sep="/")
my_destunzip <- paste(".", data_dir_name, data_unzip_name, sep="/")
my_destplot <- paste(".", data_dir_name, plot_name, sep="/")

## Create directory to store data if directory does not exist
if(!file.exists(data_dir_name)){
    
    ## Create directory
    dir.create(data_dir_name)
    
    ## Download file if data zip file does not already exist
    download.file(file_URL, destfile = my_destzip)
    
    ## Store download date
    date_downloaded <- date()
    
    ## List files to check the downloaded file
    print(list.files(data_dir_name))
    
    ## Unzip the files in the main directory
    unzip(my_destzip, exdir = data_dir_name)
    
    ## List files to check the unzipped files
    print(list.files(my_destunzip))
    
    print("Data downloaded and unzipped with success")
    
}

################################################
## 2) Load the relevant data into R
################################################

if(!exists("epc_zapretis1")){
    
    ## Read the first line to get the header names
    epc_names <- read.csv2(my_destunzip, nrows = 1)
    
    ## Collect data from the dates 2007-02-01 and 2007-02-02 only
    epc_zapretis1 <- read.table(my_destunzip, sep= ";", skip ="66637", nrows = 2880)
    
    ## Add header names
    names(epc_zapretis1) <- names(epc_names)
    
    ## Create a new column "Measures" with the complete date and time in format
    ## "POSIXlt" "POSIXt"
    dates <- epc_zapretis1$Date
    times <- epc_zapretis1$Time
    moments <- paste(dates, times)
    measures <- strptime(moments, "%d/%m/%Y %H:%M:%S")
    epc_zapretis1$Measures <- measures
    
    print("Data loaded into R with success")
    
}

################################################
## 3) Create a graphic plot2.png similar to the target Plot 2
################################################

## Memorize time local settings
ORG_LC_TIME <- Sys.getlocale(category = "LC_TIME") #original local time setting

## Changes local time settings
Sys.setlocale(category = "LC_TIME", locale = "English_United States.1252") #set to English US for days of the week

## Open graphic device PNG
png(filename = my_destplot, width = 480, height = 480)

## Create time series with custom color and axis labels
plot(epc_zapretis1$Measures, epc_zapretis1$Global_active_power,
     type = "l",
     xlab =  "",
     ylab = "Global Active Power (kilowatts)"
     ) #plot lines, main title, labels

## Close graphic device
dev.off()

## Revert timel local settings back to original
Sys.setlocale(category = "LC_TIME", locale = ORG_LC_TIME) #back to original

print("Plot created with success")

## EOF