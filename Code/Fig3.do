*Used to generated Figure 3, creates 7 scatter plots and a table/figure(G)
*only use the 4 scatter plots in main figure, the rest relegated to SI

*use the allcountries_genshares in: 
* cd ~/Downloads/Nature_Energy_Crisis/Datasets/Combined datasets

**use "/Users/ZMarmarelis/Documents/GitHub/Nature_Energy_Crisis/Datasets/Combined datasets/allcountries_genshares.dta"

use allcountries_genshares
**Generate Fig 3



***Do not use absolute vulnerability panels anymore (A B C)-- renamed to just vulnerability, which was relative vulnerability (the ones that we use in Fig 3). 

**to adjust for DK and NL
replace Solar = 0.038 in 7
replace Solar = 0.0946 in 17

*back to how data is downloaded (for now assumed that DK has 0.038 to avoid missing data)
//replace Solar = 0 in 7
replace Solar = 0.0230995 in 17

*IRE computation
replace solar_wind_hydror=Solar+Wind+Hydro_R
*Decarbonized computation
replace lowcarb = solar_wind_hydror+Nuc+HydroDispatch

**SI PANEL

*orientation of labels on plots
replace m1=1 if Country=="DK"
replace m1=9 if Country=="AT"
replace m1=4 if Country=="RS"
replace m1=3 if Country=="BE"
replace m1=6 if Country=="FR"
replace m1=4 if Country=="CH"
replace m1=11 if Country=="BG"
replace m1=3 if Country=="SK"
replace m1=2 if Country=="CZ"
replace m1=2 if Country=="SI"
replace m1=1 if Country=="HR"
replace m1=4 if Country=="LT"
replace m1=3 if Country=="FI"
replace m1=5 if Country=="EE"
replace m1=12 if Country=="NL"
replace m1=2 if Country=="RS"
replace m1=3 if Country=="DE"
replace m1=2 if Country=="RO"
replace m1=9 if Country=="HU"
replace m1=3 if Country=="PL"
replace m1=9 if Country=="NO"





