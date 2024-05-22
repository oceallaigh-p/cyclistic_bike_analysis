# Cyclistic bike-share case study

Paidraig (Patrick) O'Ceallaigh  

2024-04-26

The following is a case study of the fictional Cyclistic bike-share company. It is the capstone project for the Google Data Analytics Professional Certificate program.   

The case study is based on a real-world scenario and the data provided is a subset of the actual data collected by Cyclistic. The dataset is provided by Motivate International Inc. and is licensed under the [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/).    

The analysis is done using R. The RMarkdown file for the report is available in the GitHub repository at [`Rmd/cyclistic_bikeshare_report.Rmd'](https://github.com/oceallaigh-p/cyclistic_bike_analysis/blob/main/Rmd/cyclistic_bikeshare_report.Rmd) and the R code is available in the [R](https://github.com/oceallaigh-p/cyclistic_bike_analysis/tree/main/R) folder. 

The final report for the analysis is available at [Cyclistic bike-share report](https://oceallaigh-p.github.io/cyclistic_bike_analysis/output/html/cyclistic_bikeshare_report.html), and a pdf version is available for download at [Cyclistic bike-share report pdf](https://github.com/oceallaigh-p/cyclistic_bike_analysis/blob/main/reports/cyclistic_bikeshare_report.pdf).

### Case study: How does a bike-share navigate speedy success?    

#### Scenario    

You are a junior data analyst working on the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members. But First, Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data visualizations.    

#### Characters and teams    

* **Cyclistic:** A bike-share program that features more than 5,800 bicycles and 600 docking stations. Cyclistic sets itself apart by also offering reclining bikes, hand tricycles, and cargo bikes, making bike-share more inclusive to people with disabilities and riders who can’t use a standard two-wheeled bike. The majority of riders opt for traditional bikes; about 8% of riders use the assistive options. Cyclistic users are more likely to ride for leisure, but about 30% use the bikes to commute to work each day.    

* **Lily Moreno:** The director of marketing and your manager. Moreno is responsible for the development of campaigns and initiatives to promote the bike-share program. These may include email, social media, and other channels.    

* **Cyclistic marketing analytics team:** A team of data analysts who are responsible for collecting, analyzing, and reporting data that helps guide Cyclistic marketing strategy. You joined this team six months ago and have been busy learning about Cyclistic’s mission and business goals—as well as how you, as a junior data analyst, can help Cyclistic achieve them.    

* **Cyclistic executive team:** The notoriously detail-oriented executive team will decide whether to approve the recommended marketing program.    

#### About the company    

In 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime.    

Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.    

Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders. Although the pricing flexibility helps Cyclistic attract more customers, Moreno believes that maximizing the number of annual members will be key to future growth. Rather than creating a marketing campaign that targets all-new customers, Moreno believes there is a solid opportunity to convert casual riders into members. She notes that casual riders are already aware of the Cyclistic program and have chosen Cyclistic for their mobility needs.     

Moreno has set a clear goal: Design marketing strategies aimed at converting casual riders into annual members. In order to do that, however, the team needs to better understand how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics. Moreno and her team are interested in analyzing the Cyclistic historical bike trip data to identify trends.    

#### Ask    

Three questions will guide the future marketing program:  

1. How do annual members and casual riders use Cyclistic bikes differently?
2. Why would casual riders buy Cyclistic annual memberships?
3. How can Cyclistic use digital media to influence casual riders to become members?


<br>

> Moreno has assigned you the first question to answer:
>
> ***How do annual members and casual riders use Cyclistic bikes diferently?***

<br>