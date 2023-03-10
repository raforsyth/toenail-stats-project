library(lme4)
library(arm)
library(pbkrtest)
library(kableExtra)
library(formattable)
library(knitr)
col_names= c('observation_number','treatment_group','subject_id_number','time', 'response')
toenail<-read.table("data/toenail3.txt", header=T, sep='', col.names = col_names)
toe_lmer<-lmer(response~time*treatment_group+(1+time|subject_id_number),REML=FALSE,data = toenail)
summary(toe_lmer)

## fitting ANOVA for testing fixed effects
toe_lmer_noprog<- lmer(response~time+(1+time|subject_id_number),REML=FALSE,data = toenail)
toe_lmer_intercept<-lmer(response~time+treatment_group+(1+time|subject_id_number),REML=FALSE,data= toenail)
toe_aov<-anova(toe_lmer_noprog,toe_lmer_intercept,toe_lmer)
toe_model_names<-c('No effect','Intercept Effect Model','Slope and Intercept Effect Model')
toe_aov_reformat<-cbind(toe_model_names,toe_aov$npar,round(toe_aov$AIC),round(toe_aov$BIC),round(toe_aov$logLik),round(toe_aov$deviance),round(toe_aov$Chisq,3),toe_aov$Df,round(toe_aov$`Pr(>Chisq)`,3))
toe_aov_reformat<-data.frame(toe_aov_reformat)
names(toe_aov_reformat) = c('Model for Treatment','npar','AIC','BIC','logLik','deviance','Chisq','Df','p(>Chisq)')
toe_aov_reformat$`p(>Chisq)`<- ifelse(toe_aov_reformat$`p(>Chisq)`<=0.05, 
                                      cell_spec(toe_aov_reformat$`p(>Chisq)`,format="html",color="orange"), 
                                      cell_spec(toe_aov_reformat$`p(>Chisq)`,format="html", color = "black"))

kbl(toe_aov_reformat,escape = F)%>%
  kable_styling(bootstrap_options = c('striped','hover','condensed'))%>%
  column_spec(1,italic = TRUE)