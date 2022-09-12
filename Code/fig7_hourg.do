***Generate SI Figure 7 for Nuclear, Solar, Wind panels of hour-groups (instead of entire day), see Extended Data Figure 4


grstyle clear
grstyle init
grstyle set grid
clear
set scheme white_tableau 
use allcountries_genshares

*If want to exclude a country put =1
replace exclude= 0 if Country=="BG"
replace exclude= 0 if Country=="PT"

*Label variables hour-groups of Vulnerability
label var Intensity_1 "Overnight: Estimated Average Price Change"
label var Intensity_2 "Mid-day: Estimated Average Price Change"
label var Intensity_3 "Evening: Estimated Average Price Change"

**Orient labels for readability
*Panel 1 of Nuclear
drop x1
cap gen x1= 2
replace x1= 10 if Country=="FI"
replace x1= 1 if Country=="DE"
replace x1= 10 if Country=="HU"
replace x1=3 if Country=="RS"
replace x1=9 if Country=="AT"
replace x1=3 if Country=="EE"
replace x1=1 if Country=="NO"
replace x1=3 if Country=="GR"
replace x1=1 if Country=="NL"
replace x1=4 if Country=="LT"
replace x1=3 if Country=="DK"
replace x1=3 if Country=="CH"
replace x1=9 if Country=="RO"
replace x1=3 if Country=="NO"
replace x1=3 if Country=="BE"
replace x1=3 if Country=="SI"


**Panel 2 of Nuclear
cap drop x12
cap gen x12= x1
replace x12 = 1 if Country=="LT"
replace x12 = 2 if Country=="DK"
replace x12 = 4 if Country=="GR"
replace x12 = 1 if Country=="PT"
replace x12 = 3 if Country=="HR"
replace x12 = 4 if Country=="RO"
replace x12 = 1 if Country=="RS"
replace x12 = 10 if Country=="AT"




**Panel 3 of Nuclear
cap drop x11
cap gen x11= x1
replace x11= 3 if Country=="NL"
replace x11= 10 if Country=="RS"
replace x11= 3 if Country=="SI"
replace x11= 5 if Country=="EE"
replace x11= 9 if Country=="NO"
replace x11= 3 if Country=="AT"
replace x11= 9 if Country=="PL"
replace x11= 3 if Country=="BG"
replace x11= 3 if Country=="HU"
replace x11= 1 if Country=="RO"
replace x11= 2 if Country=="HR"
replace x11= 1 if Country=="PT"
replace x11= 1 if Country=="CH"
replace x11= 5 if Country=="DK"
replace x11= 4 if Country=="FI"




****Nuclear Panels
robreg mm Intensity_1 Nuc if exclude==0
matrix b = e(b)

