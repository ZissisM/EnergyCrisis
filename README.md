# "European Energy Crisis Electricity Price vulnerability and the consequences of the generation mix in the European Energy Crisis" Replication Package
### Raúl Bajo, Antonio Bento, Daniel Kaffine, and Zissis Marmarelis

#### The following repository contains all of the raw data and  curated datasets and code used to generate each figure and result in the paper "European Energy Crisis Electricity Price vulnerability and the consequences of the generation mix in the European Energy Crisis". The model output was generated in STATA. Any questions with the code or data please contact zmarmare@usc.edu

## Datasets 

 * *Contry datasets* include the data collected and used for each country, analyzed individually, for our sample period (April 1 2021-October 31 2021). These include the hourly wholesale electricity price, hourly load, and hourly energy generation by source, as described in Supplementary Discussion 2. Included are the individual TSOs of Germany and Norway, in addition to a more basic aggregated dataset for these countries. Datasets are named according to their two letter official country abbreviation, and the ending of '_new'. 

 * *Combined datasets* include streamlined data of all countries aggregated. Namely, average generation shares and vulnerability estimates (labeled Intensity) are shown in allcountries_ datasets. Vulnerability estimates (e.g., used for Figure 4 and similar SI Figures) are reflected in HourlyEst_ datasets, and each specification condition (such as excluding a certain month or predicting future vulnerability). Allcountries_ datasets include the HourlyEst_ estimates in addition to corresponding generation shares.
 
 * *Other datasets* include datasets used to generate certain Figures, such as Figure 1 utilizing wholesale prices (sample period and historic), aswell as estimates for Figure 5 generation. Raw data is also included here: hourly wholesale prices, daily gas prices (labeled newprices), while hourly raw energy generation and load data are too large and thus the link to these zip files is provided [here](https://drive.google.com/drive/folders/1iyNvfgKGQ_N0W-IvbxpxyQ3Im6CjiiJI?usp=sharing).


## Code

**Main Text Figures** [^1] 

 * Fig1.do: Generates Figure 1 (3 Panels) using the datasets in *Other* datasets.
 
 * Fig2.do: Generates Figure 2 using *Combined* dataset
 
 * HourlyEstimates.do: Generates vulnerability metrics and creates dataset with all countries (see *combined* datasets). Simply changing the initial regression specficiation can yield different vulnerability estimates. It uses the *country* datasets. Used to generate Figures 4, Panel B of Figure 5, Extended Data Figures (EDF)2,7,8 and SI Map Figures (S1-S6) [^2].
 
 * Fig5.do: Generates Panel C,D,E of Figure 5. Also estimates average coefficients (included in generated excel sheet) used for Panel A. Uses *country* datasets.
 
 * Fig6.do: Generates Figure 6. Uses *country* datasets. Legend is edited manually for visual purposes.
 
 * fig7_gen.do: Generates Figure 7 (and Figure S6 making the minor modification specified in code). Also generates Table EDF4 (multivariate regression of shares on vulnerability). Uses *combined* datastes.
 
 **Extended Data and SI Figures**
 
 * fig7_load.do: Generates Figure S7 (load as a denominator for shares calculation). Uses *combined* datasets.
 
 * fig7_hourg.do: Generates EDF9 (Solar,Wind, Nuclear shares by hour-group vulnerability). Uses *combined* datasets.
 
 * fig7_alternativeVul.do: Generates Figure S9 (Figure 7 but with alternative vulnerability measure). Uses *combined* datasets.
 
 * fig7GasCoalHydro.do: Generates EDF10 (Gas,Coal, Hydro shares by hour-group vulnerability). Uses *combined* datasets.
 
 * Fig7_noOct.do: Generates Figure S6 (excluding month of October for shares and vulnerability). Uses *combined* datasets.
 
 * HourlyFiguresSI.do: Generates 8-paneled country hourly profile figures (Figures S10-S44). Figures S11 and S20 correlelograms are also generated. Uses *country* datasets.
 
 * SITables.do: Generates data for the tables shown in Extended Data (Tables EDF3, EDF4, EDF5, EDF6) and SI section (Tables S1, S2, S3). Uses *country* datasets. These are heavily edited later to format appropriately and make final tables.
 
 **Cleaning Code**
 
 * redoShares.do: Used to re-calculate generation shares used for Figure 7 by making modifications to the denominator. Uses *country* datasets.
 
 * EU_TSO_clean.do: Used initially to clean the downloaded hourly generation data and reformat it appropriately. Uses *country* datasets.
 
 

 * Entso-e Pandas Client was used to download the data. This can be found [here](https://github.com/EnergieID/entsoe-py).
 
 
 [^1]: Running particular code may require the manual selection of the different dataset folders provided (i.e., Country, Combined, or Other).
 [^2]: The website tool [Datawrapper.de](https://datawrapper.dwcdn.net/B37ic/1/) was used for the construction of maps for the Figures with our estimated results. Powerpoint was used for visual modification and merging of images to create certain figures (i.e., Figure 5).
