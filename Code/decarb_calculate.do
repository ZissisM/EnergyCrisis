*Used to further clean and to obtain decarbonization shares for each country 

*DE NO?
foreach y in "AT" "BE" "BG" "CH" "CZ" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "PL" "PT" "RO" "RS" "SI" "SK" {
	use `y'_gen
//gen RE_gen = RE_share*country_Total
//replace country_total = country_total-Imports 
//cap drop RE_share

cap drop Gas_share
cap drop Lignite_share
cap drop  Imports_share 
cap drop Oil_share
cap drop  Biomass_share
cap drop  Coal_share
cap drop  Nuc_share 
cap drop period season
cap drop  RE_share
cap rename gen_Solar RE_solar
cap rename gen_Wind_onshore RE_wind_on
cap rename gen_Wind_offshore RE_wind_off
cap rename gen_Hydro_run RE_hydro
cap rename gen_Geothermal RE_geo
cap rename gen_Other_renewable RE_other

egen RE_gen = rowtotal(RE_*)
	cap gen RE_share = RE_gen/total_gen

cap rename gen_Hydro_storage Hydro_ds
cap rename gen_Hydro_reservoir Hydro_dr
gen Hydro_initialize=0

egen Hydro_dis=rowtotal(Hydro_*)
cap gen Hydro_share = Hydro_dis/total_gen

gen Nuclear_share=0 
cap replace Nuclear_share= gen_Nuc/total_gen


save `y'_gen,replace
}
foreach y in "AT" "BE" "BG" "CH" "CZ" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "PL" "PT" "RO" "RS" "SI" "SK" {
	use `y'_gen

	gen decarb = RE_share+Nuclear_share+Hydro_share
	
	//gen my=ym(yr,month)
	egen decarb_month=mean(decarb),by(my)
	
	//drop decarb decarb_month RE_share Nuclear_share Hydro_share country_total Hydro_dis 
	
	//egen total_gen = rowtotal(RE_* gen_* Hydro_*)
	//cap gen RE_share = RE_gen/total_gen
	
	//egen Hydro_dis=rowtotal(Hydro_*)
	//cap gen Hydro_share = Hydro_dis/total_gen

	
	//gen Nuclear_share=0 
	//cap replace Nuclear_share= gen_Nuc/total_gen
	
save `y'_gen,replace
}


*decarbs has NO and DE averages
putexcel set decarbs_t, replace

putexcel A1 = "Country"
putexcel B1= "decarb_2021"
putexcel C1= "decarb_2016"
//putexcel D1= "decarb_all"
//putexcel E1= "decarb_sample"




