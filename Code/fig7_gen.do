**Fig 7 generation with energy shares with denominator as TOTAL gen (no imports included)
clear

use allcountries_genshares


**to adjust for DK and NL
//replace Solar = 0.038 in 7
//replace Solar = 0.0947 in 17

**back to how data is downloaded
// replace Solar = 0.0230995 in 17
// replace Solar = . in 7

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
twoway scatter Intensity Nuc if exclude==0, mlabel(labels) mlabvposition(z1) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("B",position(11) size(*1.3)) xtitle("Nuclear share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Estimated Average Price Change,size(*1.5)) name(nall,replace) ||function y=_b[Nuc]*x+_b[_cons],range(Nuc) || lfit Intensity Nuc if exclude==0, lcolor(ebblue*0.5)




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
replace z2=9 if Country=="PL"
replace z2=3 if Country=="EE"
replace z2=2 if Country=="HU"
replace z2=9 if Country=="CZ"
replace z2=3 if Country=="AT"


robreg mm Intensity Wind if exclude==0
matrix b = e(b)
twoway scatter Intensity Wind if  exclude==0, mlabel(labels) mlabvposition(z2) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("D",position(11) size(*1.3)) xtitle("Wind share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) xlabel(,labsize(*1.4)) ytitle(Estimated Average Price Change,size(*1.5)) legend(off) name(wall,replace) || function y=_b[Wind]*x+_b[_cons],range(Wind) || lfit Intensity Wind if exclude==0, lcolor(ebblue*0.5)





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
twoway scatter Intensity Solar if   exclude==0, mlabel(labels) mlabvposition(z3) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("C",position(11) size(*1.3)) xtitle("Solar share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Estimated Average Price Change,size(*1.5)) name(sall,replace) || function y=_b[Solar]*x+_b[_cons],range(Solar) || lfit Intensity Solar if exclude==0, lcolor(ebblue*0.5)




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
twoway scatter Intensity Coal if exclude==0, mlabel(labels) mlabvposition(z4) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("E",position(11) size(*1.3)) xtitle("Coal share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Estimated Average Price Change,size(*1.5)) name(call,replace) ||function y=_b[Coal]*x+_b[_cons],range(Coal) || lfit Intensity Coal if exclude==0, lcolor(ebblue*0.5)





***Hydro
cap gen z5=1
replace z5=3 if Country=="PT"
replace z5=9 if Country=="FI"
replace z5=4 if Country=="EE"
replace z5=3 if Country=="RS"
replace z5=6 if Country=="SI"
replace z5=2 if Country=="DE"
replace z5=9 if Country=="NO"
replace z5=3 if Country=="PL"
replace z5=2 if Country=="AT"
replace z5=9 if Country=="BE"
replace z5=12 if Country=="IT"
replace z5=3 if Country=="NL"
replace z5=3 if Country=="LT"
replace z5=3 if Country=="PL"
replace z5=2 if Country=="FR"
replace z5=2 if Country=="RO"
replace z5=11 if Country=="CZ"


robreg mm Intensity HydroDispatch  if exclude==0
matrix b = e(b)
twoway scatter Intensity HydroDispatch if  exclude==0, mlabel(labels) mlabvposition(z5) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("F",position(11) size(*1.3)) xtitle("Hydro (dispatch) share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) xlabel(,labsize(*1.4)) ytitle(Estimated Average Price Change,size(*1.5)) legend(off) name(hall,replace) || function y=_b[HydroDispatch]*x+_b[_cons],range(HydroDispatch) || lfit Intensity HydroDispatch if exclude==0, lcolor(ebblue*0.5)




***Natural Gas
cap gen z6=1
replace z6=3 if Country=="RO"
replace z6=9 if Country=="GR"
replace z6=4 if Country=="PT"
replace z6=3 if Country=="BG"
replace z6=5 if Country=="CH"
replace z6=4 if Country=="SI"
replace z6=12 if Country=="DE"
replace z6=3 if Country=="BE"
replace z6=12 if Country=="NO"
replace z6=11 if Country=="EE"
replace z6=3 if Country=="AT"
replace z6=3 if Country=="PL"
replace z6=6 if Country=="FI"
replace z6=3 if Country=="CZ"


robreg mm Intensity Gas if exclude==0
matrix b = e(b)
twoway scatter Intensity Gas if   exclude==0, mlabel(labels) mlabvposition(z6) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("A",position(11) size(*1.3)) xtitle("Natural Gas share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Estimated Average Price Change,size(*1.5)) name(gall,replace) || function y=_b[Gas]*x+_b[_cons],range(Gas) || lfit Intensity Gas if exclude==0, lcolor(ebblue*0.5)





***Combine 6 panels into one figure
//graph combine gall nall sall fig8 wall call hall,  name(alldays,replace) row(2) altshrink 
graph combine gall nall sall wall call hall,  name(alldays,replace) col(3) altshrink 

graph export Fig7_Gen.jpg,replace


****Multivariate regression****
replace Solar = 0.038 in 7 //Denmark educated guess for solar so it does not omit entire country for missing this value in the regression
replace Solar = Solar*100
replace Wind = Wind*100
replace Nuc = Nuc*100
replace Gas = Gas*100
replace Coal = Coal*100
replace HydroDispatch = HydroDispatch*100
reg Intensity Solar Wind Nuc Coal Gas HydroDispatch,vce(robust)
label var RE "IRE"
label var Nuc "Nuclear"

test Solar Wind Nuc Coal Gas HydroDispatch 
*Output table but it is heavily edited later manually
outreg2 using TableSImultivariateShares.doc, replace se label bdec(2) nocons adds(F-test,r(F),Prob>F,`r(p)') adjr2
replace Solar = . in 7

