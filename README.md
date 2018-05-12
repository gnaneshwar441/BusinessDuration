# BusinessDuration
R code that calculates business duration between two dates by excluding weekends, public holidays and non-business hours in days, hours, minutes and seconds

# Example 1
```R
library(BusinessDuration)

#start date must be in R format
startdate = strptime(x = "2017-07-01 02:02:00",format = "%Y-%m-%d %H:%M:%S")

#End date must be in R format
enddate = strptime(x = "2017-07-07 04:48:00",format = "%Y-%m-%d %H:%M:%S")

#Business Start Hour
starttime = "07:00:00"

#Business End Hour
endtime = "17:00:00"

#Public holiday list
holidaylist = as.Date(c("2017-01-01" ,"2017-01-02", "2017-01-16", "2017-02-15", "2017-02-20", "2017-03-31", "2017-05-29", "2017-07-04", "2017-09-04", "2017-10-09", "2017-11-10", "2017-11-11", "2017-11-23" ,"2017-12-25"))

#Unit of duration
unit="day"

#Calling the function
businessDuration(startdate = startdate,enddate = enddate,starttime = starttime,endtime = endtime,holidaylist = holidaylist,unit = unit)
```

# Example 2
```R
library(BusinessDuration)

#start date must be in R format
startdate = strptime('2017-12-26 02:02:00',format = "%Y-%m-%d")

#End date must be in R format
enddate = strptime('2017-12-30 16:48:00',format = "%Y-%m-%d")

#Business Start Hour
starttime="21:00:00"

#Business End Hour
endtime="03:00:00"

#Public holiday list
holidaylist = as.Date(c("2017-01-01" ,"2017-01-02", "2017-01-16", "2017-02-15", "2017-02-20", "2017-03-31", "2017-05-29", "2017-07-04", "2017-09-04", "2017-10-09", "2017-11-10", "2017-11-11", "2017-11-23" ,"2017-12-25"))

#Unit of duration
unit="day"

#Calling the function
businessDuration(startdate = startdate,enddate = enddate,starttime = starttime,endtime = endtime,holidaylist = holidaylist,unit = unit)
```

# Example 3
```R
library(BusinessDuration)

#Reading the file as dataframe
inputdata<-read.csv('Sample.csv')

#Converting to standard R datetime format
inputdata$sys_created_on <- strptime(x = inputdata$sys_created_on,format = "%m/%d/%Y %H:%M")
inputdata$resolved_at <- strptime(x = inputdata$resolved_at,format = "%m/%d/%Y %H:%M")

#Business open time
starttime<-"08:00:00"

#Business close time
endtime<-"17:00:00"

#Weekend list
weekend_list<-c("Saturday","Sunday")

#Custom US holidays
US_holiday_list <- as.Date(c("2018-01-01","2018-05-28","2018-07-04","2018-09-03","2018-11-22","2018-12-25"))

#Business duration - day, hour, min, sec
unit_hour <- "hour"

#Apply function to entire dataframe
inputdata$Biz_Hour <- lapply(1:nrow(inputdata),function(x){businessDuration(startdate = inputdata$sys_created_on[x],enddate = inputdata$resolved_at[x],starttime = starttime,endtime = endtime,weekendlist = weekend_list,holidaylist = US_holiday_list,unit = unit_hour)})

```