*mm for robust regression to discount outliers
robreg mm absV solar_wind_hydror if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
twoway scatter absV solar_wind_hydror if exclude==0, mlabel(labels) mlabvposition(m1) mlabsize(*1.3) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("B)",position(11) size(*1.4)) xtitle("IRE share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Absolute Vulnerability (EUR/MWh),size(*1.47)) name(ai,replace) ||function y=_b[solar_wind_hydror]*x+_b[_cons],range(solar_wind_hydror) || lfit absV solar_wind_hydror if exclude==0, lcolor(ebblue*0.5)



**Panel B**

robreg mm Intensity solar_wind_hydror if exclude==0
cap gen m2=9 if Country=="DK"
replace m2=9 if Country=="AT"
replace m2=9 if Country=="RS"
replace m2=12 if Country=="BE"
replace m2=1 if Country=="PL"
replace m2=8 if Country=="CH"
replace m2=1 if Country=="BG"
replace m2=3 if Country=="FI"
replace m2=2 if Country=="HU"
replace m2=11 if Country=="CZ"
replace m2=1 if Country=="DE"
replace m2=1 if Country=="ES"
replace m2=5 if Country=="IT"




robreg mm Intensity solar_wind_hydror if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
twoway scatter Intensity solar_wind_hydror if exclude==0, mlabel(labels) mlabvposition(m2) mlabsize(*1.3) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("B)",position(11) size(*1.4)) xtitle("IRE share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Vulnerability (EUR/MWh),size(*1.47)) name(ri,replace) ||function y=_b[solar_wind_hydror]*x+_b[_cons],range(solar_wind_hydror) || lfit Intensity solar_wind_hydror if exclude==0, lcolor(ebblue*0.5)



**SI PANEL

replace m3=4 if Country=="PL"
replace m3=9 if Country=="DK"
replace m3=3 if Country=="AT"
replace m3=9 if Country=="RS"
replace m3=4 if Country=="BE"
replace m3=11 if Country=="CH"
replace m3=3 if Country=="RO"
replace m3=12 if Country=="DK"
replace m3=9 if Country=="NO"
replace m3=3 if Country=="HU"
replace m3=5 if Country=="FR"
replace m3=9 if Country=="BG"
replace m3=1 if Country=="SI"
replace m3=8 if Country=="CZ"
replace m3=3 if Country=="SK"
replace m3=8 if Country=="LT"
replace m3=2 if Country=="EE"
replace m3=2 if Country=="FI"




robreg mm absV lowcarb if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
twoway scatter absV lowcarb if exclude==0, mlabel(labels) mlabvposition(m3) mlabsize(*1.3) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("A)",position(11) size(*1.4)) xtitle("Decarbonized energy share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Absolute Vulnerability (EUR/MWh),size(*1.47)) name(ad,replace) ||function y=_b[lowcarb]*x+_b[_cons],range(lowcarb) || lfit absV lowcarb if exclude==0, lcolor(ebblue*0.5)


** Panel A ****

robreg mm Intensity lowcarb if exclude==0
matrix b=e(b)
cap gen z7=1 
replace z7= 3 if Country=="CZ"
replace z7= 3 if Country=="LT"
replace z7= 12 if Country=="DE"
replace z7= 9 if Country=="NO"
replace z7= 10 if Country=="CH"
replace z7= 3 if Country=="RO"
replace z7= 12 if Country=="HU"
replace z7= 6 if Country=="SI"
replace z7= 3 if Country=="FI"
replace z7= 3 if Country=="EE"
replace z7= 5 if Country=="PL"
replace z7= 3 if Country=="PT"
replace z7= 4 if Country=="RS"
replace z7= 8 if Country=="AT"
replace z7= 12 if Country=="BG"
replace z7= 2 if Country=="BE"


twoway scatter Intensity lowcarb if exclude==0, mlabel(labels) mlabvposition(z7) mlabsize(*1.3) msymbol(d) mcolor(maroon%75) msize(*1.5) color(navy) graphregion(lstyle(none)) title("A)",position(11) size(*1.4)) xtitle("Decarbonized energy share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.5)) ytitle(Vulnerability (EUR/MWh),size(*1.47)) name(rd,replace) || function y=_b[lowcarb]*x+_b[_cons],range(lowcarb) || lfit Intensity lowcarb if exclude==0, lcolor(ebblue*0.5) 


** SI PANEL 
robreg mm absV Gas if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
replace m4=2 if Country=="DK"
replace m4=4 if Country=="BE"
replace m4=2 if Country=="RS"
replace m4=4 if Country=="RO"
replace m4=4 if Country=="PL"
replace m4=3 if Country=="CH"
replace m4=1 if Country=="EE"
replace m4=3 if Country=="HR"
replace m4=12 if Country=="SK"
replace m4=6 if Country=="SI"
replace m4=3 if Country=="NO"
replace m4=10 if Country=="BG"
replace m4=9 if Country=="GR"
replace m4=1 if Country=="AT"
replace m4=2 if Country=="CZ"
replace m4=3 if Country=="LT"
replace m4=3 if Country=="FR"
replace m4=3 if Country=="FI"
replace m4=3 if Country=="DE"





twoway scatter absV Gas if exclude==0, mlabel(labels) mlabvposition(m4) mlabsize(*1.27) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("C)",position(11) size(*1.4)) xtitle("Natural gas share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Absolute Vulnerability (EUR/MWh),size(*1.47)) name(ag,replace) ||function y=_b[Gas]*x+_b[_cons],range(Gas) || lfit absV Gas if exclude==0, lcolor(ebblue*0.5)



**Panel C **
robreg mm Intensity Gas if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
replace m1=9 if Country=="DK"
replace m1=6 if Country=="BE"
replace m1=3 if Country=="RS"
replace m1=4 if Country=="RO"
replace m1=1 if Country=="CH"
replace m1=3 if Country=="AT"
replace m1=12 if Country=="SI"
replace m1=4 if Country=="FI"
replace m1=1 if Country=="DE"
replace m1=7 if Country=="CZ"
replace m1=9 if Country=="GR"
replace m1=11 if Country=="BG"
replace m1=3 if Country=="HU"
replace m1=4 if Country=="PT"
replace m1=5 if Country=="NO"



twoway scatter Intensity Gas if exclude==0, mlabel(labels) mlabvposition(m1) mlabsize(*1.27) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("C)",position(11) size(*1.4)) xtitle("Natural gas share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Vulnerability (EUR/MWh),size(*1.47)) name(rg,replace) ||function y=_b[Gas]*x+_b[_cons],range(Gas) || lfit Intensity Gas if exclude==0, lcolor(ebblue*0.5)






*graph combine ad ai ag rd ri rg ,  name(aggreg2,replace) col(3) altshrink 

graph combine rd ri rg ,  name(aggreg2,replace) col(3) altshrink 


**panel G (Table/figure)
*Calculation for the wholesale prices at each gas price using the pass-through coefficients
*Edited later by confirming values manually as some code did not turn out exact
foreach y in "AT" "BE" "BG" "CH" "CZ" "DE"  "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK"  {

use `y'_new
cap drop `y'estidd2-`y'estidd41
*main estimation
reg wholesale_test gas_p RE_gen c.load##c.load i.month#i.hour i.dow#i.hour, cluster(dt)
margins,at(gas_p=(5(1)600)) post
*saved to variables
matrix est=e(at),e(b)'
svmat est,names(`y'estiddss)
save `y'_new,replace
}


*Output to excel
putexcel set fig6bs, replace


putexcel A1 = "Country"
putexcel B1= "100cap"
putexcel C1= "150cap"

local myrow = 2

foreach y in "AT" "BE" "BG" "CH" "CZ" "DE"  "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK"  {
use `y'_new
cap drop `y'estidd2-`y'estidd41
save `y'_new,replace

tabstat `y'estid1 if ceil(`y'estidd42)==100,save
putexcel B`myrow' = matrix(r(StatTotal))
tabstat `y'estid1 if ceil(`y'estidd42)==150,save
putexcel C`myrow' = matrix(r(StatTotal))
save `y'_new,replace

local myrow = `myrow' + 1
}

*in github folder called fig6b.dta
use fig6b 
//or fig6b2 for different, full year sample!

grstyle clear
grstyle init
grstyle set legend 6

// *potential ordering of variables simialr to Fig 1 (not used!)
// gen order=0
// replace order = 1 if labels=="Denmark"
// replace order = 2 if labels=="Estonia"
// replace order = 3 if labels=="Finland"
// replace order = 4 if labels=="Lithuania"
// replace order = 5 if labels=="Netherlands"
// replace order = 6 if labels=="Norway"
// //replace order = 7 if labels=="A"
// replace order = 7 if labels=="Austria"
// replace order = 8 if labels=="Belgium"
// replace order = 9 if labels=="Czech"
// replace order = 10 if labels=="France"
// replace order = 11 if labels=="Germany"
// replace order = 12 if labels=="Switzerland "
// //replace order = 14 if labels=="B"
// replace order = 13 if labels=="Bulgaria"
// replace order = 14 if labels=="Hungary"
// replace order = 15 if labels=="Poland"
// replace order = 16 if labels=="Romania"
// replace order = 17 if labels=="Serbia"
// replace order = 18 if labels=="Slovakia"
// //replace order = 21 if labels=="C"
// replace order = 19 if labels=="Croatia"
// replace order = 20 if labels=="Greece"
// replace order = 21 if labels=="Italy"
// replace order = 22 if labels=="Portugal"
// replace order = 23 if labels=="Slovenia"
// replace order = 24 if labels=="Spain"
 

gsort lowcarb
cap drop n n2
gen n=_n

*drop RO because such low pass-through that it did not make sense to do this and was not meaningful (for our main sample, but not for full year sample!)
//values(labels) for full year sample
labmask n,values(Country)
twoway bar cap150 cap125 cap100 n,horizontal fintensity(30 60 90) fcolor(forest_green ..) ylabel(1(1)23,valuelabel labsize(*0.98) angle(horizontal)) ysc(r(0 1)) ytitle("") xtitle("Necessary Natural Gas Price Cap (EUR/MWh)",size(*1.25)) title("D)",position(11) size(*1.2)) name(fig6b,replace) legend(size(*0.95) rows(3) order( 3 2 1) ) xlabel(#10, labsize(*1.1)) xline(180)



**Responsivness/slope plot for 5 countries --> Figure 5 last panel and also used to estimate panel 3D (value at 180)

*saved as "country"f for each of the predicted prices based on each natural gas price increment, used for panel H
foreach y in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK" {
	
use `y'_new
reg wholesale_test gas_p RE_gen c.load##c.load i.month#i.hour i.dow#i.hour, cluster(dt)
margins,at(gas_p=(40(10)260)) saving(`y'f,replace)

}
** New Panel E (and also EDF Fig 4)

putexcel set fig3H, replace


putexcel A1 = "Country"
putexcel B1= "price180"

local myrow = 2

*Omitted RO because of very low pass-through/no responsiveness to gas price for wholesale electricity price
foreach y in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI""FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RS" "SI" "SK" {
use `y'f

putexcel A`myrow' = "`y'"
tabstat _margin if _at1==180,save
putexcel B`myrow' = matrix(r(StatTotal))

local myrow = `myrow' + 1
}

*save this as price180 (at a 180 EUR/MWh cap) variable manually FOR  PANEL E


cap gen r2=1
replace r2=9 if Country=="Switzerland"
replace r2=3 if Country=="SI"
replace r2=12 if Country=="Czech"
replace r2=6 if Country=="Bulgaria"


*regress the price at 180 EUR/MWh on the decarbonized share
robreg mm price180 lowcarb 
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
twoway scatter price180 lowcarb, mlabel(Country) mlabvposition(r2) mlabsize(*1.3) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("E)",position(11) size(*1.4)) xtitle("Decarbonized energy share",size(*1.42)) ylabel(,labsize(*1.55) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.41)) ytitle(Max. Electricity Price under EU N.G. Price Cap (EUR/MWh),size(*1.2)) name(capg,replace) ||function y=_b[lowcarb]*x+_b[_cons],range(lowcarb) || lfit price180 lowcarb, lcolor(ebblue*0.5)


***FIGURE 3 COMBINED
graph combine  fig6b capg,altshrink name(f3d,replace)
graph combine rd ri rg fig6b capg,altshrink rows(2)
**This one
graph combine aggreg2 f3d,altshrink rows(2) name(Fig3Fin,replace)




**EDF Fig 4, same as Panel H (above scatter) but using IRE share instead of decarbonized share

cap gen r1=1
replace r1=1 if Country=="DK"
replace r1=9 if Country=="AT"
replace r1=4 if Country=="RS"
replace r1=2 if Country=="BE"
replace r1=1 if Country=="FR"
replace r1=3 if Country=="CH"
replace r1=4 if Country=="BG"
replace r1=3 if Country=="SK"
replace r1=2 if Country=="CZ"
replace r1=1 if Country=="SI"
replace r1=1 if Country=="HR"
replace r1=4 if Country=="LT"
replace r1=3 if Country=="FI"
replace r1=3 if Country=="EE"
replace r1=4 if Country=="NL"
replace r1=2 if Country=="RS"
replace r1=3 if Country=="DE"
replace r1=1 if Country=="RO"
replace r1=1 if Country=="HU"
replace r1=3 if Country=="PL"
replace r1=6 if Country=="ES"
replace r1=12 if Country=="CZ"


**Panel E (IRE) SI

robreg mm price180 IRE 
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
twoway scatter price180 IRE, mlabel(Country) mlabvposition(r1) mlabsize(*1.3) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) xtitle("IRE share",size(*1.42)) ylabel(,labsize(*1.55) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.41)) ytitle(Max. Electricity Price under EU N.G. Price Cap (EUR/MWh),size(*1.23)) name(capg,replace) ||function y=_b[IRE]*x+_b[_cons],range(IRE) || lfit price180 IRE, lcolor(ebblue*0.5)






***New panel for Hydro Dispatch (SI)
cap gen m7=1
robreg mm Intensity HydroDispatch if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
replace m7=3 if Country=="NL"
replace m7=3 if Country=="LT"
replace m7=3 if Country=="EE"
replace m7=3 if Country=="CZ"
replace m7=12 if Country=="PL"
replace m7=6 if Country=="SI"
replace m7=3 if Country=="FR"
replace m7=1 if Country=="BE"
replace m7=3 if Country=="RS"
replace m7=3 if Country=="PT"
replace m7=9 if Country=="NO"
replace m7=2 if Country=="HU"
replace m7=2 if Country=="DE"

twoway scatter Intensity HydroDispatch if exclude==0, mlabel(labels) mlabvposition(m7) mlabsize(*1.27) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("F)",position(11) size(*1.4)) xtitle("Hydro (dispatch) share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Vulnerability (EUR/MWh),size(*1.47)) name(rhd,replace) ||function y=_b[HydroDispatch]*x+_b[_cons],range(HydroDispatch) || lfit Intensity HydroDispatch if exclude==0, lcolor(ebblue*0.5)





*** Seperate IRE (SI)

*Solar

*orientation of labels on plots
replace m1=1 if Country=="DK"
replace m1=9 if Country=="AT"
replace m1=4 if Country=="RS"
replace m1=3 if Country=="BE"
replace m1=6 if Country=="FR"
replace m1=4 if Country=="CH"
replace m1=11 if Country=="BG"
replace m1=3 if Country=="SK"
replace m1=2 if Country=="CZ"
replace m1=2 if Country=="SI"
replace m1=1 if Country=="HR"
replace m1=4 if Country=="LT"
replace m1=3 if Country=="FI"
replace m1=5 if Country=="EE"
replace m1=12 if Country=="NL"
replace m1=2 if Country=="RS"
replace m1=3 if Country=="DE"
replace m1=2 if Country=="RO"
replace m1=9 if Country=="HU"
replace m1=3 if Country=="PL"
replace m1=3 if Country=="NO"


*mm for robust regression to discount outliers
robreg mm Intensity Solar if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
twoway scatter Intensity Solar if exclude==0, mlabel(labels) mlabvposition(m1) mlabsize(*1.3) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("B)",position(11) size(*1.4)) xtitle("Solar share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Vulnerability (EUR/MWh),size(*1.47)) name(sol,replace) ||function y=_b[Solar]*x+_b[_cons],range(Solar) || lfit Intensity Solar if exclude==0, lcolor(ebblue*0.5)


*Wind

*orientation of labels on plots
replace m1=10 if Country=="DK"
replace m1=9 if Country=="AT"
replace m1=4 if Country=="RS"
replace m1=3 if Country=="BE"
replace m1=6 if Country=="FR"
replace m1=4 if Country=="CH"
replace m1=2 if Country=="BG"
replace m1=3 if Country=="SK"
replace m1=12 if Country=="CZ"
replace m1=1 if Country=="SI"
replace m1=1 if Country=="HR"
replace m1=4 if Country=="LT"
replace m1=3 if Country=="FI"
replace m1=3 if Country=="EE"
replace m1=12 if Country=="NL"
replace m1=3 if Country=="RS"
replace m1=3 if Country=="DE"
replace m1=4 if Country=="RO"
replace m1=9 if Country=="HU"
replace m1=3 if Country=="PL"
replace m1=12 if Country=="NO"
replace m1=12 if Country=="SI"



*mm for robust regression to discount outliers
robreg mm Intensity Wind if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
twoway scatter Intensity Wind if exclude==0, mlabel(labels) mlabvposition(m1) mlabsize(*1.3) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("C)",position(11) size(*1.4)) xtitle("Wind share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Vulnerability (EUR/MWh),size(*1.47)) name(win,replace) ||function y=_b[Wind]*x+_b[_cons],range(Wind) || lfit Intensity Wind if exclude==0, lcolor(ebblue*0.5)

graph combine rd sol win rg ag, rows(2) col(4) altshrink




*Hydro-run-of-river

replace exclude=1 if Hydro_R==0
replace exclude=0

replace exclude=1 if Country=="AT"
*orientation of labels on plots
replace m1=3 if Country=="DK"
replace m1=9 if Country=="AT"
replace m1=4 if Country=="RS"
replace m1=1 if Country=="BE"
replace m1=6 if Country=="FR"
replace m1=4 if Country=="CH"
replace m1=2 if Country=="BG"
replace m1=3 if Country=="SK"
replace m1=12 if Country=="CZ"
replace m1=1 if Country=="SI"
replace m1=1 if Country=="HR"
replace m1=3 if Country=="LT"
replace m1=3 if Country=="FI"
replace m1=5 if Country=="EE"
replace m1=12 if Country=="NL"
replace m1=3 if Country=="RS"
replace m1=3 if Country=="DE"
replace m1=4 if Country=="RO"
replace m1=9 if Country=="HU"
replace m1=3 if Country=="PL"
replace m1=12 if Country=="NO"
replace m1=12 if Country=="SI"



*mm for robust regression to discount outliers
robreg mm Intensity Hydro_R if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
twoway scatter Intensity Hydro_R if exclude==0, mlabel(labels) mlabvposition(m1) mlabsize(*1.3) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("",position(11) size(*1.4)) xtitle("Hydro-run-of-river share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Vulnerability (EUR/MWh),size(*1.47)) name(win,replace) ||function y=_b[Hydro_R]*x+_b[_cons],range(Hydro_R) || lfit Intensity Hydro_R if exclude==0, lcolor(ebblue*0.5)




