*All 6 energy shares vs. Relative Vulnerability 
*Not actually used to generate any Figure used, but interesting to see if desired 

*where intensity is relative vulnerability !


* cd ~/Downloads/Nature_Energy_Crisis/Datasets/Combined datasets
*in combined datasets

grstyle clear
grstyle init
grstyle set grid
clear
set scheme white_tableau 
use allcountries_genshares

*If want to exclude a country put =1
replace exclude= 0 if Country=="BG"
replace exclude= 0 if Country=="PT"


**Orient labels for readability

****Nuclear Panels
robreg mm absV Nuc if exclude==0
matrix b = e(b)

**Overnight
twoway scatter absV Nuc if exclude==0, mlabel(labels) mlabvposition(x1) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("A)",position(11) size(*1.3)) xtitle("Nuclear share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) xlabel(,labsize(*1.4)) ytitle(Absolute Vulnerability (EUR/MWh),size(*1.5))  legend(off) name(n1,replace) || function y=_b[Nuc]*x+_b[_cons],range(Nuc) || lfit absV Nuc if exclude==0, lcolor(ebblue*0.5)



***Solar Panels

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


robreg mm absV Solar if exclude==0
matrix b = e(b)
twoway scatter absV Solar if   exclude==0, mlabel(labels) mlabvposition(x4) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("B)",position(11) size(*1.3)) xtitle("Solar share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Absolute Vulnerability (EUR/MWh),size(*1.5)) name(n2,replace) || function y=_b[Solar]*x+_b[_cons],range(Solar) || lfit absV Solar if exclude==0, lcolor(ebblue*0.5)



*****Wind Panels



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


robreg mm absV Wind if exclude==0
matrix b = e(b)
twoway scatter absV Wind if   exclude==0, mlabel(labels) mlabvposition(x7) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("C)",position(11) size(*1.3)) xtitle("Wind share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Absolute Vulnerability (EUR/MWh),size(*1.5)) name(n3,replace) || function y=_b[Wind]*x+_b[_cons],range(Wind) || lfit absV Wind if exclude==0, lcolor(ebblue*0.5)


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


robreg mm absV Coal
matrix b=e(b)
twoway scatter absV Coal if  exclude==0, mlabel(labels) mlabvposition(x11) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("D)",position(11) size(*1.3)) xtitle("Coal share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Absolute Vulnerability (EUR/MWh),size(*1.5)) name(n4,replace)||function y=_b[Coal]*x+_b[_cons],range(Coal) ||lfit absV Coal  if exclude==0, lcolor(ebblue*0.5)



***Natural Gas





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



robreg mm absV Gas
matrix b=e(b)
twoway scatter absV Gas if    exclude==0, mlabel(labels) mlabvposition(x4) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("F)",position(11) size(*1.3)) xtitle("Gas share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Absolute Vulnerability (EUR/MWh),size(*1.5)) name(n6,replace) ||function y=_b[Gas]*x+_b[_cons],range(Gas) || lfit absV Gas if    exclude==0, lcolor(ebblue*0.5)



***Hydro Dispatchable


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



robreg mm absV HydroDispatch
matrix b=e(b)
twoway scatter absV HydroDispatch if   exclude==0, mlabel(labels) mlabvposition(x7) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("E)",position(11) size(*1.3)) xtitle("Hydro (dispatch) share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Absolute Vulnerability (EUR/MWh),size(*1.5)) name(n5,replace)||function y=_b[HydroDispatch]*x+_b[_cons],range(HydroDispatch) || lfit absV HydroDispatch if   exclude==0, lcolor(ebblue*0.5)



*Combine into one figure
//graph combine n1 n2 n3  w1 w2 w3 s1 s2 s3,  name(allday,replace) col(3) altshrink 
graph combine  n1 n2 n3 n4 n5 n6 , name(allday,replace) col(3) altshrink 

graph export SI_absVscatters.jpg, replace







