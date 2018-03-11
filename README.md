# BusinessDuration
R code that calculates business duration between two dates by excluding weekends, public holidays and non-business hours in days, hours, minutes and seconds

# Example 1
```R
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