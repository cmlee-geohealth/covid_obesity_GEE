# covid_obesity_GEE

## COVID-19 Lockdown and Obesity: Exploring Physical Inactivity and Mental Distress Using GEE

Chanmi Lee

Fall 2024

## Introduction
The U.S. federal government declared a national emergency on March 13, 2020 from Covid-19, which remained in effect until May 11, 2023 (1). The COVID-19 lockdown led to reduced physical activity, increased sedentary behavior, and worsening mental health, creating a cycle that elevated obesity risk. Obesity, in turn, is strongly linked to both physical inactivity and depressive symptoms, with each condition exacerbating the other through unhealthy behaviors (2~4).

## Project Aim
This project aims to explore how physical inactivity and poor mental health impact obesity prevalence over time and how these relationships vary across different census tracts in Philadelphia from 2018 to 2022.

## Outline of the Script

* Descriptive statistics
* Visualization
* GEE Model
* Model Diagnostics
  
## Methods

### Model
* A generalized estimating equations (GEE) model with a Poisson family
* Fixed effects for physical inactivity, mental health, and year were included, and an exchangeable correlation structure accounted for intra-cluster correlations. 

### Equation

lpa: low physical activity

mhlth: mentally distressed days

y_ij = β₀ + β₁ ("lpa")_ij + β₂ ("mhlth")_ij + β₃ ("year")_ij + ϵ_ij 

## Results
* __Low physical activity (lpa)__ showed a significant positive association with obesity, with each unit increase in inactivity linked to a 1.4% rise in obesity rates (𝛽 = 0.0139, p < 2e-16). 
* __Mentally distressed days (mhlth)__ also had a smaller but significant effect, with each additional day associated with a 0.4% increase in obesity (𝛽 = 0.0037, p = 0.000165).
* __Obesity rates__ declined in 2019, 2020, and 2021 but rose in 2022 compared to 2018.

* The model accounted for intra-cluster correlations and showed no major assumption violations, highlighting the need to address both physical inactivity and mental health to intervene and target possible obesity reduction.

## Discussion
* The model shows an association between obesity, low physical activity (lpa), and mentally distressed days (mhlth), with estimates accounting for intra-cluster correlations.
* Obesity rates declined from 2019 to 2021 but increased in 2022, highlighting potential impacts of Covid19 lockdown.
* These findings underline the role of physical inactivity and mental distress in obesity trends and provide insights for public health strategies.

### References
(1) Centers for Disease Control and Prevention. (2023). End of the Federal COVID-19 Public Health Emergency (PHE) Declaration. Retrieved from https://www.cdc.gov/coronavirus/2019-ncov/your-health/end-of-phe.html

(2) Ladabaum, U., Mannalithara, A., Myer, P. A., & Singh, G. (2014). Decreased physical activity and increased obesity in US adults: A population-based study. The American Journal of Medicine, 127(8), 717–727. https://doi.org/10.1016/j.amjmed.2014.02.026.

(3) Luppino, F. S., de Wit, L. M., Bouvy, P. F., Stijnen, T., Cuijpers, P., Penninx, B. W. J. H., & Zitman, F. G. (2010). Overweight, obesity, and depression: A systematic review and meta-analysis of longitudinal studies. Archives of General Psychiatry, 67(3), 220–229. https://doi.org/10.1001/archgenpsychiatry.2010.2

(4) Zhao, Z., Li, L., & Sang, Y. (2023). The COVID-19 pandemic increased poor lifestyles and worsened mental health: A systematic review. American Journal of Translational Research, 15(5), 3060–3066. Retrieved from http://www.ajtr.org

