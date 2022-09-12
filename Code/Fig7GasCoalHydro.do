***"Figure 7" SI for only Gas Coal and Hydro for the 3 different hour groups (Overnight, Mid-day, Evening)
*Using total generation (no imports) as the denominator for shares

grstyle clear
grstyle init
grstyle set grid
clear
set scheme white_tableau 
use allcountries_genshares

label var Intensity_1 "Overnight: Estimated Average Price Change"
label var Intensity_2 "Mid-day: Estimated Average Price Change"
label var Intensity_3 "Evening: Estimated Average Price Change"

****Coal


**Change label locations

*Overnight
replace x1=1
replace x1=1 if Country=="LT"
replace x1=12 if Country=="FR" 
replace x1=2 if Country=="CH"
replace x1=3 if Country=="HR"
replace x1=12 if Country=="FI"
replace x1=12 if Country=="NL"
replace x1=4 if Country=="PT"
replace x1=1 if Country=="NO"
replace x1=3 if Country=="DK"
replace x1=2 if Country=="AT"
replace x1=2 if Country=="ES"
replace x1=3 if Country=="EE"
replace x1=4 if Country=="BE"
replace x1=1 if Country=="SK"
replace x1= 1 if Country=="HU"
replace x1= 1 if Country=="DE"
replace x1= 3 if Country=="CZ"


*Evening
drop x11
cap gen x11=x1
replace x11= 3 if Country=="BE"
replace x11= 1 if Country=="AT"
replace x11= 2 if Country=="SI"
replace x11= 3 if Country=="FI"
replace x11= 4 if Country=="LT"
replace x11= 3 if Country=="SK"
replace x11= 4 if Country=="HR"
replace x11= 1 if Country=="ES"
replace x11= 4 if Country=="GR"
replace x11= 4 if Country=="HU"
replace x11 = 10 if Country=="DK"
replace x11 = 4 if Country=="IT"
replace x11 = 3 if Country=="IT"
replace x11 = 5 if Country=="CH"
replace x11 = 4 if Country=="EE"
replace x11 = 8 if Country=="NO"
replace x11 = 3 if Country=="DE"
replace x11 = 1 if Country=="PT"



*Mid-day
drop x12
cap gen x12= x1
replace x12 = 4 if Country=="HR"
replace x12 = 1 if Country=="NO"
replace x12 = 4 if Country=="HU"
replace x12 = 3 if Country=="DE"
replace x12 = 3 if Country=="SK"
replace x12 = 3 if Country=="FR"
replace x12 = 1 if Country=="ES"
replace x12 = 1 if Country=="CH"
replace x12 = 1 if Country=="PT"
replace x12 = 3 if Country=="BE"
replace x12 = 3 if Country=="CZ"


