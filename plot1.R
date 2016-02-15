## Downloading the dataset
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url,destfile="elecpow.zip",method="curl")
unzip("elecpow.zip",exdir="./elecpow")
## sql query to replace ? with null and extract data only for two days
## ideas obtained from discussion forum
sqll <- 'select
case
when Date = "?" then null
else Date
end as Date,
case
when Time = "?" then null
else Time
end as Time,
case
when Global_active_power = "?" then null
else Global_active_power
end as Global_active_power,
case
when Global_reactive_power = "?" then null
else Global_reactive_power
end as Global_reactive_power,
case
when Voltage = "?" then null
else Voltage
end as Voltage,
case
when Global_intensity = "?" then null
else Global_intensity
end as Global_intensity,
case
when Sub_metering_1 = "?" then null
else Sub_metering_1
end as Sub_metering_1,
case
when Sub_metering_2 = "?" then null
else Sub_metering_2
end as Sub_metering_2,
case
when Sub_metering_3 = "?" then null
else Sub_metering_3
end as Sub_metering_3 from file where "Date" in ("1/2/2007", "2/2/2007")'

## read data from file by means of an sql query
## requires sqldf package
install.packages("sqldf")
library(sqldf)

elecpow <- read.csv2.sql(file = "./elecpow/household_power_consumption.txt",
                         sql = sqll, colClasses = c("character","character","numeric","numeric","numeric","numeric",
                                                    "numeric","numeric","numeric"))
closeAllConnections()

## creates a new column for dates with time
elecpow$Date_Time <- as.POSIXct(strptime(paste(elecpow[,1],elecpow[,2]),"%d/%m/%Y %H:%M:%S"))

## plots
png(filename="plot1.png",width = 480, height = 480, units = "px")
## histogram
hist(elecpow$Global_active_power,col="red",xlab="Global Active Power (kilowatts)",main="Global Active Power")
dev.off()