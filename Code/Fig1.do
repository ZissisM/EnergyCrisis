***Figure 1 Generation

**Panel C genration **

use wholesale_2021

*Set legend at bottom
grstyle clear
grstyle init
grstyle set legend 6 
**Averaged over weekly price to smooth
cap egen gas_p_wk=mean(gas_p), by(wk)

*wholesale weekly prices
//drop be_pr_wkm-no1_wkm no_pr_avg_wkm at_pr_wkm dk_avg_wk
foreach x of varlist be_pr-no1 at_pr no_pr {
  cap	egen `x'_wkm=mean(`x'), by(wk)
 
}


//cap drop avg_wholesale2
*Generate weekly average of all countries
cap egen avg_wholesale2 = rmean(be_pr-delu dk_avg no_pr at_pr)
cap egen avg_wholesale_wk = mean(avg_wholesale2),by(wk)
label var avg_wholesale_wk "Average Wholesale Electricity Price"

*Generate Prices graph -- Panel A
twoway line cz_pr_wkm be_pr_wkm it_pun_wkm es_pr_wkm delu_wkm fi_pr_wkm pt_pr_wkm fr_pr_wkm gr_pr_wkm ro_pr_wkm hr_pr_wkm hu_pr_wkm nl_pr_wkm sk_pr_wkm si_pr_wkm rs_pr_wkm  ch_pr_wkm pl_pr_wkm ee_pr_wkm wk, name(b1,replace) lwidth(thin) yaxis(1) ytitle( "Wholesale Electricity Price (Euro/MWh)") xlabel(#4,labsize(*1.1)) lcolor(bluishgray ...) ylabel(,labsize(*1.2) axis(1))  || line gas_p_wk wk, yaxis(2) ytitle("TTF Natural Gas Price (EUR/MWh)",size(*1.2) axis(2)) ylabel(,labsize(*1.2) axis(2)) lcolor(black) lwidth(thick) title("C)", size(*1.4) position(11)) xtitle("") xlabel(13 "April 1 2021" 26 "July 1 2021" 44 "November 1 2021",labsize(*1.1)) || line at_pr_wkm  dk1_wkm lt_pr_wkm no_pr_wkm wk, lwidth(thin) yaxis(1) ytitle( "Wholesale Electricity Price (EUR/MWh)",size(*1.3)) xlabel(#4) lcolor(bluishgray ...) || line avg_wholesale_wk wk, yaxis(1) lcolor(red) lwidth(thick) xlabel(13 "April 1 2021" 26 "July 1 2021" 35 "September 1 2021" 44 "November 1 2021")  legend(position(6) size(*1.15) order( 1 24 25) rows(2)  label (1  "Individiual Country Wholesale Price") label(2 "Natural Gas Price") label(3 ("Average Wholesale Electricity Price"))) 


*Norway, and Denmark weighted average (by load) over their TSOs
*Italy also but done automatically (PUN price) 






***Panel D

*Triangles added manually in powerpoint according to data from historic wholesale (found in historic.dta or the means in allcountries_*), for mean value from January 2016-April 2021
grstyle clear
grstyle init
grstyle set legend 9
*manually add the rest of the X for historic wholesale prices
*whisker plot for all countries 
graph box north_h DK_pr ee_pr fi_pr lt_pr nl_pr no_pr central_h at_pr be_pr cz_pr fr_pr de_pr ch_pr east_h bg_pr hu_pr pl_pr ro_pr rs_pr sk_pr south_h hr_pr gr_pr it_pun pt_pr si_pr es_pr avg_h avg_wholesale2, nooutsides horizontal name(nowbox,replace) note("") legend(size(*1.08))  b1title("April 2021-October 2021 Wholesale Electricity Price (EUR/MWh)",size(*1.08)) intensity(75) lintensity(75) ylabel(,labsize(*1.3)) box(16, color(gs5) lcolor(black*0.7)) box(17, color(sienna) lcolor(black*0.7))  box(18, color(navy) lcolor(black*0.7)) box(19, color(sand*1.2) lcolor(black*0.7)) box(20, color(dkorange*1.2) lcolor(black*0.7)) box(21, color(olive_teal*1.2) lcolor(black*0.7)) box(22, color(lavender) lcolor(black*0.7))  box(23, color(maroon) lcolor(black*0.7)) box(24, color(emerald) lcolor(black*0.7))  yscale(range(0 200)) box(24, color(emerald) lcolor(black*0.7)) box(25, color(magenta*0.6) lcolor(black*0.7)) box(26,color(gold*0.7) lcolor(black*0.7)) box(27,color(dkorange) lcolor(black*0.7)) box(28, color(purple) lcolor(black*0.7))  box(30, color(blue*0.4) lcolor(black*0.7)) title("D)",position(11) size(*1.4)) yscale(titlegap(medium))



***Panel A

**get the data (all countries decabonized monthly)
use RE_spag

 foreach y in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK" {
//egen `y'_capacity2=mean(`y'_decarb),by(yr)
gen `y'cap2016=`y'_capacity2 if yr==2016
gen `y'cap2021=`y'_capacity2 if yr==2021
 }

 
 *Output decabonized averages for all countries
 putexcel set decarbs_t, replace

