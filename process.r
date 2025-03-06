setwd("downloads/weather")

#3.2 data retrievial
  name = temp = NULL
  for(i in 2012:2022){
    temp = c(temp,list(read.table(paste0(i,"/temp.csv"),header=T,sep = ",")))
    name = c(name,paste0("y",i))
  }
  names(temp) = name
  #they are now stored in temp such that temp$y2018 contain all data of 2018
  
#3.3 data processing
  #1 we filter record that has qcscore!="G" such that all data remaining are good data
  allG_temp = NULL  
  for(i in name){
      k=NULL
      for(j in 1:length(temp[[i]][,1])){
        if(temp[[i]][j,4] !="G"){
          k=c(k,j)
        }
      }
      allG_temp = c(allG_temp,list(temp[[i]][-k,]))
  }
  names(allG_temp) = name
  
  #2 then, we delete the record of location of observation made and qcscores as they are irrelevent to the study
  for(i in name){
    allG_temp[[i]] = allG_temp[[i]][,c(-2,-4)]
    temp[[i]] = temp[[i]][,c(-2,-4)]
  }
  
  #3 then, for those records in same day, but different location, we replace those records with average value of it so it represent whole hk
  daily_temp = NULL
  for(i in name){
    per_day_temp = date = tem = NULL
      for(j in 1:length(allG_temp[[i]][,1])){
        if((is.null(date)) || (date != substring(allG_temp[[i]][j,1],1,10))){
          #per_day_temp = rbind(per_day_temp,c(date,mean(tem)))
          if(!is.null(date)|!is.null(tem)){
          per_day_temp = c(per_day_temp,date,mean(tem))}
          date = substring(allG_temp[[i]][j,1],1,10)
          tem = NULL
        }
        tem = c(tem,allG_temp[[i]][j,2])
      }
    #per_day_temp = rbind(per_day_temp,c(date,mean(tem)))
    per_day_temp = c(per_day_temp,date,mean(tem))
    per_day_temp = as.data.frame(matrix(per_day_temp,ncol=2,byrow=T))
    names(per_day_temp) = c("date","temp")
    daily_temp = c(daily_temp,list(per_day_temp))
  }
  names(daily_temp) = name
  for (i in name){daily_temp[[i]]$temp = as.numeric(daily_temp[[i]]$temp)}

  
  #4 sort temperatures at ascending and descending order 
  asc_temp = NULL
  for (i in name){asc_temp[[i]] = daily_temp[[i]][order(daily_temp[[i]]$temp),]}
  
  desc_temp = NULL
  for (i in name){desc_temp[[i]] = daily_temp[[i]][order(daily_temp[[i]]$temp,decreasing = T),]}
  
#3.4
  #standard deviation of each year:
    for(i in name){cat("sd of",i,"has value of",sd(daily_temp[[i]][,2],na.rm=T),"\n")}
    sd = NULL
    for(i in name){sd = c(sd,sd(daily_temp[[i]][,2],na.rm=T))}
    (mean(sd))
    (max(sd) - mean(sd))
  #max
    for(i in name){cat("max of",i,"has value of",max(daily_temp[[i]][,2],na.rm = T),"\n")}
    max = NULL
    for(i in name){max = c(max,max(daily_temp[[i]][,2],na.rm = T))}
    (mean(max))
    (max(max) - mean(max))
  #min
    for(i in name){cat("min of",i,"has value of",min(daily_temp[[i]][,2],na.rm = T),"\n")}
    min = NULL
    for(i in name){min = c(min,min(daily_temp[[i]][,2],na.rm = T))}
    (max(min))
    (min(min))
    (mean(min))
  #median
    for(i in name){cat("median of",i,"has value of",median(daily_temp[[i]][,2],na.rm = T),"\n")}
    med = NULL
    for(i in name){med = c(med,median(daily_temp[[i]][,2],na.rm = T))}
#3.5
    # boxplot for all years
      m = NULL
      for (i in name){
        k= data.frame(
          year = rep(i,length(daily_temp[[i]][,2])),
          temp = daily_temp[[i]][,2]
          )
        m= rbind(m,k)
      }
  jpeg("Rplot1.jpg",width = 800,height = "800")
  
  boxplot(temp~year,data=m,main="boxplot of temp vs year",ylab = "temp in celcius")
  abline(lsfit(1:11,med),col="red")
  lq = NULL
  for(i in name){lq = c(lq,quantile(daily_temp[[i]][,2],probs=0.25,na.rm = T))}
  abline(lsfit(1:11,lq),col="red") #y = -0.001681167x +19.622285958
  uq = NULL
  for(i in name){uq = c(uq,quantile(daily_temp[[i]][,2],probs=0.75,na.rm = T))}
  abline(lsfit(1:11,uq),col="red") #y= 0.01269071x +28.27869381
  abline(lsfit(1:11,max),col="red") # y = -0.09194388x + 32.39732123
  abline(lsfit(1:11,min),col="red")#y = 10.07283948 -0.07850954x
  
  mtext("max",side=4,at=31.5,las = 1,cex=0.75)
  mtext("upper\nquatile",side=4,at=28.5,las = 1,cex=0.75)
  mtext("median",side=4,at=25,las = 1,cex=0.75)
  mtext("lower\nquatile",side=4,at=19.5,las = 1,cex=0.75)
  mtext("median",side=4,at=25,las = 1,cex=0.75)
  mtext("min",side=4,at=9.5,las = 1,cex=0.75)
  
  dev.off()
