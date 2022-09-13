
grstyle clear
grstyle init
grstyle set grid
use Fig8

replace Solar = 0.038 in 7 //Denmark educated guess for solar so it does not omit entire country for missing this value in the regression
reg Intensity Solar Wind Nuc Coal Gas HydroDispatch 
label var RE "IRE"
label var Nuc "Nuclear"




sort coef
gen n= _n
labmask n, values(source)

graph twoway (rcap  ul ll n, lwidth(*1.9) msize(*1.5) horizontal lcolor(maroon*0.5)) || (dot coef n, horizontal xtitle("(EUR/MWh)", size(*1.4)) mcolor(maroon%80) msymbol(d)  msize(*2.05) ytitle("") title("",position(11) size(*0.95)) barw(1.3) legend(off) ylabel(,valuelabel labsize(*1.4) angle(horizontal)) xlabel(,labsize(*1.35)) xline(0, lwidth(*1.9)))

//ylabel(,valuelabel labsize(medium) angle(horizontal))) 
save multivariate
test Solar Wind Nuc Coal Gas HydroDispatch 
*Output table but it is heavily edited later manually
outreg2 using TableSImultivariateShares.doc, replace se label bdec(2) nocons adds(F-test,r(F),Prob>F,`r(p)') adjr2
replace Solar = . in 7




