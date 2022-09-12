***2022 Initial Cleaning
*Not meant to run again, just displaying process


***Homogenize the types of solar (some TSOs have different labeling)
replace type="Lignite" if type=="('Fossil Brown coal/Lignite', 'Actual Aggregated')"
replace type="Lignite" if type=="Fossil Brown coal/Lignite"
replace type="Hard_coal" if type=="('Fossil Coal-derived gas', 'Actual Aggregated')"
replace type="Coal_gas" if type=="Fossil Coal-derived gas"
replace type="Gas" if type=="('Fossil Gas', 'Actual Aggregated')"
replace type="Hard_coal" if type=="('Fossil Hard coal', 'Actual Aggregated')"
replace type="Oil" if type=="('Fossil Oil', 'Actual Aggregated')"
replace type="Oil_shale" if type=="'Fossil Oil shale'"
replace type= "Geothermal" if type== "('Geothermal', 'Actual Aggregated')"
replace type= "Hydro_storage" if type== "('Hydro Pumped Storage', 'Actual Aggregated')"
replace type= "Hydro_run" if type== "('Hydro Run-of-river and poundage', 'Actual Aggregated')"
replace type= "Nuclear" if type== "('Nuclear', 'Actual Aggregated')"
replace type= "Other_renewable" if type== "('Other renewable', 'Actual Aggregated')"
replace type= "Other" if type== "('Other', 'Actual Aggregated')"
replace type= "Solar" if type== "('Solar', 'Actual Aggregated')"
replace type= "Waste" if type== "('Waste', 'Actual Aggregated')"
replace type= "Wind_onshore" if type== "('Wind Onshore', 'Actual Aggregated')"
replace type= "Wind_offshore" if type== "Wind Offshore"
replace type= "Wind_offshore" if type== "('Wind Offshore', 'Actual Aggregated')"
replace type="Peat" if type=="Fossil Peat"
replace type= "Wind_onshore" if type == "Wind Onshore"
replace type= "Hydro_storage" if type== "Hydro Pumped Storage"
replace type= "Hydro_run" if type== "Hydro Run-of-river and poundage"
replace type= "Hydro_reservoir" if type== "Hydro Water Reservoir"
replace type="Gas" if type=="Fossil Gas"
replace type="Hard_coal" if type=="Fossil Hard coal"
replace type="Oil" if type=="Fossil Oil"
replace type="Oil_shale" if type=="Fossil Oil shale"
replace type="Other_renewable" if type== "Other renewable"
replace type="Biomass" if type== "('Biomass', 'Actual Aggregated')"
replace type="Hydro_storage" if type=="('Hydro Pumped Storage', 'Actual Consumption')"
replace type="Solar" if type=="('Solar', 'Actual Consumption')"



***Create appropriately formatted time variable

gen double t = clock(time, "YMDhms#")
format t %tc


***RESHAPE the data, keep one unique value per source-time-country
*First, remove duplicates if generation is missing
*If still duplicates remove the smaller value (usually very smaller in relative terms, order of magnitude, and often 0)
rename time t
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
//Reshape dataset to have 1 column for each generation type
reshape wide gen_, i(time) j(type) string
rename time t


//One more check for duplicates if they exist and drop them (sometimes there are more than 3 instances)
duplicates tag type t, gen(flag)
list type flag t gen_ if flag>0 //if missing values remove the duplicates 
drop if flag>0 & missing(gen_)
drop flag
sort t type gen_
by t type: gen dup=cond(_N==1,0,_n) 
reshape wide gen_, i(t) j(type) string

***Merging different datasets to forumlate country specific datasets
***Merge wholesale prices into the dataset where wholesale_2021 has wholesale prices and EU_imports_3 has the aggregated imports into each country
*Change dk1 to any country to import to maek each country dataset
// merge 1:1 t using wholesale_2021, keepusing(dk1)
// keep if _merge==3
// drop _merge
// merge 1:1 t using EU_imports_3, keepusing(type_generation_timeDK)
// keep if _merge==3
// drop _merge
// rename type_generation_timeDK Imports


label var t Time
label var Imports "Total Imports at time"
label var day "Day of Month"
label var yr Year
label var month Month
label var hour "Hour of Day"
gen gen_Hydro_total = gen_Hydro_reservoir + gen_Hydro_run + gen_Hydro_storage
label var gen_Hydro_total "Sum of Hydro sources"
gen dow = dow(mdy(month,day,yr))
label var dow "Day of week: 0-Sunday.. 6-Saturday"
gen ln_wholesale = ln(wholesale)