putexcel A1 = "Country"
putexcel B1= "decarb_2016"
putexcel C1= "decarb_2021"
//putexcel D1= "decarb_all"
//putexcel E1= "decarb_sample"

local myrow = 2
foreach y in "AT" "BE" "BG" "CH" "CZ" "DE_50Hz" "DE_Tennet" "DE_Amprion" "DE_TransnetBW"  "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO_1" "NO_2" "NO_3" "NO_4" "PL" "PT" "RO" "RS" "SI" "SK"  {

	putexcel A`myrow' = "`y'"
	tabstat `y'cap2016, save
	putexcel B`myrow' = matrix(r(StatTotal))
	tabstat `y'cap2021, save	
	putexcel C`myrow' = matrix(r(StatTotal))
// 	tabstat decarb , save
// 	putexcel D`myrow' = matrix(r(StatTotal))
// 	tabstat decarb if yr==2021 & month>4, save
// 	putexcel E`myrow' = matrix(r(StatTotal))
	

	local myrow = `myrow' + 1

}

***save as deca.dta (all country decabonized averages)

***Panel B generation


cd ~/Downloads/Nature_Energy_Crisis/Datasets/Combined datasets

use deca

grstyle clear
grstyle init
grstyle set legend 6

cap drop region
gen region=""
replace region="North" if labels=="Denmark" | labels=="Estonia" | labels=="Finland" | labels=="Lithuania" | labels=="Netherlands" | labels=="Norway" 
replace region="Central" if labels=="Austria" | labels=="Belgium" | labels=="Czech" | labels=="France" | labels=="Germany" | labels=="Switzerland "  
replace region="Eastern" if labels=="Bulgaria" | labels=="Hungary" | labels=="Poland" | labels=="Romania" | labels=="Serbia"  | labels=="Slovakia"  
replace region="Southern" if labels=="Croatia" | labels=="Greece" | labels=="Italy" | labels=="Portugal" | labels=="Slovenia" | labels=="Spain"

*Spaces
set obs `=_N+1'
replace labels="A" if labels==""
set obs `=_N+1'
replace labels="B" if labels==""
set obs `=_N+1'
replace labels="C" if labels==""
set obs `=_N+1'
replace labels="D" if labels==""
 

 
cap drop order
gen order=0
replace order = 1 if labels=="Denmark"
replace order = 2 if labels=="Estonia"
replace order = 3 if labels=="Finland"
replace order = 4 if labels=="Lithuania"
replace order = 5 if labels=="Netherlands"
replace order = 6 if labels=="Norway"
replace order = 7 if labels=="A"
replace order = 8 if labels=="Austria"
replace order = 9 if labels=="Belgium"
replace order = 10 if labels=="Czech"
replace order = 11 if labels=="France"
replace order = 12 if labels=="Germany"
replace order = 13 if labels=="Switzerland"
replace order = 14 if labels=="B"
replace order = 15 if labels=="Bulgaria"
replace order = 16 if labels=="Hungary"
replace order = 17 if labels=="Poland"
replace order = 18 if labels=="Romania"
replace order = 19 if labels=="Serbia"
replace order = 20 if labels=="Slovakia"
replace order = 21 if labels=="C"
replace order = 22 if labels=="Croatia"
replace order = 23 if labels=="Greece"
replace order = 24 if labels=="Italy"
replace order = 25 if labels=="Portugal"
replace order = 26 if labels=="Slovenia"
replace order = 27 if labels=="Spain"
replace order = 28 if labels=="D"
replace order = 29 if labels=="Average"

 
sort order 
*groupings by geography, 2 dots per line
 
 //graph hbar decarb_2021 decarb_2016,over(labels,sort(order) label(labsize(*0.92)))  graphregion(margin(l+18)) title("A)", position(11) size(*1.4)) legend(label(1 "Decarbonized Energy Share 2021") label(2 "Decarbonized Energy Share 2016") size(small) rows(1)) 
 
 **this one used to generate the panel
 graph dot decarb_2021 decarb_2016,over(labels,sort(order) label(labsize(*0.92))) marker(1,msymbol(d) mcolor(maroon*0.7) msize(*1.8)) marker(2,mcolor(ebblue*0.8) msize(*2))  graphregion(margin(l+18)) title("A)", position(11) size(*1.35)) legend(label(1 "Decarbonized Energy Share 2021") label(2 "Decarbonized Energy Share 2016") size(small) rows(1)) 

 
 
 










	
	






** Panel B


use "/Users/ZMarmarelis/Documents/GitHub/Nature_Energy_Crisis/Datasets/Combined datasets/allcountries_genshares.dta"
//use allcountries_genshares.dta,clear
drop region
gen region=""
replace region="North" if labels=="Denmark" | labels=="Estonia" | labels=="Finland" | labels=="Lithuania" | labels=="Netherlands" | labels=="Norway" 
replace region="Central" if labels=="Austria" | labels=="Belgium" | labels=="Czech" | labels=="France" | labels=="Germany" | labels=="Switzerland "  
replace region="Eastern" if labels=="Bulgaria" | labels=="Hungary" | labels=="Poland" | labels=="Romania" | labels=="Serbia"  | labels=="Slovakia"  
replace region="Southern" if labels=="Croatia" | labels=="Greece" | labels=="Italy" | labels=="Portugal" | labels=="Slovenia" | labels=="Spain"

set obs `=_N+1'
replace labels="A" if labels==""
set obs `=_N+1'
replace labels="B" if labels==""
set obs `=_N+1'
replace labels="C" if labels==""
 

cap drop order
gen order=0
replace order = 1 if labels=="Denmark"
replace order = 2 if labels=="Estonia"
replace order = 3 if labels=="Finland"
replace order = 4 if labels=="Lithuania"
replace order = 5 if labels=="Netherlands"
replace order = 6 if labels=="Norway"
replace order = 7 if labels=="A"
replace order = 8 if labels=="Austria"
replace order = 9 if labels=="Belgium"
replace order = 10 if labels=="Czech"
replace order = 11 if labels=="France"
replace order = 12 if labels=="Germany"
replace order = 13 if labels=="Switzerland "
replace order = 14 if labels=="B"
replace order = 15 if labels=="Bulgaria"
replace order = 16 if labels=="Hungary"
replace order = 17 if labels=="Poland"
replace order = 18 if labels=="Romania"
replace order = 19 if labels=="Serbia"
replace order = 20 if labels=="Slovakia"
replace order = 21 if labels=="C"
replace order = 22 if labels=="Croatia"
replace order = 23 if labels=="Greece"
replace order = 24 if labels=="Italy"
replace order = 25 if labels=="Portugal"
replace order = 26 if labels=="Slovenia"
replace order = 27 if labels=="Spain"
 
sort order 



graph hbar Solar Wind Hydro_R HydroDispatch Nuc, over(labels, label(labsize(*0.85)) ///
		relabel(1 " " 2 "Austria" 3 " " 4 "Belgium" 5 "Bulgaria" 6 " " 7 "Croatia" 8 "Czech" 9 "Denmark" 10 "Estonia" 11 "Finland" ///
		12 "France" 13 "Germany" 14 "Greece" 15 "Hungary" 16 "Italy" 17 "Lithuania" 18 "Netherlands" 19 "Norway" 20 "Poland" 21 "Portugal" 22 "Romania" 23 "Serbia" 24 "Slovakia" 25 "Slovenia" 26 "Spain" 27 "Switzerland" 28 "") ///
		sort(order))  ysize(6) xsize(8) ///
		stack ytitle("Share of generation mix (April 2021-October 2021)") ///
		bar(1, color(orange*0.6)) bar(2, color(midgreen*0.6)) bar(3, color(red*0.6)) ///
		bar(4, color(midblue*0.6)) bar(5, color(sienna*0.5)) bar(6, color(dknavy*0.6)) title("B)",size(*1.2) position(11)) ylabel(,labsize(*1)) ///
		legend(label(1 "Solar") label(2 "Wind") label(3 "Hydro-run") label(4 "Hydro-dispatch") label(5 "Nuclear") size(small) position(6) rows(2)) graphregion(margin(l+18))




		







