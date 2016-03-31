# set working directory to Desktop
setwd('~/Desktop')

# open required packages
library(data.table)
library(lubridate)

# sources data folder
if (!file.exists('source data')) {
        dir.create('source data')
}

# check to see if the existing tidy data set exists. If it doesn't make a new data set
if (!file.exists('source data/power_consumption.txt')) {

        # download the zip file and unzip
        file.url<-'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
        download.file(file.url,destfile='source data/power_consumption.zip')
        unzip('source data/power_consumption.zip',exdir='source data',overwrite=TRUE)

        # limit the raw data to 2 days
        variable.class<-c(rep('character',2),rep('numeric',7))
        power.consumption<-read.table('source data/household_power_consumption.txt',header=TRUE,
                                      sep=';',na.strings='?',colClasses=variable.class)
        power.consumption<-power.consumption[power.consumption$Date=='1/2/2007' | power.consumption$Date=='2/2/2007',]

        # clean up the variable names and convert date/time fields
        cols<-c('Date','Time','GlobalActivePower','GlobalReactivePower','Voltage','GlobalIntensity',
                'SubMetering1','SubMetering2','SubMetering3')
        colnames(power.consumption)<-cols
        power.consumption$DateTime<-dmy(power.consumption$Date)+hms(power.consumption$Time)
        power.consumption<-power.consumption[,c(10,3:9)]

        # write a clean data set to the directory
        write.table(power.consumption,file='source data/power_consumption.txt',sep='|',row.names=FALSE)
} else {

        power.consumption<-read.table('source data/power_consumption.txt',header=TRUE,sep='|')
        power.consumption$DateTime<-as.POSIXlt(power.consumption$DateTime)

}

# remove raw data set
if (file.exists('source data/household_power_consumption.txt')) {
        x<-file.remove('source data/household_power_consumption.txt')
}

