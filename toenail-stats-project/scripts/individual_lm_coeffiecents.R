library(plotly)
col_names= c('observation_number','treatment_group','subject_id_number','time', 'response')
toenail<-read.table("data/toenail3.txt", header=T, sep='', col.names = col_names)
cf<-sapply(toenail$subject_id_number,function(x){
  coef(lm(response~time,data = subset(toenail,subject_id_number==x)))
})
Sx<-reorder(toenail$subject_id_number,cf[1,])

lin.reg.coef<-by(toenail,toenail$subject_id_number,function(data) coef(lm(response ~ time,data = data)))
lin.reg.coef1<- unlist(lin.reg.coef)
lin.reg.coef2=matrix(lin.reg.coef1,length(lin.reg.coef1)/2,2,byrow=TRUE)

lin.reg.r.squares<-by(toenail,toenail$subject_id_number,function(data) summary(lm(response ~ time,data = data))$r.squared)
lin.reg.r.squares1<-as.vector(unlist(lin.reg.r.squares))
intercept.df<-data.frame(lin.reg.coef2[,1])
slope.df<-data.frame(lin.reg.coef2[,2])
r.squared.df<-data.frame(lin.reg.r.squares1)
fig_1<-plot_ly(x=intercept.df$lin.reg.coef2...1.,type="histogram",
               marker = list(color = "lightblue",
                             line =list(color = "black",width=1)),
               name = "Intercepts")
fig_2<-plot_ly(x=slope.df$lin.reg.coef2...2.,type="histogram",
               marker = list(color = "steelblue",
                             line =list(color = "black",width=1)),
               name = "Slope")
fig_3<-plot_ly(x=r.squared.df$lin.reg.r.squares1,type="histogram",
               marker = list(color = "orange",
                             line =list(color = "black",width=1)),
               name = "R squared")
fig_final<-subplot(fig_1,fig_2,fig_3,nrows=3)
fig_final