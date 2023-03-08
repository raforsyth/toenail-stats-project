library(kableExtra)
library(formattable)
col_names= c('observation_number','treatment_group','subject_id_number','time', 'response')
toenail<-read.table("data/toenail3.txt", header=T, sep='', col.names = col_names)
toenail.edited <- toenail[, c(3, 2, 4, 5)]
toenail.wide <- reshape(toenail.edited, timevar = "time", idvar = c("subject_id_number", "treatment_group"), direction = "wide")
toenail.wide <- toenail.wide %>%
  arrange(subject_id_number)

# calculate correlation table & save to file
toenail.cor.pair<-cor(toenail.wide[,3:length(toenail.wide)],use="pairwise.complete")
toenail.cor.df<-data.frame(toenail.cor.pair)
toenail.cor.df$response.0<- color_tile('white','orange')(toenail.cor.df$response.0)
toenail.cor.df$response.1<- color_tile('white','orange')(toenail.cor.df$response.1)
toenail.cor.df$response.2<- color_tile('white','orange')(toenail.cor.df$response.2)
toenail.cor.df$response.3<- color_tile('white','orange')(toenail.cor.df$response.3)
toenail.cor.df$response.6<- color_tile('white','orange')(toenail.cor.df$response.6)
toenail.cor.df$response.9<- color_tile('white','orange')(toenail.cor.df$response.9)
toenail.cor.df$response.12<- color_tile('white','orange')(toenail.cor.df$response.12)
names(toenail.cor.df)= c("Month 0","Month 1","Month 2","Month 3","Month 6","Month 9","Month 12")
rownames(toenail.cor.df)= c("Month 0","Month 1","Month 2","Month 3","Month 6","Month 9","Month 12")
kbl(toenail.cor.df,escape = F)%>%
  kable_styling(bootstrap_options = c('striped','hover','condensed'))%>%
  column_spec(1,italic = TRUE)