**Create a total for all energy sources present
egen country_total = rowtotal(gen_*)
*Include imports into this and account for the total Hydro (double counting)
replace country_total = country_total - gen_Hydro_total + Imports
label var country_total "Total generation + Imports"

**Create initial shares using total generation (with imports) as the denominator-- edited later
*Need to edit this line for every country depending on what sources they have-- but these are the options

capture{
gen RE_share =  (gen_Hydro_total + gen_Wind_onshore + gen_Solar + gen_Wind_offshore + gen_Other_renewable)/country_total
gen Nuc_share = gen_Nuclear/country_total 
gen Imports_share = Imports/country_total 
gen Gas_share = gen_Gas/country_total
gen Lignite_share = gen_Lignite/country_total
gen Oil_share = gen_Oil/country_total
gen Biomass_share = gen_Biomass/country_total
gen Coal_share = gen_Hard_coal/country_total
cap replace Coal_share = (gen_Hard_coal + gen_Coal_gas)/country_total
gen Other_share = (gen_Waste+gen_Other)/country_total
}


****Initial charts of energy mix description of countries
 graph pie RE_share-Other_share, by(yr) plabel(1 percent, color(white)) plabel(2 percent, color(white)) plabel(3 percent, color(white)) title("Energy mix: Austria") sort descending
 graph pie  Nuc_share-RE_share Oil_share-Other_share, by(yr) plabel(1 percent, color(white)) plabel(2 percent, color(white)) plabel(3 percent, color(white)) plabel(4 percent, color(white)) title("Energy mix: ") sort descending 

*check missing patterns of generations sources and wholesale price
mvpatterns gen_Biomass-gen_Wind_onshore wholesale


**Initial exploratory regressions
reg wholesale lgas_p RE_share Gas_share c.ln_gas_p#c.Gas_share c.ln_gas_p#c.RE_share i.month#i.dow i.hour#i.dow i.yr, cluster(dt)
outreg2 using j25GEN.doc, append label keep(ln_gas_p c.ln_gas_p#c.Gas_share c.ln_gas_p#c.RE_share RE_share Gas_share) nocons ctitle("Poland") title("Pass-through coefficents") addnote("Duration: Jan 2020-Nov 2021; Time effects: Month * Day of week, Hour * Day of week, Year; Errors clustered on Day")


reg wholesale gas_p i.month#i.dow i.hour#i.dow i.yr, cluster(dt)
outreg2 using j255.doc, append label keep(ln_gas_p) nocons ctitle("Greece") title("Pass-through coefficents") addnote("Duration: Jan 2020-Nov 2021; Time effects: Month * Day of week, Hour * Day of week, Year; Errors clustered on Day")

reg wholesale gas_p c.gas_p#i.hour i.month#i.dow i.hour#i.dow i.yr, cluster(dt)
eststo: margins, dydx(ln_gas_p) at(hour=(0(1)23)) vsquish post
esttab using jan272.rtf, append label compress onecell


** Convert coal price from $/tonne to EUR/MWh
replace coal_p = coal_p * 0.85/8.14
drop ln_coal_p
gen ln_coal_p = ln(coal_p)


**** Truncate dataset to April 2021-November 2021 and more exploratory analysis

*input country dataset _2020
use _2020
keep if yr==2021 & month >= 4
gen wk = week(dt) //week variable
save _2021
reg wholesale gas_p c.gas_p#i.hour i.month#i.dow i.hour#i.dow, cluster(dt)
eststo: margins, dydx(ln_gas_p) at(hour=(0(1)23)) vsquish post

*labeling shares
label var RE_share "% Renewable energy"
label var Imports_share "% Imports"
label var Gas_share "% Gas"
label var Biomass_share "% Biomass"
label var Coal_share "% Coal"
label var Lignite_share "% Lignite"
label var Other_share "% Other"
label var Nuc_share "% Nuclear"
label var Oil_share "% Oil"
label var Hydro_share_Dispatch "% Hydro storage + resevoir"



*Histograms of gas generations hare across countries 
foreach x in FR ES PT PL FI IT DE_Amprion{
	clear
	use `x'_2021
	hist Gas_share, title(`x'_"Gas") name(`x') frequency
	reg ln_wholesale ln_gas_p c.ln_gas_p#i.hour i.month#i.dow i.hour#i.dow, cluster(dt)
    eststo: margins, dydx(ln_gas_p) at(hour=(0(1)23)) vsquish post
	esttab using ES_j28.rtf, append label compress onecell
}


