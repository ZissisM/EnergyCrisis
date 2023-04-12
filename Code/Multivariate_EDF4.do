
*EDF Table 4*
****Multivariate regression****
use allcountries_genshares

*AbsV
replace Solar = 0.038 in 7 //Denmark educated guess (based on ourworldindata.org Electricity Mix Profile) for solar so it does not omit entire country for missing this value in the regression
label var Nuc "Nuclear"
label var Hydro_R "Hydro-run"

label var absV "Absolute Vulnerability"
reg absV Solar Wind Hydro_R Nuc Coal Gas HydroDispatch,vce(robust)

test Solar Wind Hydro_R Nuc Coal Gas HydroDispatch 

*Output table but it is slightly edited later manually
outreg2 using TableSImultivariateShares.doc, replace se label bdec(2) nocons adds(F-test,r(F),Prob>F,`r(p)') adjr2 ctitle("Absolute Vulnerability")


*
label var Intensity "Relative Vulnerability"
reg Intensity Solar Wind Hydro_R Nuc Coal Gas HydroDispatch,vce(robust)
test Solar Wind Hydro_R Nuc Coal Gas HydroDispatch 
outreg2 using TableSImultivariateShares.doc, append se label bdec(2) nocons adds(F-test,r(F),Prob>F,`r(p)') adjr2 ctitle("Relative Vulnerability")


replace Solar = . in 7