robreg mm Intensity_1 Coal
matrix b=e(b)
twoway scatter Intensity_1 Coal  if exclude==0, mlabel(labels) mlabvposition(x1) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("A",position(11) size(*1.3)) xtitle("Coal share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) xlabel(,labsize(*1.4)) ytitle(Overnight: Estimated Average Price Change,size(*1.5))  legend(off) name(n1,replace)||function y=_b[Coal]*x+_b[_cons],range(Coal) ||lfit Intensity_1 Coal if  exclude==0, lcolor(ebblue*0.5)


robreg mm Intensity_2 Coal
matrix b=e(b)
twoway scatter Intensity_2 Coal  if exclude==0, mlabel(labels) mlabvposition(x12) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("B",position(11) size(*1.3)) xtitle("Coal share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Mid-day: Estimated Average Price Change,size(*1.5)) name(n2,replace)||function y=_b[Coal]*x+_b[_cons],range(Coal) ||lfit Intensity_2 Coal if exclude==0, lcolor(ebblue*0.5)

robreg mm Intensity_3 Coal
matrix b=e(b)
twoway scatter Intensity_3 Coal if  exclude==0, mlabel(labels) mlabvposition(x11) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("C",position(11) size(*1.3)) xtitle("Coal share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Evening: Estimated Average Price Change,size(*1.5)) name(n3,replace)||function y=_b[Coal]*x+_b[_cons],range(Coal) ||lfit Intensity_3 Coal  if exclude==0, lcolor(ebblue*0.5)



***Natural Gas

replace x2 = 1
replace x2 = 5 if Country=="NL"
replace x2 = 2 if Country=="LT"
replace x2 = 12 if Country=="HU"
replace x2 = 3 if Country=="RO"
replace x2 = 3 if Country=="AT"
replace x2 = 8 if Country=="CZ"
replace x2 = 4 if Country=="PL"
replace x2 = 3 if Country=="BE"
replace x2 = 12 if Country=="SI"
replace x2=3 if Country=="HR"
replace x2 = 3 if Country=="FI"
replace x2 = 5 if Country=="EE"
replace x2 = 3 if Country=="RS"
replace x2 = 3 if Country=="CH"
replace x2 = 3 if Country=="SK"
replace x2 = 1 if Country=="NO"
replace x2 = 5 if Country=="BG"
replace x2 = 9 if Country=="GR"



replace x3= 1
replace x3 = 5 if Country=="NL"
replace x3 = 1 if Country=="RS"
replace x3 = 6 if Country=="CZ"
replace x3 = 1 if Country=="LT"
replace x3 = 3 if Country=="EE"
replace x3 = 3 if Country=="BG"
replace x3 = 1 if Country=="SI"
replace x3 = 2 if Country=="PL"
replace x3 = 8 if Country=="SK"
replace x3 = 9 if Country=="DK"
replace x3 = 1 if Country=="BE"
replace x3 = 12 if Country=="NO"
replace x3 = 4 if Country=="DE"
replace x3 = 4 if Country=="RO"
replace x3 = 9 if Country=="GR"






drop x4
cap gen x4=1
replace x4 = 4 if Country=="NL"
replace x4 = 3 if Country=="CZ"
replace x4 = 12 if Country=="BE"
replace x4 = 3 if Country=="DE"
replace x4 = 3 if Country=="DK"
replace x4 = 3 if Country=="PL"
replace x4 = 11 if Country=="SI"
replace x4 = 1 if Country=="SK"
replace x4 = 9 if Country=="LT"
replace x4=5 if Country=="RS"
replace x4=12 if Country=="NO"
replace x4=12 if Country=="FI"
replace x4=2 if Country=="AT"
replace x4=7 if Country=="EE"
replace x4=3 if Country=="BG"
replace x4=3 if Country=="CH"
replace x4 = 9 if Country=="GR"







robreg mm Intensity_1 Gas
matrix b=e(b)
twoway scatter Intensity_1 Gas if    exclude==0, mlabel(labels) mlabvposition(x2) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("G",position(11) size(*1.3)) xtitle("Gas share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) xlabel(,labsize(*1.4)) ytitle(Overnight: Estimated Average Price Change,size(*1.5)) legend(off) name(s1,replace) ||function y=_b[Gas]*x+_b[_cons],range(Gas) || lfit Intensity_1 Gas if    exclude==0, lcolor(ebblue*0.5)

robreg mm Intensity_2 Gas
matrix b=e(b)
twoway scatter Intensity_2 Gas if    exclude==0, mlabel(labels) mlabvposition(x3) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("H",position(11) size(*1.3)) xtitle("Gas share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Mid-day: Estimated Average Price Change,size(*1.5)) name(s2,replace) ||function y=_b[Gas]*x+_b[_cons],range(Gas) || lfit Intensity_2 Gas if    exclude==0, lcolor(ebblue*0.5)

robreg mm Intensity_3 Gas
matrix b=e(b)
twoway scatter Intensity_3 Gas if    exclude==0, mlabel(labels) mlabvposition(x4) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("I",position(11) size(*1.3)) xtitle("Gas share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Evening: Estimated Average Price Change,size(*1.5)) name(s3,replace) ||function y=_b[Gas]*x+_b[_cons],range(Gas) || lfit Intensity_3 Gas if    exclude==0, lcolor(ebblue*0.5)



***Hydro Dispatchable

replace x5=1
replace x5=3 if Country=="DK"
replace x5=6 if Country=="ES"
replace x5=1 if Country=="NL"
replace x5=1 if Country=="LT"
replace x5=3 if Country=="RO"
replace x5=5 if Country=="SI"
replace x5=11 if Country=="HU"
replace x5=3 if Country=="FI"
replace x5=9 if Country=="NO"
replace x5=1 if Country=="PL"
replace x5=10 if Country=="SK"
replace x5=1 if Country=="RS"
replace x5=5 if Country=="BE"
replace x5=11 if Country=="GR"
replace x5=3 if Country=="AT"
replace x5=3 if Country=="CZ"
replace x5=1 if Country=="DE"



robreg mm Intensity_1 HydroDispatch
matrix b=e(b)
twoway scatter Intensity_1 HydroDispatch if   exclude==0, mlabel(labels) mlabvposition(x5) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("D",position(11) size(*1.3)) xtitle("Hydro (dispatch) share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) xlabel(,labsize(*1.4)) ytitle(Overnight: Estimated Average Price Change,size(*1.5)) legend(off) name(w1,replace) ||function y=_b[HydroDispatch]*x+_b[_cons],range(HydroDispatch) || lfit Intensity_1 HydroDispatch if   exclude==0, lcolor(ebblue*0.5)






replace x6= 1 if Country=="LT"
replace x6= 4 if Country=="RO"
replace x6= 9 if Country=="NO"
replace x6= 1 if Country=="CH"
replace x6=4 if Country=="SK"
replace x6= 12 if Country=="RS"
replace x6= 2 if Country=="DE"
replace x6= 1 if Country=="SI"
replace x6= 4 if Country=="FR"
replace x6=3 if Country=="FI"
replace x6=3 if Country=="HU"
replace x6=1 if Country=="NL"
replace x6=12 if Country=="BE"
replace x6= 1 if Country=="DK"
replace x6= 3 if Country=="EE"
replace x6= 3 if Country=="CZ"


robreg mm Intensity_2 HydroDispatch
matrix b=e(b)
twoway scatter Intensity_2 HydroDispatch if   exclude==0, mlabel(labels) mlabvposition(x6) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("E",position(11) size(*1.3)) xtitle("Hydro (dispatch) share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Mid-day: Estimated Average Price Change,size(*1.5)) name(w2,replace)||function y=_b[HydroDispatch]*x+_b[_cons],range(HydroDispatch) || lfit Intensity_2 HydroDispatch if   exclude==0, lcolor(ebblue*0.5)








drop x7
cap gen x7=1
replace x7= 2 if Country=="RO"
replace x7= 3 if Country=="AT"
replace x7= 2 if Country=="LT"
replace x7= 5 if Country=="DK"
replace x7= 4 if Country=="SK"
replace x7= 9 if Country=="PL"
replace x7= 3 if Country=="CZ"
replace x7= 9 if Country=="NO"
replace x7= 2 if Country=="RS"
replace x7=11 if Country=="HU"
replace x7=4 if Country=="SK"
replace x7=4 if Country=="EE"
replace x7=5 if Country=="DE"
replace x7=3 if Country=="BG"
replace x7=2 if Country=="RS"
replace x7=4 if Country=="SI"
replace x7=5 if Country=="FI"
replace x7=1 if Country=="BE"
replace x7=1 if Country=="GR"
replace x7=1 if Country=="NL"
replace x7=9 if Country=="FR"
replace x7=3 if Country=="ES"



robreg mm Intensity_3 HydroDispatch
matrix b=e(b)
twoway scatter Intensity_3 HydroDispatch if   exclude==0, mlabel(labels) mlabvposition(x7) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("F",position(11) size(*1.3)) xtitle("Hydro (dispatch) share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Evening: Estimated Average Price Change,size(*1.5)) name(w3,replace)||function y=_b[HydroDispatch]*x+_b[_cons],range(HydroDispatch) || lfit Intensity_3 HydroDispatch if   exclude==0, lcolor(ebblue*0.5)



*Combine into one figure
graph combine n1 n2 n3  w1 w2 w3 s1 s2 s3,  name(allday,replace) col(3) altshrink 
graph export Fig7_GasCoalHydro.jpg, replace


