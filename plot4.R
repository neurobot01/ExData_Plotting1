### Header--common to all plotting scripts

# Making use of the fact that ";" is the separator character, load in the first line

init <- read.table('household_power_consumption.txt', header=T, sep=";", nrows=1, stringsAsFactors=F)

# Now, use the fact that we want to use every observation from 02/01/2007--02/02/2007
# Remember, midnight (00:00:00) belongs to the new day; steps are in 1 minute increments
# So, the number of lines between the first date/time and "2007-02-01 00:00:00" gives offset

startDate <- strptime(paste(init$Date, init$Time, sep=" "), format="%d/%m/%Y %T", tz="")
targetDate <- as.POSIXlt("2007-02-01 00:00:00", tz="")
diffTime <- difftime(targetDate, startDate, units="mins")
offset <- as.numeric(diffTime)
skipLines <- offset+1 # Must skip header line too

numLines <- 24*60*2 # Two days' worth of data

data <- read.table('household_power_consumption.txt', header=F, col.names=names(init), sep=";", skip=skipLines, nrows=numLines, stringsAsFactors=F)

### plot4.R

timeObj <- strptime(paste(data$Date, data$Time, sep=" "), format="%d/%m/%Y %T", tz="")

png('plot4.png')
par(mfrow=c(2,2))
# subplot 1
plot(timeObj, data$Global_active_power, type="l", xlab="", ylab="Global Active Power")
# subplot 2
plot(timeObj, data$Voltage, type="l", xlab="datetime", ylab="Voltage")
# subplot 3
plot(timeObj, data$Sub_metering_1, col="black", type="l", xlab="", ylab="Energy sub metering")
par(new=T)
lines(timeObj, data$Sub_metering_2, col="red")
lines(timeObj, data$Sub_metering_3, col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lty=1, bty="n")
par(new=F)
# subplot 4
plot(timeObj, data$Global_reactive_power, xlab="datetime", ylab="Global_reactive_power", type="l")
dev.off()