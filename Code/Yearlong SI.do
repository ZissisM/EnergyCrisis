foreach y in "AT" "BE" "BG" "CH" "CZ" "DE_50Hz" "DE" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK" {

	use `y'_year,clear
	//cap drop wholesale_avg
	//cap gen trend=1
	//cap gen dow=dow(dt)
	//cap drop totalgen
	//cap egen totalgen= rowtotal(gen_*)
	replace RE_share=RE_gen/totalgen
	cap replace Gas_share=gen_Gas/totalgen
	drop decarb
	gen decarb = RE_share

	// Add Hydro_share if it exists
	capture confirm variable Hydro_share
	if _rc == 0 {
		replace decarb = decarb + Hydro_share
	}

	// Add Nuc_share if it exists
	capture confirm variable Nuc_share
	if _rc == 0 {
		replace decarb = decarb + Nuc_share
	}


	save `y'_year,replace 
}



	//cap gen ns=_n
	//drop if ns>13886
	// cap drop Imports
	// cap drop Exports 
	// cap drop Imports_share
	// cap drop threshol


	//merge m:1 t using EU_loadsYear,keepusing(load`y')
	//keep if _merge==3
	//drop _merge

	// rename load`y' load

	// cap drop RE_gen
	// gen RE_gen=0

	// capture confirm variable gen_Solar
	// if _rc == 0 replace RE_gen = RE_gen + gen_Solar

	// capture confirm variable gen_Wind_offshore
	// if _rc == 0 replace RE_gen = RE_gen + gen_Wind_offshore

	// capture confirm variable gen_Wind_onshore
	// if _rc == 0 replace RE_gen = RE_gen + gen_Wind_onshore

	// capture confirm variable gen_Hydro_run
	// if _rc == 0 replace RE_gen = RE_gen + gen_Hydro_run


	gen Hydro_Dispatch = 0

	// Check and add gen_Hydro_reservoir if it exists
	capture confirm variable gen_Hydro_reservoir
	if _rc == 0 replace Hydro_Dispatch = Hydro_Dispatch + gen_Hydro_reservoir

	// Check and add gen_Hydro_storage if it exists
	capture confirm variable gen_Hydro_storage
	if _rc == 0 replace Hydro_Dispatch = Hydro_Dispatch + gen_Hydro_storage

	cap drop country_total
	cap egen totalgen= rowtotal(gen_*)

	replace RE_share=RE_gen/totalgen
	cap replace Nuc_share=gen_Nuclear/totalgen
	replace Gas_share=gen_Gas/totalgen
	cap gen Hydro_share=Hydro_Dispatch/totalgen


	// Initialize decarb with RE_share
	gen decarb = RE_share

	// Add Hydro_share if it exists
	capture confirm variable Hydro_share
	if _rc == 0 {
		replace decarb = decarb + Hydro_share
	}

	// Add Nuc_share if it exists
	capture confirm variable Nuc_share
	if _rc == 0 {
		replace decarb = decarb + Nuc_share
	}

	save `y'_year,replace

}


use EU_load


gen double t = clock(time, "YMDhms#")
format t %tc

gen double t_hour = floor(t / 3600000) * 3600000
format t_hour %tc

collapse (mean) load, by(t_hour country)
reshape wide load, i(t_hour) j(country) string

rename t_hour t
gen year=year(t)
gen dt=dofc(t)
format dt %td
gen year=year(dt)
drop if year<2020
gen ns=_n

*new EU_loadsYear.dta



*Create DE combined, and for NO similarly 
use "/Users/ZMarmarelis/Downloads/DE_50Hz_year.dta"
append using DE_TransnetBW_year
append using DE_TenneT_year
append using DE_Amprion_year

preserve
collapse (sum) RE_gen load totalgen Hydro_Dispatch gen_Biomass gen_Gas gen_Hard_coal gen_Hydro_run gen_Nuclear gen_Geothermal gen_Coal_gas gen_Hydro_storage gen_Lignite gen_Oil gen_Other gen_Other_renewable gen_Solar gen_Waste gen_Wind_offshore gen_Wind_onshore (mean) wholesale gas_p [aw=load], by(t)

gen decarb=(gen_Nuclear+ Hydro_Dispatch+ RE_gen+gen_Geothermal+ gen_Other_renewable)/totalgen
gen Gas_share= gen_Gas/totalgen
gen RE_share=RE_gen/totalgen





clear
set scheme white_tableau


 *cd ~/Downloads/Nature_Energy_Crisis/Datasets/Country datasets
*in COUNTRY dataset

**Loop over countries
eststo clear
foreach y in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO"  "PL" "PT" "RO" "RS" "SI" "SK"  {
	use `y'_year
	//if we want to include a time trend instead of monthly fixed effects, trend=1 (only for the case of Greece!)
	*******Edit the function HERE (and below for Greece) to exclude certain months, or omit controls like the specification tests in the SI *******
	if trend==0{
		reg wholesale gas_p RE_gen c.load##c.load c.gas_p#i.hour i.month#i.hour i.dow#i.hour, cluster(dt)
	}

	if trend==1{
		reg wholesale gas_p  RE_gen c.load##c.load c.gas_p#i.hour i.dow#i.hour c.t, cluster(dt)
	}

	
	eststo `y': margins, dydx(gas_p) at(hour=(0(1)23)) vsquish post noestimcheck 

	**Output to excel
	esttab using year_new.csv, replace wide plain mtitles label noobs se
}

***Import excel file as as new dta with all countries estimates, format file for importing
clear
import delimited year_new,  varnames(1) case(preserve) rowrange(4) colrange(2) asdouble numericcols(_all) clear

**generate hour variable
gen hour = _n-1 if _n<25

**rename to standard errors for countries
rename v2 AT_std
rename v4 BE_std
rename v6 BG_std
rename v8 CH_std
rename v10 CZ_std
rename v12 DE_std
rename v14 DK_std
rename v16 EE_std
rename v18 ES_std
rename v20 FI_std
rename v22 FR_std
rename v24 GR_std
rename v26 HR_std
rename v28 HU_std
rename v30 IT_std
rename v32 LT_std
rename v34 NL_std
rename v36 NO_std
rename v38 PL_std
rename v40 PT_std
rename v42 RO_std
rename v44 RS_std
rename v46 SI_std
rename v48 SK_std
**hour at front
order hour, before(AT)
// **create hour-groups
// gen hour_group = 1 if hour < 10
// replace hour_group = 2 if hour>9 & hour<17
// replace hour_group = 3 if hour>16

**Calculate vulnerability metrics
foreach y in "AT" "BE" "BG" "CH" "CZ" "DE"  "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK"  {
	cap drop Hours_PT_`y' `y'_t 
	cap drop Intensity_PT_`y'  elec_`y' 
	// Hours_PT_`y'_1 Hours_PT_`y'_2 Hours_PT_`y'_3 Intensity_PT_`y'_1 Intensity_PT_`y'_2 Intensity_PT_`y'_3 elec_`y'_1 elec_`y'_2 elec_`y'_3
	**t-stat
	cap gen `y'_t = `y'/`y'_std

	**Measure hours of pass-through & intensity
	cap egen Hours_PT_`y' = total(`y'_t>1.96 & `y'>0)
	cap egen Intensity_PT_`y' = sum(`y') if `y'_t>1.96 & `y'>0

// 	**By-hour-groups
// 	cap egen Hours_PT_`y'_1 = total(`y'_t>1.96) if hour_group==1
// 	cap egen Hours_PT_`y'_2 = total(`y'_t>1.96) if hour_group==2
// 	cap egen Hours_PT_`y'_3 = total(`y'_t>1.96) if hour_group==3

