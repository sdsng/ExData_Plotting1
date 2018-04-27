#--- Download dataset from url
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, "Household Power Consumption.zip")
unzip("Household Power Consumption.zip", exdir = "Household Power Consumption")

#--- Open PA3 unzipped file in Rstudio Files Pane, set location as wd 
setwd("~/Household Power Consumption")

#--- For input Date=dmY and Time HMS: Combine for "DateTime" present as.Date
library(data.table)
allData <- read.table("household_power_consumption.txt", header=T, sep=";", na.strings="?")

#--- Read data.table function for only those 2 dates 2007-02-01 and 2007-02-02 
#--- Rename this as subsetted to set time variable
subsetted <- allData[allData$Date %in% c("1/2/2007","2/2/2007"),]
SetTime <-strptime(paste(subsetted$Date, subsetted$Time, sep=" "),"%d/%m/%Y %H:%M:%S")
subsetted <- cbind(SetTime, subsetted)

## Remove incomplete observation
allsub <- subsetted[complete.cases(subsetted),]

#--- Name the new vector
dateTime <- paste(allsub$Date, allsub$Time)
dateTime <- setNames(dateTime, "DateTime")

#--- Plot3: Baseplot -> Energy sub metering, day (show all 3)
library(datasets)

plot(allsub$SetTime, allsub$Sub_metering_1, 
     type ="l", 
     col = "black", 
     xlab ="", 
     ylab ="Energy sub metering")
lines(allsub$SetTime, allsub$Sub_metering_2, 
      col = "red")
lines(allsub$SetTime, allsub$Sub_metering_3, 
      col = "blue")

colours <- c("black", "red", "blue")
labels <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
legend("topright", legend=labels, col=colours, lty="solid", lwd=c(1,1,1))

dev.copy(png,'plot3.png', width = 480, height = 480)
dev.off()