**Overnight
twoway scatter Intensity_1 Nuc  if exclude==0, mlabel(labels) mlabvposition(x1) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("A",position(11) size(*1.3)) xtitle("Nuclear share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) xlabel(,labsize(*1.4)) ytitle(Overnight: Estimated Average Price Change,size(*1.5))  legend(off) name(n1,replace) || function y=_b[Nuc]*x+_b[_cons],range(Nuc) || lfit Intensity_1 Nuc if exclude==0, lcolor(ebblue*0.5)


**Mid-day
robreg mm Intensity_2 Nuc if exclude==0
matrix b=e(b)
twoway scatter Intensity_2 Nuc  if exclude==0, mlabel(labels) mlabvposition(x12) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("B",position(11) size(*1.3)) xtitle("Nuclear share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Mid-day: Estimated Average Price Change,size(*1.5)) name(n2,replace) ||function y=_b[Nuc]*x+_b[_cons],range(Nuc) || lfit Intensity_2 Nuc if exclude==0, lcolor(ebblue*0.5)


**Evening
robreg mm Intensity_3 Nuc if exclude==0
matrix b=e(b)
twoway scatter Intensity_3 Nuc if  exclude==0, mlabel(labels) mlabvposition(x11) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("C",position(11) size(*1.3)) xtitle("Nuclear share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Evening: Estimated Average Price Change,size(*1.5)) name(n3,replace) ||function y=_b[Nuc]*x+_b[_cons],range(Nuc) || lfit Intensity_3 Nuc if exclude==0, lcolor(ebblue*0.5)



***Solar Panels

*Overnight
replace x2 = 1
replace x2 = 1 if Country=="NL"
replace x2 = 3 if Country=="LT"
replace x2 = 9 if Country=="HU"
replace x2 = 10 if Country=="RO"
replace x2 = 12 if Country=="AT"
replace x2 = 11 if Country=="CZ"
replace x2 = 3 if Country=="PL"
replace x2 = 3 if Country=="BE"
replace x2 = 4 if Country=="SI"
replace x2 = 10 if Country=="HR"
replace x2 = 2 if Country=="FR"


*Mid-day
replace x3= 1
replace x3 = 12 if Country=="NL"
replace x3 = 3 if Country=="HR"
replace x3 = 3 if Country=="SI"
replace x3 = 3 if Country=="PL"
replace x3 = 3 if Country=="HU"
replace x3 = 3 if Country=="AT"
replace x3 = 3 if Country=="DK"
replace x3 = 3 if Country=="CZ"
replace x3 = 8 if Country=="SK"
replace x3=3 if Country=="RS"



*Evening
cap gen x4=1
replace x4 = 1 if Country=="NL"
replace x4 = 10 if Country=="CH"
replace x4 = 9 if Country=="CZ"
replace x4 = 3 if Country=="BE"
replace x4 = 3 if Country=="DK"
replace x4 = 2 if Country=="SI"
replace x4 = 4 if Country=="BG"
replace x4 = 8 if Country=="PL"
replace x4 = 1 if Country=="SK"
replace x4 = 1 if Country=="LT"
replace x4 = 3 if Country=="HR"
replace x4=11 if Country=="RS"
replace x4=10 if Country=="AT"
replace x4=1 if Country=="NO"
replace x4=3 if Country=="FI"
replace x4=3 if Country=="GR"
replace x4=1 if Country=="EE"


robreg mm Intensity_1 Solar if exclude==0
matrix b = e(b)
twoway scatter Intensity_1 Solar if    exclude==0, mlabel(labels) mlabvposition(x2) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("G",position(11) size(*1.3)) xtitle("Solar share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) xlabel(,labsize(*1.4)) ytitle(Overnight: Estimated Average Price Change,size(*1.5)) legend(off) name(s1,replace) || function y=_b[Solar]*x+_b[_cons],range(Solar) || lfit Intensity_1 Solar if exclude==0, lcolor(ebblue*0.5)


robreg mm Intensity_2 Solar if exclude==0
matrix b = e(b)
twoway scatter Intensity_2 Solar if    exclude==0, mlabel(labels) mlabvposition(x3) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("H",position(11) size(*1.3)) xtitle("Solar share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Mid-day: Estimated Average Price Change,size(*1.5)) name(s2,replace) || function y=_b[Solar]*x+_b[_cons],range(Solar) || lfit Intensity_2 Solar if exclude==0, lcolor(ebblue*0.5)
 

robreg mm Intensity_3 Solar if exclude==0
matrix b = e(b)
twoway scatter Intensity_3 Solar if    exclude==0, mlabel(labels) mlabvposition(x4) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("I",position(11) size(*1.3)) xtitle("Solar share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Evening: Estimated Average Price Change,size(*1.5)) name(s3,replace) || function y=_b[Solar]*x+_b[_cons],range(Solar) || lfit Intensity_3 Solar if exclude==0, lcolor(ebblue*0.5)



*****Wind Panels


*Overnight
replace x5=1
replace x5=11 if Country=="DK"
replace x5=4 if Country=="NL"
replace x5=8 if Country=="LT"
replace x5=9 if Country=="RO"
replace x5=2 if Country=="SI"
replace x5=12 if Country=="HU"
replace x5=1 if Country=="FI"
replace x5=2 if Country=="NO"
replace x5=9 if Country=="PL"
replace x5=1 if Country=="SK"
replace x5=3 if Country=="RS"
replace x5=3 if Country=="ES"
replace x5=1 if Country=="AT"
replace x5=5 if Country=="CH"
replace x5=4 if Country=="EE"
replace x5=3 if Country=="FR"
replace x5=4 if Country=="ES"
replace x5=8 if Country=="BE"
replace x5=9 if Country=="CZ"
replace x5=9 if Country=="GR"


robreg mm Intensity_1 Wind if exclude==0
matrix b = e(b)
twoway scatter Intensity_1 Wind if   exclude==0, mlabel(labels) mlabvposition(x5) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("D",position(11) size(*1.3)) xtitle("Wind share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) xlabel(,labsize(*1.4)) ytitle(Overnight: Estimated Average Price Change,size(*1.5)) legend(off) name(w1,replace) || function y=_b[Wind]*x+_b[_cons],range(Wind) || lfit Intensity_1 Wind if exclude==0, lcolor(ebblue*0.5)




*Mid-day
replace x6= 7 if Country=="LT"
replace x6= 3 if Country=="NO"
replace x6= 1 if Country=="CH"
replace x6= 3 if Country=="SK"
replace x6= 10 if Country=="RS"
replace x6= 1 if Country=="SI"
replace x6= 4 if Country=="BE"
replace x6= 1 if Country=="PL"
replace x6= 5 if Country=="HU"
replace x6= 3 if Country=="HR"

robreg mm Intensity_2 Wind if exclude==0
matrix b = e(b)
twoway scatter Intensity_2 Wind if   exclude==0, mlabel(labels) mlabvposition(x6) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("E",position(11) size(*1.3)) xtitle("Wind share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Mid-day: Estimated Average Price Change,size(*1.5)) name(w2,replace) || function y=_b[Wind]*x+_b[_cons],range(Wind) || lfit Intensity_2 Wind if exclude==0, lcolor(ebblue*0.5)






*Evening
drop x7
cap gen x7=1
replace x7= 2 if Country=="RO"
replace x7= 1 if Country=="AT"
replace x7= 1 if Country=="LT"
replace x7= 9 if Country=="DK"
replace x7= 10 if Country=="PL"
replace x7= 3 if Country=="CZ"
replace x7= 2 if Country=="NO"
replace x7= 10 if Country=="RS"
replace x7= 3 if Country=="FI"
replace x7= 3 if Country=="ES"
replace x7= 6 if Country=="HU"
replace x7= 3 if Country=="HR"
replace x7= 3 if Country=="CH"
replace x7= 3 if Country=="FR"
replace x7= 3 if Country=="DE"


robreg mm Intensity_3 Wind if exclude==0
matrix b = e(b)
twoway scatter Intensity_3 Wind if   exclude==0, mlabel(labels) mlabvposition(x7) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("F",position(11) size(*1.3)) xtitle("Wind share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Evening: Estimated Average Price Change,size(*1.5)) name(w3,replace) || function y=_b[Wind]*x+_b[_cons],range(Wind) || lfit Intensity_3 Wind if exclude==0, lcolor(ebblue*0.5)


graph combine n1 n2 n3  w1 w2 w3 s1 s2 s3,  name(allday,replace) col(3) altshrink 
//graph export Fig6_9Panel_entireday_zeros.jpg,replace
graph export Fig7_NucSolarWind.jpg,replace