// 	cap egen Intensity_PT_`y'_1 = sum(`y') if `y'_t>1.96 & hour_group==1
// 	cap egen Intensity_PT_`y'_2 = sum(`y') if `y'_t>1.96 & hour_group==2
// 	cap egen Intensity_PT_`y'_3 = sum(`y') if `y'_t>1.96 & hour_group==3


	** Predicted Electricity Price: Vulnerability
	
	**Uncomment whichever ΔP is appropriate: Our specification here for a whole year
	
	//Average of Oct 2021-Average of Nov 2020
	//ΔP=88.80-13.94=
 	cap gen elec_`y'= (74.86 * Intensity_PT_`y')/24
 	//gen elec_`y'_1= (68.3 * Intensity_PT_`y'_1)/ 10
 	//gen elec_`y'_2= (68.3 * Intensity_PT_`y'_2)/7 
 	//gen elec_`y'_3= (68.3 * Intensity_PT_`y'_3)/7 
}


save HourlyEst_year.dta,replace

use HourlyEst_year

**Create dataset only comprising of vulnerbaility metrics (here labeled Intensity) and number of hours of pass-through in a day 
**Hours_PT is used for Figure 4(B) map generation

putexcel set elec_psYR, replace

putexcel A1 = "Country"
putexcel B1= "Intensity"
putexcel C1="Hours_PT"

