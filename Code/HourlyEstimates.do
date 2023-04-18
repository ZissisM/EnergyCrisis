*Main program execution
*Obtain Hourly Estimates of Relative Vulnerability, and by extension the number of hours of signicant pass-through
*Used to generate Figure 2 (in datasets labeled "Intensity") (!) and SI/EDF Figures of Vulnerability Maps for relative vulnerability
*Used to create maps for Figure 2 and 5B

clear
set scheme white_tableau

 *cd ~/Downloads/Nature_Energy_Crisis/Datasets/Country datasets
*in COUNTRY datasets


**Loop over countries
eststo clear
foreach y in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO"  "PL" "PT" "RO" "RS" "SI" "SK"  {

	use `y'_new
	//if we want to include a time trend instead of monthly fixed effects, trend=1 (only for the case of Greece!)
	*******Edit the function HERE (and below for Greece) to exclude certain months, or omit controls like the specification tests in the SI *******
	if trend==0{
		reg wholesale_test gas_p RE_gen c.load##c.load c.gas_p#i.hour i.month#i.hour i.dow#i.hour, cluster(dt)
	}

	if trend==1{
		reg wholesale_test gas_p  RE_gen c.load##c.load c.gas_p#i.hour i.dow#i.hour c.t, cluster(dt)
	}

	**For example, No controls
	//reg wholesale_test gas_p c.gas_p#i.hour i.month#i.hour i.dow#i.hour, cluster(dt)
	**No october
	//reg wholesale_test gas_p RE_gen c.load##c.load c.gas_p#i.hour i.month#i.hour i.dow#i.hour if month<10, cluster(dt)


	eststo `y': margins, dydx(gas_p) at(hour=(0(1)23)) vsquish post noestimcheck 

	**Output to excel
	esttab using fig6_n.csv, replace wide plain mtitles label noobs se
}

***Import excel file as as new dta with all countries estimates, format file for importing
clear
import delimited fig6_n,  varnames(1) case(preserve) rowrange(4) colrange(2) asdouble numericcols(_all) clear

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
**create hour-groups
gen hour_group = 1 if hour < 10
replace hour_group = 2 if hour>9 & hour<17
replace hour_group = 3 if hour>16

**Calculate vulnerability metrics
foreach y in "AT" "BE" "BG" "CH" "CZ" "DE"  "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK"  {
	cap drop Hours_PT_`y' `y'_t 
	cap drop Intensity_PT_`y' Hours_PT_`y'_1 Hours_PT_`y'_2 Hours_PT_`y'_3 Intensity_PT_`y'_1 Intensity_PT_`y'_2 Intensity_PT_`y'_3 elec_`y' elec_`y'_1 elec_`y'_2 elec_`y'_3
	**t-stat
	cap gen `y'_t = `y'/`y'_std

	**Measure hours of pass-through & intensity
	cap egen Hours_PT_`y' = total(`y'_t>1.96 & `y'>0)
	cap egen Intensity_PT_`y' = sum(`y') if `y'_t>1.96 & `y'>0

	**By-hour-groups
	cap egen Hours_PT_`y'_1 = total(`y'_t>1.96) if hour_group==1
	cap egen Hours_PT_`y'_2 = total(`y'_t>1.96) if hour_group==2
	cap egen Hours_PT_`y'_3 = total(`y'_t>1.96) if hour_group==3

	cap egen Intensity_PT_`y'_1 = sum(`y') if `y'_t>1.96 & hour_group==1
	cap egen Intensity_PT_`y'_2 = sum(`y') if `y'_t>1.96 & hour_group==2
	cap egen Intensity_PT_`y'_3 = sum(`y') if `y'_t>1.96 & hour_group==3


	** Predicted Electricity Price: Vulnerability
	
	**Uncomment whichever ΔP is appropriate: Our main specification is the first one, from April 2021 to October 2021

	//April to October gas price difference = 68.3
 	cap gen elec_`y'= (68.3 * Intensity_PT_`y')/24
 	gen elec_`y'_1= (68.3 * Intensity_PT_`y'_1)/ 10
 	gen elec_`y'_2= (68.3 * Intensity_PT_`y'_2)/7 
 	gen elec_`y'_3= (68.3 * Intensity_PT_`y'_3)/7 

	//April to September price difference = 44.01 : _noOct
