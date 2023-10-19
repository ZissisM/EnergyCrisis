**EDF Table 2 and Table 3


*Create panel data for all countries 
foreach y in "BE" "BG" "CH" "CZ" "DE_50Hz"  "DE_Amprion" "DE_Tennet" "DE_TransnetBW" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO_1"  "NO_2" "NO_3" "NO_4" "PL" "PT" "RO" "RS" "SI" "SK" {
	//use `y'_new, clear
	use panel_data
	//     keep country t totalgen Gas_s RE_gen
	// 	gen country_id= "`country'"
	// merge 1:1 t country_id using panel_data.dta

	// //egen panel_id = group(country)
	// save panel_data.dta, replace
	//     clear
	//     use panel_data.dta, clear 
	//  replace panel_id = country if missing(panel_id)

	append using `y'_new,keep(country t totalgen Gas_s RE_gen load)
	save panel_data,replace
}

sort panel_id time_var
save panel_data.dta, replace

gen is_NO = country == "NO-1" | country == "NO-2" | country == "NO-3" | country == "NO-4"
collapse (mean) totalgen Gas_s RE_gen load [aweight=load] if is_NO, by(t) 
generate date = dofc(t)

gen is_DE = country == "DE_50Hertz" | country == "DE_Amprion" | country == "DE_TenneT" | country == "DE_TransnetBW"



gen RE_s=RE_gen/totalgen
gen nonRE_s=1-RE_s
egen id=group(country)
egen RE_cap=max(RE_gen),by(country)
gen RE_CF=RE_gen/RE_cap



bysort id: egen avg_REs = mean(RE_s)
gen highIRE = (avg_REs > 0.15)


use panel_data
***pooled regression
*xtreg Gas_s RE_CF c.load##c.load i.month#i.hour,fe  vce(robust)
reghdfe Gas_s RE_CF c.load##c.load ,absorb(id i.month#i.hour)  cl(id month)
sum load, meanonly
local meanss = r(mean)
nlcom  2 * _b[c.load#c.load] * `meanss' + _b[load]
cap gen combined_load_effect = 2 * _b[c.load#c.load] * `meanss' + _b[load]
outreg2  using "gens.doc",  replace addtext(Country FE, YES, Month-Hour FE, YES, Countries, All) keep(RE_CF load c.load#c.load) label

*xtreg Gas_s RE_CF c.load##c.load i.month#i.hour if IRE_above==1,fe vce(robust)
reghdfe Gas_s RE_CF c.load##c.load if IRE_above==1 ,absorb(id i.month#i.hour)  cl(id month)

summarize load if IRE_above == 1, meanonly 
local mean_load_IRE = r(mean)
nlcom  2 * _b[c.load#c.load] * `mean_load_IRE' + _b[load]
cap gen combined_load_effect_IRE = 2 * _b[c.load#c.load] * `mean_load_IRE' + _b[load]
outreg2  using "gens.doc",  append addtext(Country FE, YES, Month-Hour FE, YES, Countries, IRE above median) keep(RE_CF load c.load#c.load) label

*xtreg Gas_s RE_CF c.load##c.load i.month#i.hour if gas_above==1,fe vce(robust)
reghdfe Gas_s RE_CF c.load##c.load if gas_above==1 ,absorb(id i.month#i.hour)  cl(id month)

summarize load if gas_above == 1, meanonly 
local mean_load_gas = r(mean)
nlcom  2 * _b[c.load#c.load] * `mean_load_gas' + _b[load]
cap gen combined_load_effect_gas = 2 * _b[c.load#c.load] * `mean_load_gas' + _b[load]
outreg2  using "gens.doc",  append addtext(Country FE, YES, Month-Hour FE, YES, Countries, Gas above median) keep(RE_CF load c.load#c.load) label

*xtreg Gas_s RE_CF c.load##c.load i.month#i.hour if south==1,fe vce(robust)
reghdfe Gas_s RE_CF c.load##c.load if south==1 ,absorb(id i.month#i.hour)  cl(id month)

summarize load if south == 1, meanonly 
local mean_load_south = r(mean)
nlcom  2 * _b[c.load#c.load] * `mean_load_south' + _b[load]
cap gen combined_load_effect_south = 2 * _b[c.load#c.load] * `mean_load_south' + _b[load]
*outreg2  using "gens.doc",  append addtext(Country FE, YES, Month-Hour FE, YES, Countries, Southern 4) keep(RE_CF load c.load#c.load) label


use panel_data
*by country results to excel file
foreach y in "AT" "BE" "BG" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK" {

	reg Gas_s RE_CF i.month#i.hour i.dow load if country=="`y'" ,  vce(robust)
	*if the first one, create new doc, otherwise append
	if "`y'"=="AT"{
		outreg2  using "bycountry.xls",  replace addtext(Month-Hour FE, YES, Country, "`y'") excel keep(RE_CF load) label
	}
	else{
		outreg2  using "bycountry.xls",  append addtext(Month-Hour FE, YES, Country, "`y'") excel keep(RE_CF load) label
	}
	reg Gas_s RE_CF nonRE_s i.month#i.hour i.dow load if country=="`y'", vce(robust)
	outreg2  using "bycountry.xls",  append addtext(Month-Hour FE, YES, Country, "`y'") excel keep(RE_CF nonRE_s load) label
}

gen IRE_above = 1 if country=="AT" | country=="DE"| country=="DK"| country=="ES"| country=="GR"| country=="HR"| country=="FI"| country=="IT"| country=="LT"| country=="PT"| country=="RO"| country=="SI"
gen gas_above= 1  if country=="BE" | country=="DE"| country=="HU"| country=="ES"| country=="GR"| country=="HR"| country=="NL"| country=="IT"| country=="LT"| country=="PT"| country=="RO"| country=="SK"
replace gas_above=0 if missing(gas_above)

gen south = 1 if country=="GR" | country=="IT"| country=="PT"| country=="ES"
replace south=0 if missing(south)


**EDF 3
asdoc pwcorr Gas Solar Wind Hydro_R Nuc Coal HydroDispatch, replace
