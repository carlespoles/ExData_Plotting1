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
# Check the variable type for each column => ATTENTION!! columns Date and Time are factor.
sapply(fileData, class)


# For this plot we will need variable Time, also factor type, to be converted to real time.
# For this plot, we need to combine Date and Time columns to produce a day of the week.
fileData$Time <- strptime(paste(fileData$Date, fileData$Time), "%d/%m/%Y %H:%M:%S")

# Since column Date is a factor, it needs to be converted 1st to character, then to Date.
# Finally, VERY IMPORTANT, the format of the as.Date function must be as specified below OR
# Date will result in NA.
# IMPORTANT => CONVERT Date column to Date AFTER converting Time column to Date (refer to previous step).
fileData$Date <- as.Date(as.character(fileData$Date), format = "%d/%m/%Y")

# We subset the data according with the dates required.
selectedData <- subset(fileData, fileData$Date == as.Date("2007-02-01") | fileData$Date == as.Date("2007-02-02"))

# In this case, we create the png file 1st, because if we use:
# dev.copy(png, "plot3.png", width = 480, height = 480)
# at the end, the image will show the legend chopped.

# Saving as PNG. It will be saved in default working directory.
png("plot3.png", width = 480, height = 480)

# Sub_metering variables are already numeric.
# We need to create a plot with 3 variables!!
# We 1st create the initial plot.
plot(selectedData$Time, selectedData$Sub_metering_1, xlab = "", ylab = "Energy sub metering", type = "l", col = "#000000")
# Subsequent variables are added to the plot using lines().
lines(selectedData$Time, selectedData$Sub_metering_2, type = "l", col = "#ff6000")
lines(selectedData$Time, selectedData$Sub_metering_3, type = "l", col = "#0099ff")

# Adding the legend:
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd=2, col=c("#000000", "#ff6000", "#0099ff"))

dev.off()