// 		cap gen elec_`y'= (44.01 * Intensity_PT_`y')/24
// 		gen elec_`y'_1= (44.01 * Intensity_PT_`y'_1)/ 10
// 		gen elec_`y'_2= (44.01 * Intensity_PT_`y'_2)/7 
// 		gen elec_`y'_3= (44.01 * Intensity_PT_`y'_3)/7 

	//May to October price difference = 63.53:  _noApril
	// 	cap gen elec_`y'= (63.53 * Intensity_PT_`y')/24
	// 	gen elec_`y'_1= (63.53 * Intensity_PT_`y'_1)/ 10
	// 	gen elec_`y'_2= (63.53 * Intensity_PT_`y'_2)/7 
	// 	gen elec_`y'_3= (63.53 * Intensity_PT_`y'_3)/7 

	//April 2021 to Winter 2022 Futures (317.5 as of August 25 2022):  _futures.dta
	// 	cap gen elec_`y'= (297.25 * Intensity_PT_`y')/24
	//  	gen elec_`y'_1= (297.25 * Intensity_PT_`y'_1)/ 10
	//  	gen elec_`y'_2= (297.25 * Intensity_PT_`y'_2)/7 
	//  	gen elec_`y'_3= (297.25 * Intensity_PT_`y'_3)/7 

	// 	//First half of sample ΔP= 26.42
	// 	cap gen elec_`y'= (297.25 * Intensity_PT_`y')/24
	//  	gen elec_`y'_1= (297.25 * Intensity_PT_`y'_1)/ 10
	//  	gen elec_`y'_2= (297.25 * Intensity_PT_`y'_2)/7 
	//  	gen elec_`y'_3= (297.25 * Intensity_PT_`y'_3)/7 

}


save HourlyEst.dta, replace

use HourlyEst

**Create dataset only comprising of vulnerbaility metrics (here labeled Intensity) and number of hours of pass-through in a day 
**Hours_PT is used for Figure 4(B) map generation

putexcel set elec_ps, replace

putexcel A1 = "Country"
putexcel B1= "Intensity"
putexcel C1= "Intensity_1"
putexcel D1= "Intensity_2"
putexcel E1= "Intensity_3"
putexcel F1="Hours_PT"

local myrow = 2

foreach y in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK"  {

	putexcel A`myrow' = "`y'"
	tabstat elec_`y', save
	putexcel B`myrow' = matrix(r(StatTotal))
	tabstat elec_`y'_1, save
	putexcel C`myrow' = matrix(r(StatTotal))
	tabstat elec_`y'_2, save
	putexcel D`myrow' = matrix(r(StatTotal))
	tabstat elec_`y'_3, save
	putexcel E`myrow' = matrix(r(StatTotal))
	tabstat Hours_PT_`y', save
	putexcel F`myrow' = matrix(r(StatTotal))

	local myrow = `myrow' + 1

}

clear
*import back into stata with simplified dataset
import excel elec_ps, sheet("Sheet1") firstrow
replace Intensity = 0 if Intensity==.
replace Intensity_1 = 0 if Intensity_1==.
replace Intensity_2 = 0 if Intensity_2==.
replace Intensity_3 = 0 if Intensity_3==.

save elec_ps,replace

*Merge into dataset that has generation shares for other figures

use allcountries_genshares
drop Intensity_1 Intensity Intensity_2 Intensity_3 Hours_PT
merge m:1 Country using elec_ps
drop _merge
*save to appropriate file depending on specification (e.g.,_noOct for no October month)
save allcountries_, replace
*saved to Combined datasets





