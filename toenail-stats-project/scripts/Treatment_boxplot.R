library(plotly)
col_names= c('observation_number','treatment_group','subject_id_number','time', 'response')
toenail<-read.table("data/toenail3.txt", header=T, sep='', col.names = col_names)
toenail.df<-data.frame(toenail)
toenail.df$treatment_group<-ifelse(toenail.df$treatment_group==0,"Intraconazol","Lamisil")
toenail.df$treatment_group<-as.factor(toenail.df$treatment_group)
toenail.df$time<-as.factor(toenail.df$time)

fig<-plot_ly(toenail.df,y=~response,x=~time,color=~treatment_group,
             colors=c("orange","lightblue"),
             marker= list(line = list(color = "black",width =1)),
             line=list(color="black",width=1),
             type="box"
             )%>%
  layout(title ="<b>Toenail Growth by Treatment<b>", 
         yaxis=list(title= "Unaffected Toenail Growth (mm)"),
         xaxis=list(title = "Time (months)"),
         legend = list(title = list(text="<b>Treatment<b>")),
         boxmode="group",hoverlabel = list(bgcolor="white"))
  
fig