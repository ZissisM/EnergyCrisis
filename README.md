# Electricity Prices, Generation Mix, European Energy Crisis]{Electricity price vulnerability and the consequences of the generation mix in the European Energy Crisis 
#### Bajo, Bento, Kaffine, Marmarelis

## Datasets 

*Contry datasets include the data used for each country, analyzed individually, for our sample period (April 1 2021-October 31 2021). Also included are the individual TSOs of Germany and Norway.
*Combined datasets include streamlined data of all countries aggregated. Namely, average generation shares and vulnerability estimates are shown in allcountries_ datasets. Vulnerability estimates (e.g., used for Figure 4 and similar SI Figures) are reflcted in HourlyEst_ datasets, and each specification condition (such as excluding a certain month or predicting future vulnerability). 
*Other datasets include datasets utilized to generate certain Figures, such as Figure 1 utilizing wholesale prices (sample period and historic), aswell as estimates for Figure 5 generation. Raw data is also included here: hourly wholesale prices, daily gas prices (newprices), while hourly raw energy generation and load data is too large and thus the link to these zip files is provided here: https://drive.google.com/drive/folders/1iyNvfgKGQ_N0W-IvbxpxyQ3Im6CjiiJI?usp=sharing


##Code

*Fig1.do: Generates Figure 1
*HourlyEstimates.do: Generates vulnerability metrics and creates dataset with all countries. Simply changing the initial regression specficiation can yield different vulnerability estimates. Used to generate Figures 4, EDF2&3, and SI Map Figures (S1-S3).
*Fig5.do: Generates Panel C,D,E of Figure 5
*Fig6.do: Generates Figure 6
*fig7_gen.do: Generates Figure 7 (and S6 making the minor modification specified in code). Also generates Table EDF4 (multivariate regression of shares on vulnerability).
*fig7_load.do: Generates Figure S5 (load as a denominator for shares calculation).
*fig7_hourg.do: Generates EDF4 (Solar,Wind, Nuclear shares by hour-group vulnerability).
*fig7GasCoalHydro.do: Generates EDF5 (Gas,Coal, Hydro shares by hour-group vulnerability).
*Fig7_noOct: Generates Figure S4 (excluding month of October for shares and vulnerability)
*HourlyFiguresSI: Generates 8-paneled country hourly profile figures (Figures S7-S38).
*SITables: Generates data for the tables shown in Extended Data (EDF1, EDF2, EDF3) and SI section (S1 & S2).
*redoShares: Used to re-calculate generation shares used for Figure 7 by making modifications to the denominator.
*EU_TSO_clean: Used initially to clean hourly generation data and reformat it appropriately.
