# Electricity Prices, Generation Mix, European Energy Crisis Electricity price vulnerability and the consequences of the generation mix in the European Energy Crisis 
### Raúl Bajo, Antonio Bento, Daniel Kaffine, and Zissis Marmarelis

## Datasets 

 * Contry datasets include the data used for each country, analyzed individually, for our sample period (April 1 2021-October 31 2021). Also included are the individual TSOs of Germany and Norway. These are named according to their two letter official country abbreviation, and the ending of '_new'.

 * Combined datasets include streamlined data of all countries aggregated. Namely, average generation shares and vulnerability estimates are shown in allcountries_ datasets. Vulnerability estimates (e.g., used for Figure 4 and similar SI Figures) are reflected in HourlyEst_ datasets, and each specification condition (such as excluding a certain month or predicting future vulnerability). Allcountries_ datasets include the HourlyEst_ estimates in addition to corresponding generation shares.
 
 * Other datasets include datasets utilized to generate certain Figures, such as Figure 1 utilizing wholesale prices (sample period and historic), aswell as estimates for Figure 5 generation. Raw data is also included here: hourly wholesale prices, daily gas prices (newprices), while hourly raw energy generation and load data are too large and thus the link to these zip files is provided here: https://drive.google.com/drive/folders/1iyNvfgKGQ_N0W-IvbxpxyQ3Im6CjiiJI?usp=sharing. 


## Code

 * Fig1.do: Generates Figure 1
 
 * HourlyEstimates.do: Generates vulnerability metrics and creates dataset with all countries. Simply changing the initial regression specficiation can yield different vulnerability estimates. Used to generate Figures 4, EDF2-4, and SI Map Figures (S1-S5).
 
 * Fig5.do: Generates Panel C,D,E of Figure 5
 
 * Fig6.do: Generates Figure 6
 
 * fig7_gen.do: Generates Figure 7 (and Figure S6 making the minor modification specified in code). Also generates Table EDF4 (multivariate regression of shares on vulnerability).
 
 * fig7_load.do: Generates Figure S5 (load as a denominator for shares calculation).
 
 * fig7_hourg.do: Generates EDF4 (Solar,Wind, Nuclear shares by hour-group vulnerability).
 
 * fig7_alternativeVul.do: Generates Figure S9 (Figure 7 but with alternative vulnerability measure).
 
 * fig7GasCoalHydro.do: Generates EDF5 (Gas,Coal, Hydro shares by hour-group vulnerability).
 
 * Fig7_noOct.do: Generates Figure S4 (excluding month of October for shares and vulnerability).
 
 * HourlyFiguresSI.do: Generates 8-paneled country hourly profile figures (Figures S7-S38).
 
 * SITables.do: Generates data for the tables shown in Extended Data (EDF1, EDF2, EDF3) and SI section (S1 & S2). These are heavily edited later to format appropriately and make final tables.
 
 * redoShares.do: Used to re-calculate generation shares used for Figure 7 by making modifications to the denominator.
 
 * EU_TSO_clean.do: Used initially to clean hourly generation data and reformat it appropriately.
 
 
 
 * Entsoe Pandas Client was used to download the data. This can be found here: https://github.com/EnergieID/entsoe-py
 
 * Datawrapper.de was used for the construction of maps for the Figures with our estimated data from the above code. Powerpoint was used for visual modification and merging of images to create certain figures (i.e., Figure 5).