local myrow = 2
foreach y in "AT" "BE" "BG" "CH" "CZ" "DE_50Hz" "DE_Tennet" "DE_Amprion" "DE_TransnetBW"  "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO_1" "NO_2" "NO_3" "NO_4" "PL" "PT" "RO" "RS" "SI" "SK"  {

	putexcel A`myrow' = "`y'"
	use `y'_gen,clear
	tabstat decarb if yr==2021, save
	putexcel B`myrow' = matrix(r(StatTotal))
	tabstat decarb if yr==2016, save
	putexcel C`myrow' = matrix(r(StatTotal))
// 	tabstat decarb , save
// 	putexcel D`myrow' = matrix(r(StatTotal))
// 	tabstat decarb if yr==2021 & month>4, save
// 	putexcel E`myrow' = matrix(r(StatTotal))
	

	local myrow = `myrow' + 1

}


foreach y in "DE_50Hz" "DE_Tennet" "DE_Amprion" "DE_TransnetBW" "NO_1" "NO_2" "NO_3" "NO_4" {
	
use `y'_gen
cap drop Gas_share
cap drop Lignite_share
cap drop  Imports_share 
cap drop Oil_share
cap drop  Biomass_share
cap drop  Coal_share
cap drop  Nuc_share 
cap drop period season
cap drop  RE_share
cap rename gen_Solar RE_solar
cap rename gen_Wind_onshore RE_wind_on
cap rename gen_Wind_onshore RE_wind_off
cap rename gen_Hydro_run RE_hydro
cap rename gen_Geothermal RE_geo
cap rename gen_Other_renewable RE_other

cap drop country_total gen_Hydro_total
egen total_gen = rowtotal(RE_* gen_*)

egen RE_gen = rowtotal(RE_*)
cap gen RE_share = RE_gen/total_gen

cap rename gen_Hydro_storage Hydro_ds
cap rename gen_Hydro_reservoir Hydro_dr
cap gen Hydro_initialize=0

egen Hydro_dis=rowtotal(Hydro_*)
cap gen Hydro_share = Hydro_dis/total_gen
cap gen Hydro_share=0 if Hydro

cap gen Nuclear_share=0 
cap replace Nuclear_share= gen_Nuc/total_gen

gen decarb = RE_share+Nuclear_share+Hydro_share
	
gen my=ym(yr,month)
egen decarb_month=mean(decarb),by(my)


save `y'_gen,replace
}
	
	
foreach y in "AT" "BE" "BG" "CH" "CZ" "DE_50Hz" "DE_Tennet" "DE_Amprion" "DE_TransnetBW"  "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO_1" "NO_2" "NO_3" "NO_4" "PL" "PT" "RO" "RS" "SI" "SK"  {
		
merge m:1 t using `y'_gen, keepusing(decarb_month)
rename decarb `y'_decarb
drop _merge
save RE_spag,replace

}







foreach y in "AT" "BE" "BG" "CH" "CZ_" "DE_50Hertz" "DE_TenneT" "DE_Amprion" "DE_TransnetBW" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "NO-1" "NO-2" "NO-3" "NO-4" "PL" "PT" "RO" "RS" "SI" "SK"  {
use `y'_gennew
// preserve
// keep if country=="`y'"
// save `y'_gennew,replace
// restore 



sort t type type_generation_time
by t type: gen dup=cond(_N==1,0,_n) 
gen tag = 1 if dup==2 & type_generation==.
drop if tag==1
drop tag dup
by t type: gen dup=cond(_N==1,0,_n) 
drop if dup==1
drop dup 
rename t time
rename type_generation_time gen_
reshape wide gen_, i(time) j(type) string
rename time t

save `y'_gennew,replace

// gen double t = clock(time, "YMDhms#")
// format t %tc
//rename time date


// label var t Time
// label var Imports "Total Imports at time"
// label var day "Day of Month"
// label var yr Year
// label var month Month
// label var hour "Hour of Day"
**go to multiple files, get decarb like above and then take the values 
}


// duplicates tag type t, gen(flag)
// list type flag t gen_ if flag>0 //if missing values remove the duplicates 
// drop if flag>0 & missing(gen_)
// //drop if flag>0 & gen_==0
// drop flag
// sort t type gen_
// by t type: gen dup=cond(_N==1,0,_n) 
// reshape wide gen_, i(t) j(type) string




**accidentally overwrote to _gen aswell
foreach y in "AT" "BE" "BG" "CH" "CZ_" "DE_50Hertz" "DE_TenneT" "DE_Amprion" "DE_TransnetBW" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "NO-1" "NO-2" "NO-3" "NO-4" "PL" "PT" "RO" "RS" "SI" "SK"  {
use `y'_gennew

	rename t time
	gen date=date(time, "YMDhms#")
	format date %td
gen double t = clock(time, "YMDhms#")
format t %tc
gen yr=year(date)
gen month=month(date)


cap rename gen_Solar RE_solar
cap rename gen_Wind_onshore RE_wind_on
cap rename gen_Wind_onshore RE_wind_off
cap rename gen_Hydro_run RE_hydro
cap rename gen_Geothermal RE_geo
cap rename gen_Other_renewable RE_other

egen total_gen = rowtotal(RE_* gen_*)

egen RE_gen = rowtotal(RE_*)
cap gen RE_share = RE_gen/total_gen

cap rename gen_Hydro_storage Hydro_ds
cap rename gen_Hydro_reservoir Hydro_dr
cap gen Hydro_initialize=0

egen Hydro_dis=rowtotal(Hydro_*)
cap gen Hydro_share = Hydro_dis/total_gen
cap gen Hydro_share=0 if Hydro

cap gen Nuclear_share=0 
cap replace Nuclear_share= gen_Nuc/total_gen

gen decarb = RE_share+Nuclear_share+Hydro_share
	
gen my=ym(yr,month)
egen decarb_month=mean(decarb),by(my)


save `y'_gennew,replace

}

// use RE_spag
//  drop AT_decarb-SK_decarb


	
*"NO-1" "NO-2" "NO-3" "NO-4"
*"AT" "BE" "BG" "CH" "CZ_" "DE_50Hertz" "DE_TenneT" "DE_Amprion" "DE_TransnetBW" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" 
foreach y in  "PL" "PT" "RO" "RS" "SI" "SK"  {
use `y'_gennew
collapse decarb,by(my) 
save `y'_gennewsum,replace
use RE_spag
merge m:1 my using `y'_gennewsum, keepusing(decarb)
rename decarb `y'_decarb
drop _merge
save RE_spag,replace

}


putexcel set decarbs_changes, replace

putexcel A1 = "Country"
putexcel B1= "decarb_sample"
putexcel C1= "decarb_2021"
putexcel D1= "decarb_2019"
putexcel E1= "decarb_2016_2021"
putexcel F1="decarb_noct"



*HR only 2019 and on
local myrow = 2
foreach y in "AT" "BE" "BG" "CH" "CZ_" "DE_50Hertz" "DE_TenneT" "DE_Amprion" "DE_TransnetBW" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "NO-1" "NO-2" "NO-3" "NO-4" "PL" "PT" "RO" "RS" "SI" "SK"  {

	putexcel A`myrow' = "`y'"
	use `y'_gennew,clear
	tabstat decarb if yr==2021 & month<11 & month>3, save
	putexcel B`myrow' = matrix(r(StatTotal))
	tabstat decarb if yr==2021, save
	putexcel C`myrow' = matrix(r(StatTotal))
	tabstat decarb if yr==2019 , save
	putexcel D`myrow' = matrix(r(StatTotal))
 	tabstat decarb if yr>2015 & yr<2022, save
 	putexcel E`myrow' = matrix(r(StatTotal))
	tabstat decarb if yr==2021 & month<10 & month>3, save
	putexcel F`myrow' = matrix(r(StatTotal))
	

	local myrow = `myrow' + 1

}

*calculate the % increase in 5 years 


*RE_spag.dta
*deca.dta
 
 
 
 *en DE_decarb = DE_50Hertz_decarb*0.21255+ DE_TenneT_decarb*0.29683+ DE_Amprion_decarb*0.3696+ DE_TransnetBW_decarb*0.120458


label var AT_decarb "Austria"
label var BE_decarb "Belgium"
label var BG_decarb "Bulgaria"
label var CH_decarb "Switzerland"
label var CZ_decarb "Czech"
label var DE_decarb "Germany"
label var DK_decarb "Denmark"
label var EE_decarb "Estonia"
label var ES_decarb "Spain"
label var FI_decarb "Finland"
label var FR_decarb "France"
label var GR_decarb "Greece"
label var HR_decarb "Croatia"
label var HU_decarb "Hungary"
label var IT_decarb "Italy"
label var LT_decarb "Lithuania"
label var NL_decarb "Netherlands"
label var NO_decarb "Norway"
label var PL_decarb "Poland"
label var PT_decarb "Portugal"
label var RO_decarb "Romania"
label var RS_decarb "Serbia"
label var SI_decarb "Slovenia"
label var SK_decarb "Slovakia"

twoway line AT_decarb-BG_decarb CZ_decarb DE_decarb DK_decarb-SK_decarb CH_decarb my, lcolor(ltblue forest_green cranberry dimgray cyan dknavy gold emerald yellow purple mint lavender orange_red midblue sand erose magenta olive dkorange sienna) ytitle("Decarbonized energy generation share",size(*1.15)) xtitle("") 

gen north = (DK_decarb+ EE_decarb+ FI_decarb+ LT_decarb+ NL_decarb+ NO_decarb)/6
*RS missingbefore 2017
replace east= (BG_decarb+ HU_decarb+ PL_decarb+ RO_decarb+ SK_decarb)/5
 gen center= (AT_decarb+ BE_decarb+ CH_decarb+ CZ_decarb+ FR_decarb+ DE_decarb)/6
 *HR missing 2019
 gen south = (GR_decarb+ IT_decarb+ PT_decarb+ SI_decarb+ ES_decarb)/5
 
 twoway line north center east south my,ytitle("Decarbonized energy generation share",size(*1.15)) xtitle("") 
 
 
//  sort Percentchange
//  gen n = _n
 labmask n, values(labels)
 
 
 twoway dot Percentchange n, horizontal xtitle("Percent increase decarbonized energy generation share (2016-2021)", size(*1.2)) mcolor(maroon%65) msymbol(d)  msize(*1.7) ytitle("") barw(1.3) legend(off) ylabel(1(1)24,valuelabel labsize(*1.2) angle(horizontal)) xlabel(,labsize(*1.2))
 
 
 
 
 foreach y in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK" {
egen `y'_capacity2=mean(`y'_decarb),by(yr)
 }
 
