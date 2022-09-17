use Fig8,clear

grstyle clear
grstyle init
grstyle set plain

//replace Solar = 0.038 in 7 //Denmark educated guess for solar so it does not omit entire country for missing this value in the regression
//reg Intensity Solar Wind Nuc Coal Gas HydroDispatch 
//label var Nuc "Nuclear"


// sort coef
// gen n= _n
// labmask n, values(source)


**Horizontal
graph twoway (rcap  ul ll n if source=="Natural Gas", lwidth(*1) msize(*1.1) horizontal lcolor(maroon*0.9) name(fig8,replace)) || (rcap  ul ll n if source!="Natural Gas", lwidth(*1) msize(*1.1) horizontal lcolor(maroon*0.4)) || (dot coef n, horizontal xtitle("(EUR/MWh)", size(*0.7)) mcolor(maroon%80) msymbol(d)  msize(*1.1) ytitle("") title("G",position(11) size(*0.45)) barw(1.3) legend(off) ylabel(,valuelabel labsize(*0.6) angle(horizontal)) xlabel(,labsize(*0.6)) xline(0, lwidth(*1))  fysize(20))

//horizontal
graph combine alldays fig8, rows(2) imargin(b=0.1 t=0.1)


**Vertical
graph twoway (rcap  ul ll n, horizontal lcolor(maroon*0.88) name(fig8,replace)) || (dot coef n, horizontal xtitle("(EUR/MWh)", size(*0.7)) mcolor(maroon%80) msymbol(d)  msize(*1.1) ytitle("") title("G",position(11) size(*0.45)) barw(1.3) legend(off) ylabel(,valuelabel labsize(*0.6) angle(horizontal)) xlabel(,labsize(*0.6)) xline(0, lwidth(*1)) fxsize(35)) 

//vertical
graph combine alldays fig8, col(2) imargin(b=1 t=0.5)


//fxsize(40) fysize(100))

//test Solar Wind Nuc Coal Gas HydroDispatch 
*Output table but it is heavily edited later manually
//outreg2 using TableSImultivariateShares.doc, replace se label bdec(2) nocons adds(F-test,r(F),Prob>F,`r(p)') adjr2
//replace Solar = . in 7 //DK back to original 




