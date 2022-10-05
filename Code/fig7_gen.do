**Fig 7 generation with energy shares with denominator as TOTAL gen (no imports included)
clear

use allcountries_genshares


**to adjust for DK and NL
replace Solar = 0.038 in 7
replace Solar = 0.0947 in 17

*back to how data is downloaded
replace Solar = 0.0230995 in 17
replace Solar = . in 7

**For orienting the labels on graphs to avoid overlap
cap gen z1=1
replace z1=12 if Country=="RO"
replace z1=6 if Country=="FI"
replace z1=9 if Country=="CH"
replace z1=1 if Country=="HR"
replace z1=3 if Country=="NO"
replace z1=3 if Country=="PT"
replace z1=3 if Country=="NL"
replace z1=3 if Country=="SI"
replace z1=3 if Country=="DE"



***Nuclear
**robust regression using the mm estimator
robreg mm Intensity Nuc if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each country
twoway scatter Intensity Nuc if exclude==0, mlabel(labels) mlabvposition(z1) mlabsize(*2.03) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("C)",position(11) size(*1.75)) xtitle("Nuclear share",size(*2.2)) ylabel(,labsize(*2) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*2)) ytitle(Vulnerability (EUR/MWh),size(*2.2)) name(nall,replace) ||function y=_b[Nuc]*x+_b[_cons],range(Nuc) || lfit Intensity Nuc if exclude==0, lcolor(ebblue*0.5)




***Wind
cap gen z2=1
replace z2=3 if Country=="FI"
replace z2=9 if Country=="DK"
replace z2=3 if Country=="PT"
replace z2=4 if Country=="NL"
replace z2=3 if Country=="LT"
replace z2=3 if Country=="RS"
replace z2=2 if Country=="BG"
replace z2=3 if Country=="BE"
replace z2=3 if Country=="NO"
replace z2=10 if Country=="SI"
replace z2=4 if Country=="RO"
replace z2=12 if Country=="PL"
replace z2=3 if Country=="EE"
replace z2=3 if Country=="HU"
replace z2=3 if Country=="CZ"
replace z2=5 if Country=="CH"

replace z2=3 if Country=="AT"


robreg mm Intensity Wind if exclude==0
matrix b = e(b)
twoway scatter Intensity Wind if  exclude==0, mlabel(labels) mlabvposition(z2) mlabsize(*2.03) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("E)",position(11) size(*1.75)) xtitle("Wind share",size(*2.2)) ylabel(,labsize(*2) grid gmax gmin glwidth(0.5)) xlabel(,labsize(*2)) ytitle(Vulnerability (EUR/MWh),size(*2.2)) legend(off) name(wall,replace) || function y=_b[Wind]*x+_b[_cons],range(Wind) || lfit Intensity Wind if exclude==0, lcolor(ebblue*0.5)





***Solar
cap gen z3=1
replace z3=9 if Country=="BG"
replace z3=12 if Country=="HR"
replace z3=3 if Country=="CH"
replace z3=4 if Country=="HU"
replace z3=3 if Country=="RO"
replace z3=1 if Country=="RS"
replace z3=1 if Country=="LT"
replace z3=3 if Country=="AT"
replace z3=1 if Country=="DK"
replace z3=2 if Country=="NL"
replace z3=7 if Country=="CZ"
replace z3=9 if Country=="EE"

replace z3=12 if Country=="SI"


robreg mm Intensity Solar if exclude==0
matrix b = e(b)
twoway scatter Intensity Solar if   exclude==0, mlabel(labels) mlabvposition(z3) mlabsize(*2.03) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("D)",position(11) size(*1.75)) xtitle("Solar share",size(*2.2)) ylabel(,labsize(*2) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*2)) ytitle(Vulnerability (EUR/MWh),size(*2.2)) name(sall,replace) || function y=_b[Solar]*x+_b[_cons],range(Solar) || lfit Intensity Solar if exclude==0, lcolor(ebblue*0.5)




***Coal
cap gen z4=1
replace z4=3 if Country=="PT"
replace z4=3 if Country=="FI"
replace z4=5 if Country=="HU"
replace z4=10 if Country=="NO"
replace z4=3 if Country=="CH"
replace z4=1 if Country=="AT"
replace z4=2 if Country=="RO"
replace z4=12 if Country=="SI"
replace z4=3 if Country=="NL"
replace z4=12 if Country=="ES"
replace z4=4 if Country=="DE"
replace z4=6 if Country=="EE"
replace z4=3 if Country=="CZ"

robreg mm Intensity Coal if exclude==0
matrix b=e(b)
twoway scatter Intensity Coal if exclude==0, mlabel(labels) mlabvposition(z4) mlabsize(*2.03) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("F)",position(11) size(*1.75)) xtitle("Coal share",size(*2.2)) ylabel(,labsize(*2) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*2)) ytitle(Vulnerability (EUR/MWh),size(*2.2)) name(call,replace) ||function y=_b[Coal]*x+_b[_cons],range(Coal) || lfit Intensity Coal if exclude==0, lcolor(ebblue*0.5)





