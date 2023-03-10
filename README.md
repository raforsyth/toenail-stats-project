# Toenail Statistics Project
Code and methods for analyzing a treatment of a toenail fungus using a Linear Mixed Effects Model for a Statistics Class
## Linear Mixed Effect Model
Since our response variable, toenail growth (in mm), will vary both in it's starting value and it's progression over time between individuals regardless of treatment, we hereby model it as a random variable. This means that for each specific subject we have normally distributed random variation in the intercept and evolution of response over time. We treat our treatment variable as a fixed effect, as we expect it to have a constant effect on the intercept and change in response over time if it is found to have a significant effect on either.

To determine if our fixed treatment effect has a significant impact on either the intercept or the slope we fit three models
1. A model with no effect based on treatment group
$$Y_(ij) = \gamma_(00)+b_(0i)+(\gamma_(10)+b_(1i))(\textrm{Time}) + \epsilon_(ij)$$
2. A model where the treatment group has an effect on the slope 
3. A model where the treatment group has an effect on both the slope and intercept
![anova table](https://github.com/raforsyth/toenail-stats-project/blob/main/toenail-stats-project/images/model_anova.png)