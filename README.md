# "Decarbonization strategies and electricity price vulnerability: lessons from the European Energy Crisis" Replication Package
### Raúl Bajo, Antonio Bento, Daniel Kaffine, and Zissis Marmarelis

#### The following repository contains all of the raw data and  curated datasets and code used to generate each figure and result in the paper "European Energy Crisis Electricity Price vulnerability and the consequences of the generation mix in the European Energy Crisis". The model output was generated in STATA. Any questions with the code or data please contact zmarmare@usc.edu

## Datasets 

 * *Contry datasets* include the data collected and used for each country, analyzed individually, for our sample period (April 1 2021-October 31 2021). These include the hourly wholesale electricity price, hourly load, and hourly energy generation by source, as described in Supplementary Discussion 4. Included are the individual TSOs of Germany and Norway, in addition to a more basic aggregated dataset for these countries. Datasets ending in "f" include the predicted wholesale prices for each natural gas price for each country, used in our price cap discussion. Datasets comprised of all countries with decarbonized shares over the sample period are included (RE_spag, deca).  Datasets are named according to their two letter official country abbreviation, and the ending of '_new'.  

 * *Combined datasets* include streamlined data of all countries aggregated. Namely, average generation shares and vulnerability estimates (relative vulnerability labeled Intensity) are shown in allcountries_ datasets. Vulnerability estimates (e.g., used for Figure 2,3 and similar SI Figures) are reflected in HourlyEst_ datasets, and each specification condition (such as excluding a certain month or predicting future vulnerability).  Allcountries_ datasets include the HourlyEst_ estimates in addition to corresponding generation shares.
 
 * *Other datasets* include datasets used to generate certain Figures, such as Figure 1 utilizing wholesale prices (i.e., wholesale_both with sample period and historic prices). Possible baseline (pre-crisis averages) prices for absolute vulnerability are also put together here for all countries.Raw data is also included here: hourly wholesale prices, daily gas prices (labeled newprices), while hourly raw energy generation and load data are too large and thus the link to these zip files is provided [here](https://drive.google.com/drive/folders/1iyNvfgKGQ_N0W-IvbxpxyQ3Im6CjiiJI?usp=sharing).


## Code

**Main Text Figures** [^1] 

 * Fig1.do: Generates Figure 1 (4 Panels) using the datasets in *Combined* and *Other* datasets.

 * HourlyEstimates.do: Generates relative vulnerability metrics and creates dataset with all countries (see *combined* datasets). The *main* econometric specification estimation program. Simply changing the initial regression specficiation can yield different vulnerability estimates. It uses the *country* datasets. Used to generate Figure 2 Maps, Vulnerabilities for Figure 3, Panel B of Figure 4, Extended Data Map Figures (EDF 2 & 4) and SI Map Figures (S1-S6) [^2].
 
  * AbsVul.do: Used to calculate absolute vulnerability from the relative vulnerabilities. Uses *Combined* datasets. 
  
  * Fig3.do*: Generates Figure 3 scatter plots and the price cap table. Uses *combined* datasets.
  
 * Fig4.do: Generates Panel C,D,E of Figure 4. Also estimates average coefficients (included in generated excel sheet) used for Panel A. Uses *country* datasets.
 
 * Fig5.do: Generates Figure 5 of country case studies and price cap responsiveness (F). Uses *country* datasets. Legend is edited manually for visual purposes.
 
 **Extended Data and SI Figures**
 
 * fig3_load.do: Generates Figure S11 (load as a denominator for shares calculation), similar to Figure 3 scatter plots. Uses *combined* datasets.
 
  * Fig3_noOct.do: Generates Figure S12 (excluding month of October for shares and vulnerability), similar to Figure 3 scatter plots. Uses *combined* datasets.
   
 * HourlyFiguresSI.do: Generates 8-paneled country hourly profile figures (Figures S10-S44). Figures S11 and S20 correlelograms are also generated. Uses *country* datasets.
 
 * SITables.do: Generates data for the tables shown in Extended Data (Tables EDF3, EDF4, EDF5, EDF6) and SI section (Tables S1, S2, S3). Uses *country* datasets. These are heavily edited later to format appropriately and make final tables.
 
 * Multivariate_EDF4.do: Generates the multivariate regression table of the two vulnerability metrics against each energy share, as shown in EDF Figure 8.
 
 **Cleaning Code**
 
 * decarb_calculate.do: Used to calculate the decarbonization shares for each country and get them into an appropriate dataset format. Uses *country* datasets. 
 
 * redoShares.do: Used to re-calculate generation shares used for Figure 7 by making modifications to the denominator. Uses *country* datasets.
 
 * EU_TSO_clean.do: Used initially to clean the downloaded hourly generation data and reformat it appropriately. Uses *country* datasets.
 

 * Entso-e Pandas Client was used to download the data. Example documentation can be found [here](https://github.com/EnergieID/entsoe-py).
 * _1_a_enstoe_api_fn.py & _1_1b_enstoe_api_fn.py: Used for this purpose to collect the desired data for each country.
 
 
 [^1]: Running particular code may require the manual selection of the different dataset folders provided (i.e., Country, Combined, or Other). The directory required is on the top of each do-file.
 [^2]: The website tool [Datawrapper.de](https://datawrapper.dwcdn.net/Wi1uA/1/) was used for the construction of maps for the Figures with our estimated results (from Hourly_Est country dataset). Example [link](https://www.datawrapper.de/_/Wi1uA/) to Fig2B map. Powerpoint was used for visual modification and merging of images to create certain figures (i.e., Figure 2).