twoway line AT_capacity2-SK_capacity2 yr, lcolor(ltblue*0.7 green*0.7  cranberry*0.7  emidblue cyan*0.7 dknavy*0.7  gold*0.5  erose*0.7  orange*0.7  purple*0.7  mint*0.7  lavender orange_red*0.7  midblue*0.7  sand*0.7 erose*0.7  black*0.8 red*0.7  dkorange sienna*0.7) mcolor(ltblue*0.7 green*0.7  cranberry*0.7  emidblue cyan*0.7 dknavy*0.7  gold*0.5  erose*0.7  orange*0.7  purple*0.7  mint*0.7  lavender orange_red*0.7  midblue*0.7  sand*0.7 erose*0.7  black*0.7 red*0.7  dkorange sienna*0.7  ) ytitle("Decarbonized energy generation share",size(*1.15)) xtitle("") title("C)", size(*1.2) position(11))



label var AT_capacity "Austria"
label var BE_capacity "Belgium"
label var BG_capacity "Bulgaria"
label var CH_capacity "Switzerland"
label var CZ_capacity "Czech"
label var DE_capacity "Germany"
label var DK_capacity "Denmark"
label var EE_capacity "Estonia"
label var ES_capacity "Spain"
label var FI_capacity "Finland"
label var FR_capacity "France"
label var GR_capacity "Greece"
label var HR_capacity "Croatia"
label var HU_capacity "Hungary"
label var IT_capacity "Italy"
label var LT_capacity "Lithuania"
label var NL_capacity "Netherlands"
label var NO_capacity "Norway"
label var PL_capacity "Poland"
label var PT_capacity "Portugal"
label var RO_capacity "Romania"
label var RS_capacity "Serbia"
label var SI_capacity "Slovenia"
label var SK_capacity "Slovakia"


