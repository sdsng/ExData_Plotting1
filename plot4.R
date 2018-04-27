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

#--- Plot4: Made up of 4 plots (create 2x2, arrange row-wise)
#       PlotA: Plot2
#       PlotB: Voltage, day
#       PlotC: Plot3
#       PlotD: Global Reactive Power, day

par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(allsub, {
        #PlotA
        plot( allsub$Global_active_power ~ allsub$SetTime,
              type = "l", 
              ylab = "Global Active Power (kilowatts)",
              xlab = "")       
        #PlotB
        plot(allsub$Voltage~ allsub$SetTime, 
             type="l", 
             ylab="Voltage (volt)", 
             xlab="datetime")
        #PlotC
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
        legend("topright", legend=labels, col=colours, lty="solid", lwd=c(1,1,1), cex = 0.75)
        #PlotD
        plot( allsub$Global_reactive_power ~ allsub$SetTime,
              type = "l", 
              ylab = "Global Reactive Power (kilowatts)",
              xlab = "datetime") 
}
)

dev.copy(png,'plot4.png', width = 480, height = 480)
dev.off()
