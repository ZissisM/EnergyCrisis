// use "/Users/ZMarmarelis/Documents/GitHub/Nature_Energy_Crisis/Datasets/Combined datasets/allcountries_genshares.dta"
**Generate Fig3


**to adjust for DK and NL
replace Solar = 0.038 in 7
//replace Solar = 0.0947 in 17

*back to how data is downloaded
//replace Solar = 0.0230995 in 17
//replace Solar = . in 7

**B

cap gen m1=1
replace m1=1 if Country=="DK"
replace m1=9 if Country=="AT"
replace m1=4 if Country=="RS"
replace m1=3 if Country=="BE"
replace m1=6 if Country=="FR"
replace m1=4 if Country=="CH"
replace m1=11 if Country=="BG"
replace m1=3 if Country=="SK"
replace m1=3 if Country=="CZ"
replace m1=1 if Country=="SI"
replace m1=1 if Country=="HR"
replace m1=3 if Country=="LT"
replace m1=3 if Country=="FI"
replace m1=6 if Country=="EE"
replace m1=12 if Country=="NL"
replace m1=2 if Country=="RS"
replace m1=3 if Country=="DE"
replace m1=2 if Country=="RO"
replace m1=12 if Country=="HU"
replace m1=3 if Country=="PL"
replace m1=3 if Country=="PT"
replace m1=10 if Country=="NO"






