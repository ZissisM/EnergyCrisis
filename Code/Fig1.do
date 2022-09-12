***Figure 1 Prices Graph Generation

**Panel A genration **

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
twoway line cz_pr_wkm be_pr_wkm it_pun_wkm es_pr_wkm delu_wkm fi_pr_wkm pt_pr_wkm fr_pr_wkm gr_pr_wkm ro_pr_wkm hr_pr_wkm hu_pr_wkm nl_pr_wkm sk_pr_wkm si_pr_wkm rs_pr_wkm  ch_pr_wkm pl_pr_wkm ee_pr_wkm wk, name(b1,replace) lwidth(thin) yaxis(1) ytitle( "Wholesale Electricity Price (Euro/MWh)") xlabel(#4,labsize(*1.1)) lcolor(bluishgray ...) ylabel(,labsize(*1.2) axis(1))  || line gas_p_wk wk, yaxis(2) ytitle("TTF Natural Gas Price (Euro/MWh)",size(*1.2) axis(2)) ylabel(,labsize(*1.2) axis(2)) lcolor(black) lwidth(thick) title("A)", size(*1.4) position(11)) xtitle("") xlabel(13 "April 1 2021" 26 "July 1 2021" 44 "November 1 2021",labsize(*1.1)) || line at_pr_wkm  dk1_wkm lt_pr_wkm no_pr_wkm wk, lwidth(thin) yaxis(1) ytitle( "Wholesale Electricity Price (Euros/MWh)",size(*1.3)) xlabel(#4) lcolor(bluishgray ...) || line avg_wholesale_wk wk, yaxis(1) lcolor(red) lwidth(thick) xlabel(13 "April 1 2021" 26 "July 1 2021" 35 "September 1 2021" 44 "November 1 2021")  legend(position(6) size(*1.15) order( 1 24 25) rows(2)  label (1  "Individiual Country Wholesale  Price") label(2 "Natural Gas Price") label(3 ("Average Wholesale Electricity Price"))) 


*Norway, and Denmark weighted average (by load) over their TSOs
*Italy also but done automatically (PUN price) 



** Generate new thresholds of maximum prices for Panel B **

foreach y in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL"  "NO" "PL" "PT" "RO" "RS" "SI" "SK" {

use `y'_new,clear
cap drop N tot thresh_1 thresh_2 thresh_3 thresh_4
cap gen N=_n
cap egen tot=max(N)
*if prices above a certain threshold
cap gen thresh_1= 1 if wholesale_test>=200
replace thresh_1=0 if wholesale_test<200
cap gen thresh_2= 1 if wholesale_test>=250
replace thresh_2=0 if wholesale_test<250
cap gen  thresh_3= 1 if wholesale_test>=300
replace thresh_3= 0 if wholesale_test<300
cap gen thresh_4=1 if wholesale_test>=350
replace thresh_4=0 if wholesale_test<350



cap drop t1 t2 t3 t4
*count how many times over each threshold
egen t1=sum(thresh_1)
egen t2=sum(thresh_2)
egen t3=sum(thresh_3)
egen t4=sum(thresh_4)


cap drop tp_1 tp_2 tp_3 tp_4
cap gen tp_1 = t1/tot
cap gen tp_2 = t2/tot
cap gen tp_3=t3/tot
cap gen tp_4=t4/tot
}

*Create excel spreadhseet with all country values for this
putexcel set thresh_max, replace

putexcel A1 = "Country"
putexcel B1="tp_1"
putexcel C1="tp_2"
putexcel D1="tp_3"
putexcel E1="tp_4"

local myrow = 2

foreach y in "AT" "BE" "BG" "CH" "CZ" "DE"  "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" " NO" "PL" "PT" "RO" "RS" "SI" "SK" {
	
	use `y'_new,clear
	
	putexcel A`myrow' = "`y'"
	tabstat tp_1, save
	putexcel B`myrow' = matrix(r(StatTotal))
	tabstat tp_2, save
	putexcel C`myrow' = matrix(r(StatTotal))
	tabstat tp_3, save
	putexcel D`myrow' = matrix(r(StatTotal))
	tabstat tp_4, save
	putexcel E`myrow' = matrix(r(StatTotal))
	
	local myrow = `myrow' + 1

	 }

*make it percent
cap drop tp_1_p tp_2_p tp_3_p tp_4_p
cap gen tp_1_p = tp_1*100
cap gen tp_2_p = tp_2*100
cap gen tp_3_p = tp_3*100
cap gen tp_4_p = tp_4*100


cap label var tp_1_p "Wholesale Price > 200 Euros"
cap label var tp_2_p "Wholesale Price > 250 Euros"
cap label var tp_3_p "Wholesale Price > 300 Euros"
cap label var tp_4_p "Wholesale Price > 350 Euros"

*** Panel B generation ***

*Import it into Fig1_b
use Fig1_b,clear

*Legend on bottom
grstyle clear
grstyle init
grstyle set legend 6

**manually label n8 for regions of country groupings in editor 
*use n8 as the manual sorting order 
labmask n8,values(country)
twoway bar tp_1_p tp_2_p tp_3_p tp_4_p n9,horizontal fintensity(30 50 70 90) fcolor(maroon ..) ylabel(0(0.1)1) ylabel(1(1)28,valuelabel labsize(vsmall) angle(horizontal)) ysc(r(0 1)) ytitle("") xtitle("Percent of Total Hours",size(*1.25)) title("B)",position(11) size(*1.4)) name(c_grad,replace) legend(size(*1.2) rows(2) margin(zero)) xlabel(,labsize(*1.2))

//graph combine b1 historicbox c_grad nowbox , name(c1,replace) altshrink

*** PANEL C generation ****
use wholesale_both,clear


*****labels
label var at_pr "Austria: April 2021-November 2021"
label var be_pr "Belgium: April 2021-November 2021"
label var bg_pr "Bulgaria: April 2021-November 2021"
label var ch_pr "Switzerland: April 2021-November 2021"
label var cz_pr "Czech: April 2021-November 2021"
label var de_pr "Germany: April 2021-November 2021"
label var dk_avg "Denmark: April 2021-November 2021"
label var ee_pr "Estonia: April 2021-November 2021"
label var es_pr "Spain: April 2021-November 2021"
label var fi_pr "Finland: April 2021-November 2021"
label var fr_pr "France: April 2021-November 2021"
label var hr_pr "Croatia: April 2021-November 2021"
label var hu_pr "Hungary: April 2021-November 2021"
label var it_pun "Italy: April 2021-November 2021"
label var nl_pr "Netherlands: April 2021-November 2021"
label var lt_pr "Lithuania: April 2021-November 2021"
label var no_pr "Norway: April 2021-November 2021"
label var pl_pr "Poland: April 2021-November 2021"
label var pt_pr "Portugal: April 2021-November 2021"
label var ro_pr "Romania: April 2021-November 2021"
label var rs_pr "Serbia: April 2021-November 2021"
label var si_pr "Slovenia: April 2021-November 2021"
label var sk_pr "Slovakia: April 2021-November 2021"



label var AT_h "Austria"
label var BE_h "Belgium"
label var BG_h "Bulgaria"
label var CH_h "Switzerland"
label var CZ_h "Czech"
label var DE_h "Germany"
label var DK_h "Denmark"
label var EE_h "Estonia"
label var ES_h "Spain"
label var FI_h "Finland"
label var FR_h "France"
label var GR_h "Greece"
label var HR_h "Croatia"
label var HU_h "Hungary"
label var IT_h "Italy"
label var LT_h "Lithuania"
label var NL_h "Netherlands"
label var NO_h "Norway"
label var PL_h "Poland"
label var PT_h "Portugal"
label var RO_h "Romania"
label var RS_h "Serbia"
label var SI_h "Slovenia"
label var SK_h "Slovakia"
label var north_h "Northern Countries"
label var south_h "Southern Countries"
label var east_h "Eastern Countries"
label var central_h "Central Countries"







*saved as h1b and the other one, changed the legends manually and colors
*make legend on the right, inside the figure 
grstyle clear
grstyle init
grstyle set legend 3,inside
**Upper panel for historic prices 
 graph box north_h  DK_h  EE_h FI_h LT_h NL_h NO_h central_h AT_h BE_h CZ_h FR_h DE_h CH_h east_h BG_h HU_h PL_h RO_h RS_h SK_h south_h HR_h GR_h IT_h PT_h SI_h ES_h, horizontal nooutsides name(historicbox,replace) note("") b1title("Historic Wholesale Price (EUR/MWh)",size(*1.1)) intensity(75) lintensity(75) legend(size(*1.15)) ylabel(,labsize(*1.5)) yscale(titlegap(medium)) box(16, color(gs5)) box(17, color(sienna))  box(18, color(navy)) box(19, color(sand*1.2)) box(20, color(dkorange*1.2)) box(21, color(olive_teal*1.2)) box(22, color(lavender))  box(23, color(maroon)) box(24, color(emerald)) box(25, color(magenta*0.6)) box(26,color(gold*0.7)) box(27,color(dkorange)) box(28, color(purple))
 *Lower panel for sample prices 
graph box north_h dk1 ee_pr fi_pr lt_pr nl_pr no_pr central_h at_pr be_pr cz_pr fr_pr de_pr ch_pr east_h bg_pr hu_pr pl_pr ro_pr rs_pr sk_pr south_h hr_pr gr_pr it_pun pt_pr si_pr es_pr, nooutsides horizontal name(nowbox,replace) note("") legend(off) b1title("April 2021-November 2021 Wholesale Price (EUR/MWh)",size(*1.1)) intensity(75) lintensity(75) ylabel(,labsize(*1.5)) box(16, color(gs5)) box(17, color(sienna))  box(18, color(navy)) box(19, color(sand*1.2)) box(20, color(dkorange*1.2)) box(21, color(olive_teal*1.2)) box(22, color(lavender))  box(23, color(maroon)) box(24, color(emerald)) yscale(range(0 200)) box(24, color(emerald)) box(25, color(magenta*0.6)) box(26,color(gold*0.7)) box(27,color(dkorange)) box(28, color(purple))

** Panel C -- individual graphs are saved as how they are named
graph combine historicbox nowbox, altshrink rows(2) xcommon title("C)",position(11)) imargin(zero) name(fig1_pc,replace)

***this combine for panels
*Panel a and b
graph combine b1 c_grad, altshrink name(rf,replace)  rows(2)
*panel c (init gr legend if did a or b last )
grstyle clear
grstyle init
grstyle set legend 3,inside
*** Combine all 3 panels
graph combine rf fig1_pc, altshrink












