local myrow = 2

foreach y in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK"  {

	putexcel A`myrow' = "`y'"
	tabstat elec_`y', save
	putexcel B`myrow' = matrix(r(StatTotal))
	tabstat Hours_PT_`y', save
	putexcel C`myrow' = matrix(r(StatTotal))

	local myrow = `myrow' + 1

}

clear
*import back into stata with simplified dataset
import excel elec_psYR, sheet("Sheet1") firstrow
replace Intensity = 0 if Intensity==.
// replace Intensity_1 = 0 if Intensity_1==.
// replace Intensity_2 = 0 if Intensity_2==.
// replace Intensity_3 = 0 if Intensity_3==.

save elec_psYR,replace

*Merge into dataset that has generation shares for other figures

*CREATE dataset with gen shares for this timeperiod 

use allcountries_genshares
drop Intensity_1 Intensity Intensity_2 Intensity_3 Hours_PT
merge m:1 Country using elec_ps
drop _merge
*save to appropriate file depending on specification (e.g.,_noOct for no October month)
save allcountries_, replace

*saved to Combined datasets
 gen dt=dofc(t)
  format dt %td
   gen hour=hh(t)
 gen month=month(dt)
gen dow=dow(dt)




foreach y in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO"  "PL" "PT" "RO" "RS" "SI" "SK"  {
	

	use `y'_year
	reg wholesale gas_p RE_gen c.load##c.load c.gas_p#i.hour i.month#i.hour i.dow#i.hour, cluster(dt)
