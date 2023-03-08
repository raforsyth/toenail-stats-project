library(plotly)
col_names= c('observation_number','treatment_group','subject_id_number','time', 'response')
toenail<-read.table("data/toenail3.txt", header=T, sep='', col.names = col_names)
toenail$treatment_group<-ifelse(toenail$treatment_group==0,"Intraconazol","Lamisil")
data_mean <- ddply(toenail, c("treatment_group", "time"), summarise, length = mean(response))
data_sd <- ddply(toenail, c("treatment_group", "time"), summarise, length = sd(response))
data <- data.frame(data_mean, data_sd$length)
data <- rename(data, c("data_sd.length" = "sd"))
data$time <- as.factor(data$time)
fig<- plot_ly(data = data[which(data$treatment_group == 'Intraconazol'),],
              color = ~treatment_group,colors = c("orange","lightblue"),
              opacity=0.9,
              marker= list(line = list(color = "black",width =1)),
              x =~time, y = ~length,type = "scatter",mode = 'lines+markers',
              name = 'Intraconazol',
              error_y = ~list(array=sd,color = data$treatment_group))%>%
  add_trace(data = data[which(data$treatment_group=='Lamisil'),],name = 'Lamisil',
            color = ~treatment_group,colors = c("orange","lightblue"),
            opacity = 0.9,
            marker= list(line = list(color = "black",width =0.5)))%>%
  layout(title ="<b>Mean Evolution by Treatment<b>", 
         yaxis=list(title= "Unaffected Toenail Growth (mm)"),
         xaxis=list(title = "Time (months)"),
         legend = list(title = list(text="<b>Treatment<b>")),
         hoverlabel = list(bgcolor="white"))
fig