label var AT_capacity2 "Austria"
label var BE_capacity2 "Belgium"
label var BG_capacity2 "Bulgaria"
label var CH_capacity2 "Switzerland"
label var CZ_capacity2 "Czech"
label var DE_capacity2 "Germany"
label var DK_capacity2 "Denmark"
label var EE_capacity2 "Estonia"
label var ES_capacity2 "Spain"
label var FI_capacity2 "Finland"
label var FR_capacity2 "France"
label var GR_capacity2 "Greece"
label var HR_capacity2 "Croatia"
label var HU_capacity2 "Hungary"
label var IT_capacity2 "Italy"
label var LT_capacity2 "Lithuania"
label var NL_capacity2 "Netherlands"
label var NO_capacity2 "Norway"
label var PL_capacity2 "Poland"
label var PT_capacity2 "Portugal"
label var RO_capacity2 "Romania"
label var RS_capacity2 "Serbia"
label var SI_capacity2 "Slovenia"
label var SK_capacity2 "Slovakia"


 
 // "DE"
 foreach y in    "AT" "BE" "BG" "CH" "CZ" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK" "AT" {
use `y'_gennew,clear
cap drop `y'_dc
 egen `y'_dc=max(decarb) if yr>2015,by(yr)
 save `y'_gennew,replace
//  use RE_spag,clear
//  merge 1:m t using `y'_gennew, keepusing(`y'_dc)
// drop _merge
// save RE_spag,replace
  }

  
  

putexcel set newdecarb, replace
putexcel A1 = "Country"
putexcel B1= "decarb 2016"
putexcel C1= "decarb 2017"
putexcel D1= "decarb 2018"
putexcel E1= "decarb 2019"
putexcel F1= "decarb 2020"
putexcel G1= "decarb 2021"






local myrow = 2
* CZ HR
foreach y in "AT" "BE" "BG" "CH" "DK" "EE" "ES" "FI" "FR" "GR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK" {
	use `y'_gennew
	putexcel A`myrow' = "`y'"
	tabstat `y'_dc if yr==2016, save
	putexcel B`myrow' = matrix(r(StatTotal))
	tabstat `y'_dc if yr==2017, save
	putexcel C`myrow' = matrix(r(StatTotal))
	tabstat `y'_dc if yr==2018, save
	putexcel D`myrow' = matrix(r(StatTotal))
	tabstat `y'_dc if yr==2019, save
	putexcel E`myrow' = matrix(r(StatTotal))
	tabstat `y'_dc if yr==2020, save
	putexcel F`myrow' = matrix(r(StatTotal))
	tabstat `y'_dc if yr==2021, save
	putexcel G`myrow' = matrix(r(StatTotal))
	
	local myrow = `myrow' + 1

}



  

putexcel set newshares, replace
putexcel A1 = "Country"
putexcel B1= "Nuc "
putexcel C1= "Gas"
putexcel D1= "Coal"
putexcel E1= "Solar"
putexcel F1= "Wind"
putexcel G1= "HydroDispatch"
putexcel H1= "Hydro_R"






local myrow = 2
foreach y in "AT" "BE" "BG" "CH" "CZ" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "PL" "PT" "RO" "RS" "SI" "SK" {
	use `y'_new
	putexcel A`myrow' = "`y'"
	tabstat Nuc_s, save
	putexcel B`myrow' = matrix(r(StatTotal))
	tabstat Gas_s, save
	putexcel C`myrow' = matrix(r(StatTotal))
	tabstat Coal_s, save
	putexcel D`myrow' = matrix(r(StatTotal))
	tabstat  solar_s , save
	putexcel E`myrow' = matrix(r(StatTotal))
	tabstat wind_s,  save
	putexcel F`myrow' = matrix(r(StatTotal))
	tabstat Hydro_s, save
	putexcel G`myrow' = matrix(r(StatTotal))
	tabstat hydror_tg, save
	putexcel H`myrow' = matrix(r(StatTotal))
	
	local myrow = `myrow' + 1

}
