**Fig 7 with gen shares TOTAL gen (no imports or exports) excluding October 
clear

use allcountries_noOct
**gen shares for no October


***to adjust for DK and NL
// replace Solar = 0.038 in 7
// replace Solar = 0.0947 in 17

*back to original
//replace Solar = 0.0230995 in 17
//replace Solar = . in 7




***Nuclear
*Change label orientations to avoid overlap
cap gen z1=1
replace z1=3 if Country=="RO"
replace z1=6 if Country=="FI"
replace z1=10 if Country=="CH"
replace z1=3 if Country=="HR"
replace z1=2 if Country=="NO"
replace z1=1 if Country=="PT"
replace z1=2 if Country=="NL"
replace z1=3 if Country=="SI"
replace z1=3 if Country=="DE"
replace z1=4 if Country=="SK"
replace z1=11 if Country=="DK"
replace z1=5 if Country=="EE"
replace z1=12 if Country=="HU"

*Robust mm regression, and lfit
robreg mm Intensity Nuc if exclude==0
matrix b=e(b)
twoway scatter Intensity Nuc if exclude==0, mlabel(labels) mlabvposition(z1) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("B",position(11) size(*1.3)) xtitle("Nuclear share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Estimated Average Price Change,size(*1.5)) name(nall,replace) ||function y=_b[Nuc]*x+_b[_cons],range(Nuc) || lfit Intensity Nuc if exclude==0, lcolor(ebblue*0.5)





***Wind
cap gen z2=1
replace z2=3 if Country=="FI"
replace z2=9 if Country=="DK"
replace z2=3 if Country=="PT"
replace z2=5 if Country=="NL"
replace z2=3 if Country=="LT"
replace z2=3 if Country=="RS"
replace z2=3 if Country=="BG"
replace z2=1 if Country=="BE"
replace z2=2 if Country=="NO"
replace z2=3 if Country=="SI"
replace z2=1 if Country=="RO"
replace z2=1 if Country=="PL"
replace z2=1 if Country=="EE"
replace z2=4 if Country=="HU"
replace z2=3 if Country=="GR"
replace z2=12 if Country=="ES"
replace z2=3 if Country=="FR"
replace z2=7 if Country=="RS"
replace z2=4 if Country=="SK"
replace z2=3 if Country=="DE"
replace z2=3 if Country=="AT"


robreg mm Intensity Wind if exclude==0
matrix b = e(b)
twoway scatter Intensity Wind if  exclude==0, mlabel(labels) mlabvposition(z2) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("D",position(11) size(*1.3)) xtitle("Wind share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) xlabel(,labsize(*1.4)) ytitle(Estimated Average Price Change,size(*1.5)) legend(off) name(wall,replace) || function y=_b[Wind]*x+_b[_cons],range(Wind) || lfit Intensity Wind if exclude==0, lcolor(ebblue*0.5)






***Solar 
cap gen z3=1
replace z3=1 if Country=="BG"
replace z3=12 if Country=="HR"
replace z3=3 if Country=="CH"
replace z3=3 if Country=="HU"
replace z3=5 if Country=="RO"
replace z3=1 if Country=="RS"
replace z3=1 if Country=="LT"
replace z3=2 if Country=="AT"
replace z3=1 if Country=="DK"
replace z3=2 if Country=="NL"
replace z3=1 if Country=="SI"
replace z3=4 if Country=="SK"
replace z3=4 if Country=="CZ"




robreg mm Intensity Solar if exclude==0
matrix b = e(b)
twoway scatter Intensity Solar if   exclude==0, mlabel(labels) mlabvposition(z3) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("C",position(11) size(*1.3)) xtitle("Solar share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Estimated Average Price Change,size(*1.5)) name(sall,replace) || function y=_b[Solar]*x+_b[_cons],range(Solar) || lfit Intensity Solar if exclude==0, lcolor(ebblue*0.5)





***Coal
cap gen z4=1
replace z4=3 if Country=="PT"
replace z4=3 if Country=="FI"
replace z4=3 if Country=="HU"
replace z4=1 if Country=="NO"
replace z4=3 if Country=="CH"
replace z4=1 if Country=="AT"
replace z4=1 if Country=="RO"
replace z4=1 if Country=="SI"
replace z4=3 if Country=="NL"
replace z4=2 if Country=="ES"
replace z4=4 if Country=="DE"
replace z4=4 if Country=="EE"
replace z4=1 if Country=="HR"
replace z4=3 if Country=="SK"
replace z4=6 if Country=="PT"


robreg mm Intensity Coal if exclude==0
matrix b=e(b)
twoway scatter Intensity Coal if exclude==0, mlabel(labels) mlabvposition(z4) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("E",position(11) size(*1.3)) xtitle("Coal share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Estimated Average Price Change,size(*1.5)) name(call,replace) ||function y=_b[Coal]*x+_b[_cons],range(Coal) || lfit Intensity Coal if exclude==0, lcolor(ebblue*0.5)





***Hydro
cap gen z5=1
replace z5=1 if Country=="PT"
replace z5=4 if Country=="FI"
replace z5=4 if Country=="EE"
replace z5=2 if Country=="RS"
replace z5=10 if Country=="SI"
replace z5=4 if Country=="DE"
replace z5=9 if Country=="NO"
replace z5=3 if Country=="PL"
replace z5=2 if Country=="AT"
replace z5=9 if Country=="BE"
replace z5=12 if Country=="IT"
replace z5=5 if Country=="NL"
replace z5=3 if Country=="LT"
replace z5=2 if Country=="PL"
replace z5=2 if Country=="FR"
replace z5=12 if Country=="RO"
replace z5=7 if Country=="DK"
replace z5=11 if Country=="ES"
replace z5=3 if Country=="BG"
replace z5=3 if Country=="GR"




robreg mm Intensity HydroDispatch  if exclude==0
matrix b = e(b)
twoway scatter Intensity HydroDispatch if  exclude==0, mlabel(labels) mlabvposition(z5) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("F",position(11) size(*1.3)) xtitle("Hydro (dispatch) share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) xlabel(,labsize(*1.4)) ytitle(Estimated Average Price Change,size(*1.5)) legend(off) name(hall,replace) || function y=_b[HydroDispatch]*x+_b[_cons],range(HydroDispatch) || lfit Intensity HydroDispatch if exclude==0, lcolor(ebblue*0.5)




***Natural Gas
cap gen z6=1
replace z6=12 if Country=="RO"
replace z6=9 if Country=="GR"
replace z6=1 if Country=="PT"
replace z6=2 if Country=="SK"
replace z6=12 if Country=="BG"
replace z6=1 if Country=="CH"
replace z6=3 if Country=="FR"
replace z6=4 if Country=="SI"
replace z6=3 if Country=="DE"
replace z6=1 if Country=="BE"
replace z6=4 if Country=="NO"
replace z6=11 if Country=="EE"
replace z6=6 if Country=="AT"
replace z6=7 if Country=="PL"
replace z6=6 if Country=="FI"
replace z6=3 if Country=="CZ"
replace z6=5 if Country=="RS"
replace z6=3 if Country=="HU"


robreg mm Intensity Gas if exclude==0
matrix b = e(b)
twoway scatter Intensity Gas if   exclude==0, mlabel(labels) mlabvposition(z6) mlabsize(*1.4) msymbol(d) mcolor(maroon%75) msize(*1.65) color(navy) graphregion(lstyle(none)) title("A",position(11) size(*1.3)) xtitle("Gas share",size(*1.5)) ylabel(,labsize(*1.4) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Estimated Average Price Change,size(*1.5)) name(gall,replace) || function y=_b[Gas]*x+_b[_cons],range(Gas) || lfit Intensity Gas if exclude==0, lcolor(ebblue*0.5)




***Combine into 1 figure in correct order
graph combine gall nall sall wall call hall ,  name(alldays,replace) col(3) altshrink 
graph export Fig7_noOct.jpg,replace