robreg mm absV solar_wind_hydror if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
twoway scatter absV solar_wind_hydror if exclude==0, mlabel(labels) mlabvposition(m1) mlabsize(*1.3) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("B)",position(11) size(*1.4)) xtitle("IRE share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Absolute Vulnerability (EUR/MWh),size(*1.47)) name(ai,replace) ||function y=_b[solar_wind_hydror]*x+_b[_cons],range(solar_wind_hydror) || lfit absV solar_wind_hydror if exclude==0, lcolor(ebblue*0.5)



**E

robreg mm Intensity solar_wind_hydror if exclude==0
cap gen m2=1
cap gen m2=9 if Country=="DK"
replace m2=9 if Country=="AT"
replace m2=9 if Country=="RS"
replace m2=12 if Country=="BE"
replace m2=1 if Country=="PL"
replace m2=8 if Country=="CH"
replace m2=11 if Country=="BG"
replace m2=3 if Country=="FI"
replace m2=2 if Country=="HU"
replace m2=12 if Country=="CZ"
replace m2=1 if Country=="DE"
replace m2=1 if Country=="ES"
replace m2=5 if Country=="IT"
replace m2=3 if Country=="PT"
replace m2=3 if Country=="DE"
replace m2=3 if Country=="NO"
replace m2=3 if Country=="RO"




robreg mm Intensity solar_wind_hydror if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
twoway scatter Intensity solar_wind_hydror if exclude==0, mlabel(labels) mlabvposition(m2) mlabsize(*1.3) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("E)",position(11) size(*1.4)) xtitle("IRE share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Relative Vulnerability (EUR/MWh),size(*1.47)) name(ri,replace) ||function y=_b[solar_wind_hydror]*x+_b[_cons],range(solar_wind_hydror) || lfit Intensity solar_wind_hydror if exclude==0, lcolor(ebblue*0.5)



**A
cap gen m3=1
replace m3=3 if Country=="PL"
replace m3=9 if Country=="DK"
replace m3=3 if Country=="AT"
replace m3=9 if Country=="RS"
replace m3=3 if Country=="BE"
replace m3=4 if Country=="CH"
replace m3=6 if Country=="RO"
replace m3=12 if Country=="DK"
replace m3=9 if Country=="NO"
replace m3=3 if Country=="HU"
replace m3=5 if Country=="FR"
replace m3=1 if Country=="BG"
replace m3=1 if Country=="SI"
replace m3=9 if Country=="CZ"
replace m3=3 if Country=="SK"
replace m3=3 if Country=="LT"
replace m3=2 if Country=="EE"
replace m3=3 if Country=="FI"




robreg mm absV lowcarb if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
twoway scatter absV lowcarb if exclude==0, mlabel(labels) mlabvposition(m3) mlabsize(*1.3) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("A)",position(11) size(*1.4)) xtitle("Decarbonized energy share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Absolute Vulnerability (EUR/MWh),size(*1.47)) name(ad,replace) ||function y=_b[lowcarb]*x+_b[_cons],range(lowcarb) || lfit absV lowcarb if exclude==0, lcolor(ebblue*0.5)


**D

robreg mm Intensity lowcarb if exclude==0
matrix b=e(b)
cap gen z7=1 
replace z7= 9 if Country=="CZ"
replace z7= 3 if Country=="LT"
replace z7= 1 if Country=="DE"
replace z7= 9 if Country=="NO"
replace z7= 1 if Country=="CH"
replace z7= 3 if Country=="RO"
replace z7= 12 if Country=="HU"
replace z7= 6 if Country=="SI"
replace z7= 3 if Country=="FI"
replace z7= 3 if Country=="EE"
replace z7= 5 if Country=="PL"
replace z7= 3 if Country=="PT"
replace z7= 4 if Country=="RS"
replace z7= 3 if Country=="AT"
replace z7= 10 if Country=="BG"
replace z7= 2 if Country=="BE"


twoway scatter Intensity lowcarb if exclude==0, mlabel(labels) mlabvposition(z7) mlabsize(*1.3) msymbol(d) mcolor(maroon%75) msize(*1.5) color(navy) graphregion(lstyle(none)) title("D)",position(11) size(*1.4)) xtitle("Decarbonized energy share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.5)) ytitle(Relative Vulnerability (EUR/MWh),size(*1.47)) name(rd,replace) || function y=_b[lowcarb]*x+_b[_cons],range(lowcarb) || lfit Intensity lowcarb if exclude==0, lcolor(ebblue*0.5) 


**C
robreg mm absV Gas if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
cap gen m4=1
replace m4=2 if Country=="DK"
replace m4=4 if Country=="BE"
replace m4=2 if Country=="RS"
replace m4=4 if Country=="RO"
replace m4=3 if Country=="PL"
replace m4=3 if Country=="CH"
replace m4=1 if Country=="EE"
replace m4=3 if Country=="HR"
replace m4=12 if Country=="SK"
replace m4=4 if Country=="SI"
replace m4=4 if Country=="NO"
replace m4=10 if Country=="BG"
replace m4=9 if Country=="GR"
replace m4=12 if Country=="AT"
replace m4=3 if Country=="CZ"
replace m4=4 if Country=="LT"
replace m4=3 if Country=="FR"
replace m4=3 if Country=="FI"
replace m4=1 if Country=="DE"
replace m4=1 if Country=="AT"





twoway scatter absV Gas if exclude==0, mlabel(labels) mlabvposition(m4) mlabsize(*1.27) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("C)",position(11) size(*1.4)) xtitle("Natural gas share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Absolute Vulnerability (EUR/MWh),size(*1.47)) name(ag,replace) ||function y=_b[Gas]*x+_b[_cons],range(Gas) || lfit absV Gas if exclude==0, lcolor(ebblue*0.5)



**F
robreg mm Intensity Gas if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
replace m1=9 if Country=="DK"
replace m1=6 if Country=="BE"
replace m1=3 if Country=="RS"
replace m1=4 if Country=="RO"
replace m1=1 if Country=="CH"
replace m1=2 if Country=="AT"
replace m1=12 if Country=="SI"
replace m1=4 if Country=="FI"
replace m1=1 if Country=="DE"
replace m1=9 if Country=="CZ"
replace m1=9 if Country=="GR"
replace m1=12 if Country=="BG"
replace m1=3 if Country=="HU"
replace m1=5 if Country=="NO"
replace m1=3 if Country=="PT"
replace m1=3 if Country=="PL"




twoway scatter Intensity Gas if exclude==0, mlabel(labels) mlabvposition(m1) mlabsize(*1.27) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("F)",position(11) size(*1.4)) xtitle("Natural gas share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Relative Vulnerability (EUR/MWh),size(*1.47)) name(rg,replace) ||function y=_b[Gas]*x+_b[_cons],range(Gas) || lfit Intensity Gas if exclude==0, lcolor(ebblue*0.5)




graph combine ad ai ag rd ri rg ,  name(aggreg2,replace) col(3) altshrink 
