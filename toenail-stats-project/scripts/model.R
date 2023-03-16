library(lme4)
library(arm)
library(pbkrtest)
library(kableExtra)
library(formattable)
library(knitr)
library(plotly)
col_names= c('observation_number','treatment_group','subject_id_number','time', 'response')
toenail<-read.table("data/toenail3.txt", header=T, sep='', col.names = col_names)
toe_lmer<-lmer(response~1+time*treatment_group+(1+time|subject_id_number),REML=FALSE,data = toenail)
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


toe_lmer.re=ranef(toe_lmer_noprog)$subject_id_number
fig3<- subplot(
  plot_ly(data = toe_lmer.re, x =~`(Intercept)`, type = 'box',
          marker = list(color = "lightblue",line = list(color = "black",width = 1)),
          line = list(color = "black",width = 1),
          fillcolor = "lightblue"),
  plotly_empty(),
  plot_ly(data = toe_lmer.re, x =~`(Intercept)`, y = ~time, type = 'scatter',
          mode = 'markers',
          marker = list(color = "orange",line = list(color = "black",width = 1))
          )%>%
    layout(yaxis = list(title = "Slope", zeroline = F)),
  plot_ly(data = toe_lmer.re, y = ~time, type = 'box', 
          marker = list(color = "lightblue",line = list(color = "black",width = 1)),
          line = list(color = "black",width = 1),
          fillcolor = "lightblue"
          ),
  nrows = 2, heights = c(.2, .8), widths = c(.8,.2), margin = 0,
  shareX = TRUE, shareY = TRUE) %>%
  layout(
    showlegend = F,
    title = "<b>Random Intercept Term vs Random Slope Term <b>",
    xaxis = list(title = "Intercept", zeroline = F)
    )
fig3

toe.re.lm<-lm(toe_lmer.re$time~toe_lmer.re$`(Intercept)`)
toe.lm.summary<-summary(toe.re.lm)$coefficients
toe.lm.summary<-data.frame(toe.lm.summary)
toe_names<-c('Intercept','Slope')
toe_lm_reformat<-cbind(toe_names,round(toe.lm.summary$Estimate,3), round(toe.lm.summary$Std..Error,3),round(toe.lm.summary$t.value,3),toe.lm.summary$Pr...t..)
toe_lm_reformat<-data.frame(toe_lm_reformat)
names(toe_lm_reformat) = c('Parameter','Estimate','Standard Error','t Value','P value')
toe_lm_reformat$`P value`<-as.numeric(toe_lm_reformat$`P value`)
toe_lm_reformat$`P value`<- ifelse(toe_lm_reformat$`P value`<=0.05, 
                                      cell_spec(toe_lm_reformat$`P value`,format="html",background="orange"), 
                                      cell_spec(toe_lm_reformat$`P value`,format="html", color = "black"))

kbl(toe_lm_reformat,escape = F)%>%
  kable_styling(bootstrap_options = c('striped','hover','condensed'))%>%
  column_spec(1,italic = TRUE)
#create bivariate normal distribution
covar_matrix<- unclass(VarCorr(toe_lmer_noprog))$subject_id_number

set.seed(0)
x_0     <- seq(-4, 10, 0.1) 
y_0     <- seq(-1.5, 1.5, 0.1)
mu    <- c(0, 0)
sigma <- matrix(c(7.336145 ,-0.4979880, -0.497988, 0.2244839), nrow=2)
f     <- function(x_0, y_0) dmnorm(cbind(x_0, y_0), mu, sigma)
z_0     <- outer(x_0, y_0, f)

#create contour plot
fig<-plot_ly(x=x_0,y=y_0,z=t(z_0),type = "contour",colorscale="oranges",line = list(color="black",width =1))
