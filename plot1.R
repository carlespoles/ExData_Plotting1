setwd("C:\\Users\\Carles\\Documents\\R_data_sets")

library(httr)
# Below library is used to unzip later the file to be downloaded.
library(downloader)
# plyr library will be required for later file/data processing.
library(plyr)
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fileZIP <- "dataSetUCI.zip"
download.file(fileURL, destfile = paste(".\\", fileZIP, sep = ""), method = "curl")

# Once file is unzipped, it will appear in the working directory as 'household_power_consumption.txt'.
fileName <- unzip(fileZIP, list = FALSE, overwrite = TRUE, exdir = getwd())

# IMPORTANT => missing values are coded as ?.
fileData <- read.table(fileName, header = TRUE, sep = ";", na = "?")

# Check how data looks like: dates are in format dd/mm/yyyy.
head(fileData)
# Check the variable type for each column => ATTENTION!! column Date is a factor.
sapply(fileData, class)

# Since column Date is a factor, it needs to be converted 1st to character, then to Date.
# Finally, VERY IMPORTANT, the format of the as.Date function must be as specified below OR
# Date will result in NA.

fileData$Date <- as.Date(as.character(fileData$Date), format = "%d/%m/%Y")

# We subset the data according with the dates required.
selectedData <- subset(fileData, fileData$Date == as.Date("2007-02-01") | fileData$Date == as.Date("2007-02-02"))

# Setting margins for the plot.
par(mar=c(5.1,6.1,4.1,2.1))

# IMPORTANT => variable Global_active_power is factor type, so it needs to be converted to
# numeric type in order to produce as histogram.
hist(as.numeric(selectedData$Global_active_power), main = "Global Active Power", xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col = "#ff6000")

# Saving as PNG. It will be saved in default working directory.
dev.copy(png, "plot1.png", width = 480, height = 480)
dev.off()