eststo: margins, dydx(gas_p) at(hour=(0(1)23)) vsquish post noestimcheck 
coefplot, vertical recast(connected) msize(*1.3) lwidth(*1.2)  mlabel(cond(@pval<.01, "***", cond(@pval<.05, "**", ""))) xlabel(1 "0"  5 "4" 9 "8" 13 "12" 17 "16" 21 "20" 24 "23",labsize(*1.81) grid gmax gmin) mlabsize(large) xtitle("Hour of day",size(*1.81)) ytitle("Average Pass-through",size(*1.81)) title("",size(*0.92) position(11)) mcolor(%75) msymbol(d) mfcolor(white) levels(95) ciopts(recast(. rcap) color(*0.65)) yline(0, lwidth(*2.1)) yline(1, lwidth(*2.1)) xscale(range(1 24)) name(`y'YR, replace) ylabel(,labsize(*1.81) grid gmax gmin)  grid(gmax gmin glpattern(dot) glcolor(gray) glwidth(*0.3))
}

gen double t=clock(datetimeutc,"YMDhms")
gen dt=dofc(t)
gen year=year(dt)
rename priceeurmwhe wholesale
drop if year<2020




*Dataset for genshares etc
tempfile summary_all
foreach y in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO"  "PL" "PT" "RO" "RS" "SI" "SK"  {
	use `y'_year,clear
	collapse (mean) decarb Gas_share RE_share        
	// Add a country identifier variable
	gen country = "`y'"

	// If it's the first dataset, initialize the summary file
	if "`y'" == "AT" {
		save `summary_all', replace
	}
	else {
		// For subsequent datasets, append to the summary file
		append using `summary_all'
		save `summary_all', replace
	}
}



robreg mm Vulnerability decarb if exclude==0
matrix b=e(b)
cap gen z7=1 
replace z7= 3 if Country=="CZ"
replace z7= 3 if Country=="LT"
replace z7= 1 if Country=="DE"
replace z7= 9 if Country=="NO"
replace z7= 8 if Country=="CH"
replace z7= 3 if Country=="RO"
replace z7= 3 if Country=="HU"
replace z7= 6 if Country=="SI"
replace z7= 1 if Country=="FI"
replace z7= 3 if Country=="EE"
replace z7= 2 if Country=="PL"
replace z7= 3 if Country=="PT"
replace z7= 4 if Country=="RS"
replace z7= 1 if Country=="AT"
replace z7= 9 if Country=="BG"
replace z7= 2 if Country=="BE"
replace z7= 3 if Country=="NL"
replace z7= 3 if Country=="HR"
replace z7= 9 if Country=="FR"





twoway scatter Vulnerability decarb if exclude==0, mlabel(labels) mlabvposition(z7) mlabsize(*1.3) msymbol(d) mcolor(maroon%75) msize(*1.5) color(navy) graphregion(lstyle(none)) title("A)",position(11) size(*1.4)) xtitle("Decarbonized energy share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.5)) ytitle(Vulnerability (EUR/MWh),size(*1.47)) name(rd,replace) || function y=_b[decarb]*x+_b[_cons],range(decarb) || lfit Vulnerability decarb if exclude==0, lcolor(ebblue*0.5) 




robreg mm Vulnerability RE_share if exclude==0
cap gen m2=1
replace m2=9 if Country=="AT"
replace m2=9 if Country=="RS"
replace m2=3 if Country=="BE"
replace m2=5 if Country=="PL"
replace m2=8 if Country=="CH"
replace m2=1 if Country=="BG"
replace m2=1 if Country=="FI"
replace m2=11 if Country=="HU"
replace m2=12 if Country=="CZ"
replace m2=3 if Country=="DE"
replace m2=1 if Country=="ES"
replace m2=5 if Country=="IT"
replace m2=3 if Country=="LT"
replace m2=3 if Country=="NL"
replace m2=3 if Country=="FR"
replace m2=3 if Country=="NO"
replace m2=11 if Country=="SK"
replace m2=2 if Country=="EE"
replace m2=6 if Country=="RO"







robreg mm Vulnerability RE_share if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
twoway scatter Vulnerability RE_share if exclude==0, mlabel(labels) mlabvposition(m2) mlabsize(*1.3) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("B)",position(11) size(*1.4)) xtitle("IRE share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Vulnerability (EUR/MWh),size(*1.47)) name(ri,replace) ||function y=_b[RE_share]*x+_b[_cons],range(RE_share) || lfit Vulnerability RE_share if exclude==0, lcolor(ebblue*0.5)



robreg mm Vulnerability Gas_share if exclude==0
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
cap gen m1=1
replace m1=11 if Country=="DK"
replace m1=6 if Country=="BE"
replace m1=3 if Country=="RS"
replace m1=1 if Country=="RO"
replace m1=2 if Country=="CH"
replace m1=3 if Country=="AT"
replace m1=12 if Country=="SI"
replace m1=4 if Country=="FI"
replace m1=3 if Country=="DE"
replace m1=9 if Country=="CZ"
replace m1=9 if Country=="GR"
replace m1=1 if Country=="BG"
replace m1=3 if Country=="HU"
replace m1=4 if Country=="PT"
replace m1=4 if Country=="EE"
replace m1=3 if Country=="HR"
replace m1=3 if Country=="LT"
replace m1=12 if Country=="NO"
replace m1=3 if Country=="FR"




twoway scatter Vulnerability Gas_share if exclude==0, mlabel(labels) mlabvposition(m1) mlabsize(*1.27) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("C)",position(11) size(*1.4)) xtitle("Natural gas share",size(*1.47)) ylabel(,labsize(*1.6) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.4)) ytitle(Vulnerability (EUR/MWh),size(*1.47)) name(rg,replace) ||function y=_b[Gas_share]*x+_b[_cons],range(Gas_share) || lfit Vulnerability Gas_share if exclude==0, lcolor(ebblue*0.5)

graph combine rd ri rg ,  name(aggreg3,replace)  col(3) altshrink




***Panel D 

foreach y in "AT" "BE" "BG" "CH" "CZ" "DE"  "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK"  {

	use `y'_year
	cap drop `y'estidd2-`y'estidd41
	*main estimation
	if trend==0{
		reg wholesale gas_p RE_gen c.load##c.load c.gas_p#i.hour i.month#i.hour i.dow#i.hour, cluster(dt)
	}

	if trend==1{
		reg wholesale gas_p  RE_gen c.load##c.load c.gas_p#i.hour i.dow#i.hour c.t, cluster(dt)
	}
	margins,at(gas_p=(5(1)600)) post
	*saved to variables
	matrix est=e(at),e(b)'
	svmat est,names(`y'estiddss)
	save `y'_year,replace
}


*Output to excel
putexcel set fig6bs2, replace


putexcel A1 = "Country"
putexcel B1= "100cap"
putexcel C1= "125cap"
putexcel D1= "150cap"
putexcel E1= "lowcarb"


local myrow = 2
// "ES" "GR" "IT" "PT"
foreach y in "AT" "BE" "BG" "CH" "CZ" "DE"  "DK" "EE"  "FI" "FR" "HR" "HU"  "LT" "NL" "NO" "PL"  "RO" "RS" "SI" "SK"  {
use `y'_year
cap drop `y'estidd2-`y'estidd41
save `y'_year,replace

putexcel A`myrow' = "`y'"
tabstat `y'estiddss1 if ceil(`y'estiddss47)==100,save
putexcel B`myrow' = matrix(r(StatTotal))
tabstat `y'estiddss1 if ceil(`y'estiddss47)==125,save
putexcel C`myrow' = matrix(r(StatTotal))
tabstat `y'estiddss1 if ceil(`y'estiddss47)==150,save
putexcel D`myrow' = matrix(r(StatTotal))
tabstat decarb ,save
putexcel E`myrow' = matrix(r(StatTotal))
//save `y'year,replace

local myrow = `myrow' + 1
}

*in github folder called fig6b2.dta ??
use fig6b2


gsort lowcarb
cap drop n n2
gen n=_n

*drop RO because such low pass-through that it did not make sense to do this and was not meaningful

labmask n,values(labels)
twoway bar cap150 cap125 cap100 n,horizontal fintensity(30 60 90) fcolor(forest_green ..) ylabel(1(1)24,valuelabel labsize(*0.98) angle(horizontal)) ysc(r(0 1)) ytitle("") xtitle("Necessary Natural Gas Price Cap (EUR/MWh)",size(*1.25)) title("D)",position(11) size(*1.2)) name(fig6b,replace) legend(size(*0.95) rows(3) order( 3 2 1) ) xlabel(#10, labsize(*1.1)) xline(180)


**Panel E***


foreach y in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK" {

	use `y'_year
	if trend==0{
		reg wholesale gas_p RE_gen c.load##c.load c.gas_p#i.hour i.month#i.hour i.dow#i.hour, cluster(dt)
	}

	if trend==1{
		reg wholesale gas_p  RE_gen c.load##c.load c.gas_p#i.hour i.dow#i.hour c.t, cluster(dt)
	}
	margins,at(gas_p=(40(10)260)) saving(`y'f2,replace)

}


putexcel set fig3H2, replace


putexcel A1 = "Country"
putexcel B1= "price180"

local myrow = 2

*Omitted RO because of very low pass-through/no responsiveness to gas price for wholesale electricity price
foreach y in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI""FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RS" "RO" "SI" "SK" {
use `y'f2

putexcel A`myrow' = "`y'"
tabstat _margin if _at1==180,save
putexcel B`myrow' = matrix(r(StatTotal))

local myrow = `myrow' + 1
}

*save this as price180 (at a 180 EUR/MWh cap) variable manually

use Fig3_Year

cap gen r2=1
replace r2=9 if Country=="CH"
replace r2=1 if Country=="SI"
replace r2=9 if Country=="CZ"
replace r2=8 if Country=="BG"
replace r2=3 if Country=="HR"
replace r2=12 if Country=="DE"
replace r2=9 if Country=="NO"
replace r2=3 if Country=="PL"
replace r2=4 if Country=="LT"



*regress the price at 180 EUR/MWh on the decarbonized share
robreg mm price180 decarb 
matrix b=e(b)
**both OLS and mm lines included, in addition to dots for each Country
twoway scatter price180 decarb, mlabel(labels) mlabvposition(r2) mlabsize(*1.3) msymbol(d) mcolor(maroon%75) msize(*2.02) color(navy) graphregion(lstyle(none)) title("E)",position(11) size(*1.4)) xtitle("Decarbonized energy share",size(*1.42)) ylabel(,labsize(*1.55) grid gmax gmin glwidth(0.5)) legend(off) xlabel(,labsize(*1.41)) ytitle(Max. Electricity Price under EU N.G. Price Cap (EUR/MWh),size(*1.2)) name(capg,replace) ||function y=_b[decarb]*x+_b[_cons],range(decarb) || lfit price180 decarb, lcolor(ebblue*0.5)