*Histrograms and exploratory analysis by month 
drop period
gen period = 1 if month<=4
replace period = 2 if month>= 4 & month<=9 
replace period = 3 if month > 9
hist Gas_share if month>=4, by(hour) percent title("Portugal at hour:")

keep if yr==2021 & month >= 4
save _2021

*change shares
replace RE_share =  (gen_Hydro_run + gen_Wind_onshore + gen_Solar + gen_Wind_offshore + gen_Other_renewable)/country_total
gen Hydro_dispatch = gen_Hydro_reservoir+gen_Hydro_storage
gen Hydro_share_Dispatch = (Hydro_dispatch)/country_total
gen RE_gen = RE_share * country_total



foreach y in "AT" "BE" "BG" "CH" "CZ" "DE_50Hz" "DE_Amprion" "DE_Tennet" "DE_TransnetBW" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "LV" "NL" "NO_1" "NO_2" "NO_3" "NO_4" "NO_5" "PT" "PL" "RO" "RS" "SI" "SK"{

	use `y'_2021
	
	**Create averages by hour for generations shares
	capture egen meanS_gas = mean(Gas_share), by(hour)
	capture egen meanS_Coal = mean(Coal_share), by(hour)
	capture egen meanS_RE = mean(RE_share), by(hour)
	capture egen meanS_Hydro = mean(Hydro_share_Dispatch), by(hour)
	capture egen meanS_Nuc = mean(Nuc_share), by(hour)
	capture egen meanS_Oil = mean(Oil_share), by(hour)
	capture egen meanS_Biomass = mean(Biomass_share), by(hour)
	capture egen meanS_Other = mean(Other_share), by(hour)
	capture egen meanS_Imports = mean(Imports_share), by(hour)
	capture egen meanS_Lignite = mean(Lignite_share), by(hour)
	capture egen mean_total = mean(country_total), by(hour)
	gen Waste_share = gen_Waste/country_total
egen meanS_Waste = mean(Waste_share), by(hour)


**Broken down by RE**
 egen meanS_solar= mean(solar_share), by(hour)
 label var meanS_solar "% Solar"
 egen meanS_wind= mean(wind_share), by(hour)
 label var meanS_wind "% Wind"
 egen meanS_hydrorun= mean(hydro_run_share), by(hour)
 label var meanS_hydrorun "% Hydro-run"

drop Other_share
gen Other_share = gen_Other/country_total
capture egen meanSr_solar= mean(solar_share), by(hour)
capture egen meanSr_wind= mean(wind_share), by(hour)
capture egen meanSr_hydroh= mean(hydro_run_share), by(hour)
cap label var meanSr_solar "% Solar"
cap label var meanSr_wind "% Wind"
cap label var meanSr_hydroh "% Hydro-run"
cap label var meanS_Waste "% Waste"

	egen mean_total = mean(country_total), by(hour
	rename mean_total total

	capture egen mean_wholesale= mean(wholesale), by(hour)


	
	//Depending on which wind exists
	capture confirm variable gen_Wind_offshore{
		if !_rc{
			cap gen wind_share = (gen_Wind_onshore+gen_Wind_offshore)/country_total
				save `y'_2021,replace

		}
		else{
			cap gen wind_share = (gen_Wind_onshore)/country_total
				save `y'_2021,replace
		}
	}
	

egen mean_gas = mean(gen_Gas), by(hour)
egen mean_Coal = mean(gen_Hard_coal), by(hour)
egen mean_RE = mean(RE), by(hour)
egen mean_Hydro = mean(Hydro_Dispatch), by(hour)
egen mean_Nuc = mean(gen_Nuclear), by(hour)
egen mean_Oil = mean(gen_Oil), by(hour)
egen mean_Biomass = mean(gen_Biomass), by(hour)
egen mean_Imports = mean(Imports), by(hour)




***Labels**
label var meanS_Gas " Gas"
label var meanS_Coal " Coal"
label var meanS_RE " RE(Intermittent)"
label var meanS_Hydro " Hydro dispatchable"
label var meanS_Nuc " Nuclear"
label var meanS_Oil " Oil"
label var meanS_Biomass " Biomass"
label var meanS_Other " Other"
label var meanS_Imports " Imports"
label var meanS_Lignite " Lignite"
capture label var capf_Waste "Waste"
cap label var meanSr_solar " Solar"
cap label var meanSr_wind " Wind"
cap label var meanSr_hydroh " Hydro-run"
cap label var meanS_solar "% Solar"
cap label var meanS_wind "% wind"
cap label var meanS_hydrorun "% hydro run"
cap label var meanS_Hydro " Hydro(Dispatchable)"
cap label var capf_RE "% RE(Intermittent)"
cap label var meanS_Waste " Waste"



label var mean_gas "Gas"
label var mean_Coal "Coal"
label var mean_RE "Intermittent RE"
label var mean_Hydro "Hydro dispatchable"
label var mean_Nuc "Nuclear"
label var mean_Oil "Oil"
label var mean_Biomass "Biomass"
label var mean_Other "Other"
label var mean_Imports "Imports"
label var mean_Lignite "Lignite"
 label var mean_total "Load (MWh)"
rename mean_total total


**Generate capacity variables for each source, assuming max value as the capacity
capture egen cap_gas = max(gen_Gas)
capture egen cap_coal = max(gen_Hard_coal)
capture egen cap_RE = max(RE_gen)
capture egen cap_Nuc = max(gen_Nuclear)
capture egen cap_Oil = max(gen_Oil)
capture egen cap_Biomass = max(gen_Biomass)
capture egen cap_Other = max(gen_Other + gen_Waste)
capture egen cap_Imports = max(Imports)
capture egen cap_Lignite = max(gen_Lignite)
capture egen cap_Coals = max(Coals)
cap egen cap_Hydro = max(Hydro_Dispatch)

*** Averaged CF for each hour of day 
capture egen capf_gas = mean(gen_Gas/cap_gas),by(hour)
capture egen capf_coal =  mean(gen_Hard_coal/cap_coal),by(hour)
capture egen capf_RE = mean(RE_gen/cap_RE), by(hour)
capture egen capf_Hydro = mean(Hydro_Dispatch/cap_Hydro),by(hour)
capture egen capf_Nuc = mean(gen_Nuclear/cap_Nuc),by(hour)
capture egen capf_Oil = mean(gen_Oil/cap_Oil),by(hour)
capture egen capf_Biomass = mean(gen_Biomass/cap_Biomass),by(hour)
capture egen capf_Other = mean((gen_Other+gen_Waste)/cap_Other),by(hour)
capture egen capf_Imports = mean(Imports/cap_Imports),by(hour)
capture egen capf_Lignite = mean(gen_Lignite/cap_Lignite), by(hour)

capture label var capf_gas "Gas"
capture label var capf_coal "Coal"
capture label var capf_RE "Intermittent Renewables"
capture label var capf_Hydro "Hydro (Dispatchable)"
capture label var capf_Nuc "Nuclear"
capture label var capf_Oil "Oil"
capture label var capf_Biomass "Biomass"
capture label var capf_Other "Other"
capture label var capf_Imports "Imports"
capture label var capf_Lignite "Lignite"



**Gas Capacity Factors: Σ(Non-Gas) CF vs Gas CF

capture egen total_cap = rowtotal(cap_*) //total capacity
replace total_cap= total_cap -cap_gas //totla minus gas
capture gen total_nogas= country_total - gen_Gas //total generation minus gas
capture gen stable_cap =total_nogas/total_cap //total capacity minus gas capacity
capture gen gas_cap = gen_Gas/cap_gas //Gas CF
capture egen stable_cap_avg = mean(stable_cap), by(hour) //Averaged Σnon-gas capacity by hour

//Averaged by day
capture egen gas_cap_day = mean(gas_cap), by(dt) 
capture egen stable_cap_day = mean(stable_cap), by(dt)

label var stable_cap_avg "CF all other sources"
label var stable_cap_day "CF all other sources"
label var gas_cap_day "Gas CF"




**Create hour bins for hour-groups for figures and regressions

gen hour_bin = 1 if hour<10 //12Am-9am
replace hour_bin = 2 if hour>9 & hour<17 //10am to 16pm
replace hour_bin = 3 if hour> 16  //17pm to 23pm


**By hour group
**Generally: meanH is by hour group, meanS(r) is for all hours of the day

	capture egen meanH_solar= mean(solar_share), by(hour_bin)
	capture egen meanH_wind= mean(wind_share), by(hour_bin)
	capture egen meanH_gas= mean(Gas_share), by(hour_bin)
	capture egen meanH_coal= mean(Coal_share), by(hour_bin)
	capture egen meanH_RE= mean(RE_share), by(hour_bin)
	egen meanH_Hydro_Dispatch= mean(Hydro_Dispatch), by(hour_bin)
	label var meanH_Hydro "% Hydro (Dispatch)"
	
	

**Genrate average daily wholesale price
 egen wholesale_daily_avg = mean(wholesale),by(dt)
 label var wholesale_daily_avg "Wholesale price averaged by day"
 label var dt "Day"
 
 **Geometric mean of average price change over sample
 cap egen wholesale_month_avg = mean(wholesale),by(month) //averaged by month
gen percent_priceChange = exp((ln(wholesale_month_avg[num_hours-35])-ln(wholesale_month_avg[1]))/6) - 1
tabstat percent_priceChange
	
}



*** If Country does not have an energy source, make generation and capacity 0 **

//Gas
capture confirm var meanS_Gas, exact
if c(rc)== 111 {
	gen meanS_Gas=0
	cap gen capf_Gas=0
	
 label var meanS_Gas "% Gas"
 label var capf_Gas "Gas"

}
//Lignite
capture confirm var meanS_Lignite, exact
if c(rc)== 111 {
	gen meanS_Lignite=0
	gen capf_Lignite=0
	
 label var meanS_Lignite "% Lignite"
 label var capf_Gas "Lignite"

}
//Coal
capture confirm var meanS_Coal, exact
if c(rc)== 111 {
	gen meanS_Coal=0
	gen capf_Coal=0
	label var meanS_Coal "% Coal"
  label var capf_Coal "Coal"
}
//Hydro
capture confirm var meanS_Hydro, exact
if c(rc)== 111 {
	gen meanS_Hydro=0
	cap gen capf_Hydro=0
	
	label var meanS_Hydro "% Hydro"
 label var capf_Hydro "Hydro"

}
//RE
capture confirm var meanS_RE, exact
if c(rc)== 111 {
	gen meanS_RE=0
	gen capf_RE=0
}
//Oil
capture confirm var meanS_Oil, exact
if c(rc)== 111 {
	gen meanS_Oil=0
	gen capf_Oil=0
	
	 label var meanS_Oil "% Oil"
	 label var capf_Oil "Oil"
}
//Biomass
capture confirm var meanS_Biomass, exact
if c(rc)== 111 {
	gen meanS_Biomass=0
	gen capf_Biomass=0
	
 label var meanS_Biomass "% Biomass"
 label var capf_Biomass "Biomass"
}
//Other
capture confirm var meanS_Other, exact
if c(rc)== 111 {
	gen meanS_Other=0
	cap gen capf_Other=0
	
 label var meanS_Other "% Other"
 label var capf_Other "Other"

}
//Nuclear
capture confirm var meanS_Nuc, exact
if c(rc)== 111 {
	gen meanS_Nuc=0
	gen capf_Nuc=0
	
 label var meanS_Nuc "% Nuclear"
 label var capf_Nuc "Nuclear"

}
//Waste
capture confirm var meanS_Waste, exact
if c(rc)== 111 {
	gen meanS_Waste=0
	gen capf_Waste=0
	
 label var meanS_Waste "% Waste"
 label var capf_Waste "Waste"
}
//Hydro-run
capture confirm var meanSr_hydroh, exact
if c(rc)== 111 {
	gen meanSr_hydroh=0
 label var meanSr_hydroh "% Hydro-run"
}
//Wind
capture confirm var meanSr_wind, exact
if c(rc)== 111 {
	gen meanSr_wind=0
	
 label var meanSr_wind "% Wind"
}
//Solar
capture confirm var meanSr_solar, exact
if c(rc)== 111 {
	gen meanSr_solar=0
	
 label var meanSr_solar "% Solar"
}





***Clean price data for before April 2021


putexcel set Historical_prices, replace

putexcel A1 = "Country"
putexcel B1="Wholesale_Historic"

local myrow = 2



foreach y in "AT" "BE" "BG" "CH" "CZ" "DE_50Hz"  "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" " NO_1" "PL" "PT" "RO" "RS" "SI" "SK" {

	use `y'_gen,clear

	putexcel A`myrow' = "`y'"

	*Make sure prices make sense for this period
	drop if wholesale>800
	drop if wholesale<-350
	cap gen n = _n
	//Before April 2021 
	tabstat wholesale if n<54755, save
	tabstat wholesale, save
	putexcel B`myrow' = matrix(r(StatTotal))
	local myrow = `myrow' + 1

	//save `y'_gen,replace

}


