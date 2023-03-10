# Toenail Statistics Project
Code and methods for analyzing a treatment of a toenail fungus using a Linear Mixed Effects Model for a Statistics Class
## Linear Mixed Effect Model
Since our response variable, toenail growth (in mm), will vary both in it's starting value and it's progression over time between individuals regardless of treatment, we hereby model it as a random variable. This means that for each specific subject we have normally distributed random variation in the intercept and evolution of response over time. We treat our treatment variable as a fixed effect, as we expect it to have a constant effect on the intercept and change in response over time if it is found to have a significant effect on either.

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
$$Y_{ij} = \gamma_{00}+b_{0i}+\gamma_{01}(\textrm{Treatment Group)})(\gamma_{10}+b_{1i}+\gamma_{11}(\textrm{Treatment Group}))(\textrm{Time}) + \epsilon_{ij}$$

- $\gamma_{01}$ being the estimated fixed effect on intercept that the treatment group has

The variation explained by each of these models were tested using an ANOVA, with the $H_0$ for each subsquent model being that the model doesn't not explain more of the random variation that the null model.

![anova table](https://github.com/raforsyth/toenail-stats-project/blob/main/toenail-stats-project/images/model_anova.png= 774x158)

Given our $\alpha = 0.05$, we fail to reject the null hypothesis for either of our new models, meaning we don't have sufficent evidence to say that differences in the treament group lead to different intercepts or slopes in our model for toenail growth over time.

