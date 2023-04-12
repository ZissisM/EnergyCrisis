clear all

*cd "C:\Users\rbajo\Desktop"

*use allcountries_genshares

use allcountries_genshares.dta

set scheme cleanplots



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



graph hbar Coal Gas HydroDispatch Nuc RE total_Others, over(labels, ///
		relabel(1 " " 2 "Austria" 3 " " 4 "Belgium" 5 "Bulgaria" 6 " " 7 "Croatia" 8 "Czech" 9 "Denmark" 10 "Estonia" 11 "Finland" ///
		12 "France" 13 "Germany" 14 "Greece" 15 "Hungary" 16 "Italy" 17 "Lithuania" 18 "Netherlands" 19 "Norway" 20 "Poland" 21 "Portugal" 22 "Romania" 23 "Serbia" 24 "Slovakia" 25 "Slovenia" 26 "Spain" 27 "Switzerland" 28 "") ///
		sort(order))  ysize(6) xsize(8) ///
		stack percent ytitle("Percentage of generation mix (%)") ///
		bar(1, color(sienna*0.6)) bar(2, color(midgreen*0.6)) bar(3, color(orange*0.6)) ///
		bar(4, color(red*0.6)) bar(5, color(midblue*0.5)) bar(6, color(dknavy*0.6)) ///
		legend(label(1 "Coal") label(2 "Natural gas") label(3 "Hydro") label(4 "Nuclear") label(5 "IRE") label(6 "Other") size(small) position(6) rows(2)) graphregion(margin(l+20))

//graph export "C:\Users\Raúl\Desktop\mixes.pdf", as(pdf) name("Mixes")

