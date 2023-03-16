library(lme4)
library(arm)
library(plotly)
library(knitr)
col_names= c('observation_number','treatment_group','subject_id_number','time', 'response')
toenail<-read.table("data/toenail3.txt", header=T, sep='', col.names = col_names)
toe_lmer<-lmer(response~1+time*treatment_group+(1+time|subject_id_number),REML=FALSE,data = toenail)

## Random effects assessment
cf<-sapply(toenail$subject_id_number,function(x){
  coef(lm(response~time,data = subset(toenail,subject_id_number==x)))
})
Sx<-reorder(toenail$subject_id_number,cf[1,])

lin.reg.coef<-by(toenail,toenail$subject_id_number,function(data) coef(lm(response ~ time,data = data)))
lin.reg.coef1<- unlist(lin.reg.coef)
lin.reg.coef2=matrix(lin.reg.coef1,length(lin.reg.coef1)/2,2,byrow=TRUE)
intercept.df<-data.frame(lin.reg.coef2[,1])
slope.df<-data.frame(lin.reg.coef2[,2])

ind.coef=coef(toe_lmer_noprog)$subject_id_number
ind.coef=ungroup(ind.coef)
slope_intercept.lm<-lm(time~`(Intercept)`,ind.coef)
slope_intercept_ind.lm<-lm(time~`(Intercept)`,toe_lmer_re)

fig<-plot_ly(data = ind.coef,x = ~`(Intercept)`) %>%
  add_trace(x=intercept.df$lin.reg.coef2...1.,y=slope.df$lin.reg.coef2...2.,type = 'scatter',
            marker = list(color = "orange",line = list(color = "black",width = 1)),
            name = "Separate Regressions"
            )%>%
  add_trace(y=~time,type = 'scatter',mode ="markers",
            marker = list(color = "lightblue", 
                          line = list(color = "black", width = 1)),
            name = "Full Model")%>%
  layout(
    title = "<b>Shrinkage in Full Model <b>",
    xaxis = list(title = "Intercept", zeroline = F),
    yaxis = list(title = "Slope for Time", zeroline = F )
  )
fig