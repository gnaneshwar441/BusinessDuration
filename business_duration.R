businessDuration <- function(startdate="",enddate="",starttime=NA,endtime=NA,weekendlist=c("Saturday","Sunday"),holidaylist=c(),unit='min'){
  library(chron)
  result <- class(startdate)
  if(!result[1] %in% c("POSIXlt","POSIXct")){
    return("startdate must be in POSIXlt/POSIXct format")
  }
  result <- class(enddate)
  if(!result[1] %in% c("POSIXlt","POSIXct")){
    return("enddate must be in POSIXlt/POSIXct format")
  }
  if(is.na(startdate)){
    return(NA)
  }
  if(is.na(enddate)){
    return(NA)
  }
  if(startdate > enddate){
    return(NA)
  }
  if(!is.na(starttime) && !is.na(endtime)){ #Business start & end time supplied
    result <- try(expr = times(starttime),silent = TRUE)
    if(class(result)=="try-error"){
      return("format must be in hh:mm:ss")
    }else{
      starttime <- times(starttime)
    }
    result <- try(expr = times(endtime),silent = TRUE)
    if(class(result)=="try-error"){
      return("format must be in hh:mm:ss")
    }else{
      endtime <- times(endtime)
    }  
  }else if((!is.na(starttime) & is.na(endtime)) || (is.na(starttime) & !is.na(endtime))){
    return(NA) #Either Business start/end time is supplied but not both
  }else{ #Both Business start & end time are not supplied-NA
    
  }
  #Creating sequence of days
  working_days <- seq(from = as.Date(startdate),to = as.Date(enddate),by = "day")
  #Removing weekends
  working_days <- working_days[!(weekdays(working_days) %in% weekendlist)]
  #Removing Public Holidays
  if(length(holidaylist)!=0){
    working_days <- working_days[!working_days %in% holidaylist]  
  }
  
  #No. of working days
  len_working_days <- length(working_days)
  if(len_working_days == 0){
    return(NA)
  }else if(len_working_days == 1){ #1 working day
    if(!as.Date(startdate) %in% working_days){
      startdate <- strptime(paste(working_days[1],times("00:00:00")),format = "%Y-%m-%d %H:%M:%S")
    }
    if(!as.Date(enddate) %in% working_days){
      enddate <- strptime(paste(working_days[1],times("23:59:59")),format = "%Y-%m-%d %H:%M:%S")
    }
    startdatetime=times(strftime(x = startdate,format = "%H:%M:%S"))
    enddatetime=times(strftime(x = enddate,format = "%H:%M:%S"))
    if(starttime<=endtime){# Eg. 9AM - 6PM
      if(startdatetime < starttime){
        open_time <- starttime
      }else if(startdatetime >= starttime && startdatetime <= endtime){
        open_time <- startdatetime
      }else{
        # open_time <- times("00:00:00")
        return(NA)
      }
      if(enddatetime < starttime){
        # close_time <- times("00:00:00")
        return(NA)
      }else if(enddatetime >= starttime && enddatetime <= endtime){
        close_time <- enddatetime 
      }else{
        close_time <- endtime
      }
    }else{# Eg. 9PM - 3AM
      midnight_time <- times("23:59:59")
      if(startdatetime < starttime){
        open_time <- starttime
        close_time <- midnight_time
      }else{
        open_time <- startdatetime
        close_time <- midnight_time
      }
    }
    add_seconds <- ((hours(close_time)*60*60)+(minutes(close_time)*60)+seconds(close_time)) - ((hours(open_time)*60*60)+(minutes(open_time)*60)+seconds(open_time))
    
  }else if(len_working_days == 2){ #2 working day
    if(!as.Date(startdate) %in% working_days){
      startdate <- strptime(paste(working_days[1],times("00:00:00")),format = "%Y-%m-%d %H:%M:%S")
    }
    if(!as.Date(enddate) %in% working_days){
      enddate <- strptime(paste(working_days[len_working_days],times("23:59:59")),format = "%Y-%m-%d %H:%M:%S")
    }
    startdatetime=times(strftime(x = startdate,format = "%H:%M:%S"))
    enddatetime=times(strftime(x = enddate,format = "%H:%M:%S"))
    add_seconds <- 0
    if(starttime <= endtime){# Eg. 9AM - 6PM
      if(startdatetime<starttime){
        open_time <- starttime
        close_time <- endtime
      }else if(startdatetime >= starttime && startdatetime <= endtime){
        open_time <- startdatetime
        close_time <- endtime
      }else{
        open_time <- times("00:00:00")
        close_time <- times("00:00:00")
      }
      add_seconds <- add_seconds + ((hours(close_time)*60*60)+(minutes(close_time)*60)+seconds(close_time)) - ((hours(open_time)*60*60)+(minutes(open_time)*60)+seconds(open_time))
      #Calculating Closing day time in seconds
      if(enddatetime < starttime){
        open_time <- times("00:00:00")
        close_time <- times("00:00:00")
      }else if(enddatetime >= starttime && enddatetime <= endtime){
        open_time <- starttime
        close_time <- enddatetime
      }else{
        open_time <- starttime
        close_time <- endtime
      }
      add_seconds <- add_seconds + ((hours(close_time)*60*60)+(minutes(close_time)*60)+seconds(close_time)) - ((hours(open_time)*60*60)+(minutes(open_time)*60)+seconds(open_time))
    }else{ #Eg. 9PM - 3AM
      #Calculating starting day time in seconds
      midnight_time <- times("23:59:59")
      if(startdatetime < starttime){
        open_time <- starttime
        close_time <- midnight_time
      }else{
        open_time <- startdatetime
        close_time <- midnight_time
      }
      add_seconds <- add_seconds + ((hours(close_time)*60*60)+(minutes(close_time)*60)+seconds(close_time)) - ((hours(open_time)*60*60)+(minutes(open_time)*60)+seconds(open_time))
      #Calculate Closing day time in seconds
      if(enddatetime <= endtime){
        open_time <- times("00:00:00")
        close_time <- enddatetime
      }else{
        open_time <- times("00:00:00")
        close_time <- endtime
      }
      add_seconds <- add_seconds + ((hours(close_time)*60*60)+(minutes(close_time)*60)+seconds(close_time)) - ((hours(open_time)*60*60)+(minutes(open_time)*60)+seconds(open_time))      
    }
  }else{ #more than 2 working day
    add_seconds = 0
    if(!as.Date(startdate) %in% working_days){
      startdate <- strptime(paste(working_days[1],times("00:00:00")),format = "%Y-%m-%d %H:%M:%S")
    }
    if(!as.Date(enddate) %in% working_days){
      enddate <- strptime(paste(working_days[len_working_days],times("23:59:59")),format = "%Y-%m-%d %H:%M:%S")
    }
    startdatetime=times(strftime(x = startdate,format = "%H:%M:%S"))
    enddatetime=times(strftime(x = enddate,format = "%H:%M:%S"))
    in_between_days <- len_working_days-2
    if(starttime <= endtime){ #Eg. 9AM - 6PM
      #Calculate Starting day time in seconds
      if(startdatetime < starttime){
        open_time <- starttime
        close_time <- endtime
      }else if(startdatetime >= starttime && startdatetime <= endtime){
        open_time <- startdatetime
        close_time <- endtime
      }else{
        open_time <- times("00:00:00")
        close_time <- times("00:00:00")
      }
      add_seconds <- add_seconds + ((hours(close_time)*60*60)+(minutes(close_time)*60)+seconds(close_time)) - ((hours(open_time)*60*60)+(minutes(open_time)*60)+seconds(open_time))
      #Calculate Closing day time in seconds
      if(enddatetime < starttime){
        open_time <- times("00:00:00")
        close_time <- times("00:00:00")
      }else if(enddatetime >= starttime && enddatetime <= endtime){
        open_time <- starttime
        close_time <- enddatetime
      }else{
        open_time <- starttime
        close_time <- endtime
      }
      add_seconds <- add_seconds + ((hours(close_time)*60*60)+(minutes(close_time)*60)+seconds(close_time)) - ((hours(open_time)*60*60)+(minutes(open_time)*60)+seconds(open_time))
      #Calculate in between days in seconds
      in_between_days_seconds <- in_between_days*(((hours(endtime)*60*60)+(minutes(endtime)*60)+seconds(endtime)) - ((hours(starttime)*60*60)+(minutes(starttime)*60)+seconds(starttime)))
      add_seconds <- add_seconds + in_between_days_seconds
    }else{ #Eg. 9PM - 3AM
      #Calculate Starting day time in seconds
      midnight_time <- times("23:59:59")
      if(startdatetime < starttime){
        open_time <- starttime
        close_time <- midnight_time
      }else{
        open_time <- startdatetime
        close_time <- midnight_time
      }
      add_seconds <- add_seconds + ((hours(close_time)*60*60)+(minutes(close_time)*60)+seconds(close_time)) - ((hours(open_time)*60*60)+(minutes(open_time)*60)+seconds(open_time))
      #Calculate Closing  day time in seconds
      if(enddatetime <= endtime){
        open_time <- times("00:00:00")
        close_time <- enddatetime
      }else{
        open_time <- times("00:00:00")
        close_time <- endtime
      }
      add_seconds <- add_seconds + ((hours(close_time)*60*60)+(minutes(close_time)*60)+seconds(close_time)) - ((hours(open_time)*60*60)+(minutes(open_time)*60)+seconds(open_time))
      #Calculating business hours between days in seconds
      half1 <- ((hours(midnight_time)*60*60)+(minutes(midnight_time)*60)+seconds(midnight_time)) - ((hours(starttime)*60*60)+(minutes(starttime)*60)+seconds(starttime))
      half2 <- ((hours(close_time)*60*60)+(minutes(close_time)*60)+seconds(close_time))
      in_between_days_seconds <- in_between_days*(half1+half2)
      add_seconds <- add_seconds + in_between_days_seconds
    }
  }
  if(unit == "sec"){
    bd = add_seconds
  }else if(unit == "min"){
    bd = add_seconds/60
  }else if(unit=="hour"){
    bd = (add_seconds/60)/60
  }else if(unit=="day"){
    bd = ((add_seconds/60)/60)/24
  }else{
    bd <- NA
  }
  return(bd)
}