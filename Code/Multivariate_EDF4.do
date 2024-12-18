
*EDF Table 4*
****Multivariate regression****
* cd ~/Downloads/Nature_Energy_Crisis/Datasets/Combined datasets
*in combined datsets
use allcountries_genshares


*No more absolute vulnerability*
*AbsV
replace Solar = 0.038 in 7 //Denmark educated guess (based on ourworldindata.org Electricity Mix Profile) for solar so it does not omit entire country for missing this value in the regression
label var Nuc "Nuclear"
label var Hydro_R "Hydro-run"

label var absV "Absolute Vulnerability"
*reg absV Solar Wind Hydro_R Nuc Coal Gas HydroDispatch,vce(robust)

*test Solar Wind Hydro_R Nuc Coal Gas HydroDispatch 

*Output table but it is slightly edited later manually
*outreg2 using TableSImultivariateShares.doc, replace se label bdec(2) nocons adds(F-test,r(F),Prob>F,`r(p)') adjr2 ctitle("Absolute Vulnerability")


*2nd column for relative vulnerability in table 
label var Intensity "Vulnerability"
reg Intensity Solar Wind Hydro_R Nuc Coal Gas HydroDispatch,vce(robust)
test Solar Wind Hydro_R Nuc Coal Gas HydroDispatch 
outreg2 using TableSImultivariateShares.doc, replace se label bdec(2) nocons adds(F-test,r(F),Prob>F,`r(p)') adjr2 ctitle("Vulnerability")


replace Solar = . in 7
