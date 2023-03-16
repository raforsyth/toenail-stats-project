# Toenail Statistics Project
Code and methods for analyzing a treatment of a toenail fungus using a Linear Mixed Effects Model for a Statistics Class
## Summary Statistics

## Linear Mixed Effect Model

Since our response variable, toenail growth (in mm), will vary both in it's starting value and it's progression over time between individuals regardless of treatment, we hereby model subjectID as a random variable which has an effect on time based progression and on the intital intercept. This means that for each specific subject we have normally distributed random variation in the intercept and evolution of response over time. We treat our treatment variable as a fixed effect, as we expect it to have a constant effect on the intercept and change in response over time if it is found to have a significant effect on either.

To determine if our fixed treatment effect has a significant impact on either the intercept or the slope we fit three models

First, A model with no effect based on treatment group
$$Y_{ij} = \gamma_{00}+b_{0i}+(\gamma_{10}+b_{1i})(\textrm{Time}) + \epsilon_{ij}$$

- $Y_{ij}$ being our toenail growth in mm

- $\gamma_{00}$ being the estimated intercept for a non specific subject

- $b_{0i}$ being normally distributed per subject variation in intercept from our random variable

- $\gamma_{10}$ being the estimated slope for a non specific subject

- $b_{1i}$ being the normally distributed per subject variation in slope from our random variable

- $\epsilon_{ij}$ being unknown random error

Second, A model where the treatment group has an effect on the slope
$$Y_{ij} = \gamma_{00}+b_{0i}+(\gamma_{10}+b_{1i}+\gamma_{11}(\textrm{Treatment Group}))(\textrm{Time}) + \epsilon_{ij}$$

- $\gamma_{11}$ being the estimated fixed effect on slope that the treatment group has

Third, A model where the treatment group has an effect on both the slope and intercept
$$Y_{ij} = \gamma_{00}+b_{0i}+\gamma_{01}(\textrm{Treatment Group)})+(\gamma_{10}+b_{1i}+\gamma_{11}(\textrm{Treatment Group}))(\textrm{Time}) + \epsilon_{ij}$$

- $\gamma_{01}$ being the estimated fixed effect on intercept that the treatment group has

The variation explained by each of these models were tested using an ANOVA, with the $H_0$ for each subsquent model being that the model doesn't not explain more of the random variation that the null model.

<image src = "https://github.com/raforsyth/toenail-stats-project/blob/main/toenail-stats-project/images/model_anova.png" width = "774" height = "158">

Given our $\alpha = 0.05$, we fail to reject the null hypothesis for either of our new models, meaning we don't have sufficent evidence to say that differences in the treament group lead to different intercepts or slopes in our model for toenail growth over time.

We should therefore model our prediction of toenail growth over time using the hierachical model with no treatment group component.

## Prediction

Although there's no particular difference in the progression of toenail growth based on the different treatment, we can still use our model to predict the progression of toenail growth in response to one of the two treatments. However, we run into a problem, since our model takes into effect two normally distributed random coefficents for slope and intercept.

- $b_{0i}$ being normally distributed per subject variation in intercept from our random variable

- $b_{1i}$ being the normally distributed per subject variation in slope from our random variable

However, these two coefficents are not independent. These are assumed to be drawn from a bivariate normal distribution and thus are correlated. We know that there is a correlation of -0.39 between $b_{0i}$ and $b_{1i}$ from our LME4 generated model. We can visualize the connection below with the random variable for intercept plotted against the random variable for slope.

<image src = "https://github.com/raforsyth/toenail-stats-project/blob/main/toenail-stats-project/images/rand_int_rand_slope.png">

Therefore if we know the starting intercept value we can make a prediction for $b_{1i}$ if we know our starting intercept. If we have a new patient and a starting toenail length, we can give a prediction for the evolution of the growth of the toenail.

To do this we generate the following simple linear regression for $b_{1i}$ given $b_{0i}$:

<image src = "https://github.com/raforsyth/toenail-stats-project/blob/main/toenail-stats-project/images/linear_reg_table.png" width = "690" height = "167">

So given a new patient's starting toenail length $t_0$, we can predict $b_{1i}$ through the following sets of equations, using $\alpha$ as our estimated intercept above and our $\beta$ as our estimated slope above:

$$t_0 = \hat{\gamma_{00}} + \hat{b_{0i}} \implies$$

$$\hat{b_{0i}} = t_0 - \hat{\gamma_{00}}$$

$$\hat{b_{1i}} = \hat{\alpha} + \hat{\beta}(\hat{b_{0i}})$$

And we can plug that into our final model

$$\hat{Y_{ij}} = \hat{\gamma_{00}}+\hat{b_{0i}}+(\hat{\gamma_{10}}+\hat{\alpha} + \hat{\beta}(\hat{b_{0i}}))(\textrm{Time})$$

To generate the prediction for toenail progression at a given time given our starting toenail length.
## Random Effects Assessment