***Hydro
cap gen z5=1
replace z5=3 if Country=="PT"
replace z5=9 if Country=="FI"
replace z5=4 if Country=="EE"
replace z5=3 if Country=="RS"
replace z5=12 if Country=="SI"
replace z5=2 if Country=="DE"
replace z5=9 if Country=="NO"
replace z5=3 if Country=="PL"
replace z5=2 if Country=="AT"
replace z5=8 if Country=="BE"
replace z5=12 if Country=="IT"
replace z5=3 if Country=="NL"
replace z5=3 if Country=="LT"
replace z5=3 if Country=="PL"
replace z5=2 if Country=="FR"
replace z5=2 if Country=="RO"
replace z5=11 if Country=="CZ"


robreg mm Intensity HydroDispatch  if exclude==0
matrix b = e(b)
twoway scatter Intensity HydroDispatch if  exclude==0, mlabel(labels) mlabvposition(z5) mlabsize(*2.03) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("G)",position(11) size(*1.75)) xtitle("Hydro (dispatch) share",size(*2.2)) ylabel(,labsize(*2) grid gmax gmin glwidth(0.5)) xlabel(,labsize(*2)) ytitle(Vulnerability (EUR/MWh),size(*2.2)) legend(off) name(hall,replace) || function y=_b[HydroDispatch]*x+_b[_cons],range(HydroDispatch) || lfit Intensity HydroDispatch if exclude==0, lcolor(ebblue*0.5)




***Natural Gas
cap gen z6=1
replace z6=3 if Country=="RO"
replace z6=9 if Country=="GR"
replace z6=4 if Country=="PT"
replace z6=3 if Country=="BG"
replace z6=4 if Country=="CH"
replace z6=12 if Country=="SI"
replace z6=12 if Country=="DE"
replace z6=3 if Country=="BE"
replace z6=9 if Country=="NO"
replace z6=11 if Country=="EE"
replace z6=3 if Country=="AT"
replace z6=4 if Country=="PL"
replace z6=6 if Country=="FI"
replace z6=3 if Country=="CZ"
replace z6=3 if Country=="RS"



robreg mm Intensity Gas if exclude==0
matrix b = e(b)
twoway scatter Intensity Gas if   exclude==0, mlabel(labels) mlabvposition(z6) mlabsize(*2.03) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("B)",position(11) size(*1.75)) xtitle("Natural Gas share",size(*2.2)) ylabel(,labsize(*2) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*2)) ytitle(Vulnerability (EUR/MWh),size(*2.2)) name(gall,replace) || function y=_b[Gas]*x+_b[_cons],range(Gas) || lfit Intensity Gas if exclude==0, lcolor(ebblue*0.5)


// graph combine gall nall sall wall call hall,  name(alldays,replace) col(3) altshrink 
// graph export Fig7_adjustDKNL.jpg,replace



***Combine 6 panels into one figure
//graph combine gall nall sall fig8 wall call hall,  name(alldays,replace) row(2) altshrink 
graph combine gall nall sall wall call hall,  name(alldays,replace) col(3) altshrink 

**Contains multivariate regression result for Panel A
use Fig8,clear

grstyle clear
grstyle init
grstyle set plain


**Sorting for Panel A
// sort coef
// gen n= _n
// labmask n, values(source)


**Horizontal
graph twoway (rcap  ul ll n if source=="Natural Gas", lwidth(*1) msize(*1.1) horizontal lcolor(maroon*0.92) name(fig8,replace)) || (rcap  ul ll n if source!="Natural Gas", lwidth(*1) msize(*1.1) horizontal lcolor(emidblue*0.65)) || (dot coef n if source!="Natural Gas", horizontal mcolor(emidblue%65) msymbol(d)  msize(*1.1) ytitle("") barw(1.3) legend(off)) || (dot coef n if source=="Natural Gas", horizontal xtitle(" Vulnerability (EUR/MWh)", size(*0.77)) mcolor(maroon%87) msymbol(d)  msize(*1.1) ytitle("") title("A)",position(11) size(*0.59)) barw(1.3) legend(off) ylabel(,valuelabel labsize(*0.72) angle(horizontal)) xlabel(,labsize(*0.72)) xline(0, lwidth(*1))  fysize(30)) 

//horizontal
graph combine fig8 alldays, rows(2) imargin(b=0.05 t=0.05)
graph export Fig7_combined.jpg,replace


****Multivariate regression****
replace Solar = 0.038 in 7 //Denmark educated guess (based on ourworldindata.org Electricity Mix Profile) for solar so it does not omit entire country for missing this value in the regression
reg Intensity Solar Wind Nuc Coal Gas HydroDispatch,vce(robust)
label var RE "IRE"
label var Nuc "Nuclear"

test Solar Wind Nuc Coal Gas HydroDispatch 
*Output table but it is heavily edited later manually
outreg2 using TableSImultivariateShares.doc, replace se label bdec(2) nocons adds(F-test,r(F),Prob>F,`r(p)') adjr2
replace Solar = . in 7

