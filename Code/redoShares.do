*File for calculating generation shares and means for every country 
*Updating allcountries datasets with new generation shares 



foreach y in "AT" "BE" "BG" "CH" "CZ" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL"  "PL" "PT" "RO" "RS" "SI" "SK"  {
	*Subset TSOs dealt with differently
	//foreach y in	 "DE_50Hz" "DE_Amprion" "DE_TransnetBW" "DE_Tennet" "NO_1" "NO_2" "NO_3" "NO_4"{

	use `y'_new

	cap drop totalgen 
	* Can use the previously calculated that country_total included Imports, subtract for each country
	cap gen totalgen= country_total-Imports

	*Initialize to keep consistency across countries 
	cap rename meanS_gas meanS_Gas
	cap gen meanS_Nuc=0
	cap gen meanS_Waste=0
	cap gen meanS_Oil=0
	cap gen meanS_Lignite=0
	cap gen meanS_Gas=0
	cap gen meanS_Coal=0
	cap gen meanS_Biomass=0
	cap gen meanS_Hydro=0
	cap gen meanSr_hydroh = 0
	cap gen meanSr_solar = 0
	cap gen meanSr_wind = 0
	cap gen Oil_share = 0 if meanS_Oil==0
	cap gen Hydro_dispatch_share = 0 if meanS_Hydro==0
	cap gen Coal_share = 0 if meanS_Coal==0
	cap gen Biomass_share = 0 if meanS_Biomass==0
	cap gen Other_share = 0 if meanS_Other==0
	cap gen Lignite_share = 0 if meanS_Lignite==0
	cap gen Waste_share = 0 if meanS_Waste==0
	cap gen solar_share = 0 if meanSr_solar==0
	cap gen wind_share = 0 if meanSr_wind==0
	cap gen hydro_run_share = 0 if meanSr_hydroh==0
	cap gen Nuc_share = 0 if meanS_Nuc==0

	cap replace solar_share = gen_Solar/totalgen
	cap replace wind_share = gen_Wind_onshore/totalgen

	*By load
	cap gen Oil_share_l = Oil_share*country_total/load
	cap gen Other_share_l = Other_share*country_total/load
	cap gen Waste_share_l = Waste_share*country_totalload
	cap gen Gas_share_l = Gas_share*country_total/load
	cap gen Coal_share_l =Coal_share*country_total/load
	cap gen Hydro_share_l = Hydro_share_Dispatch*country_total/load
	cap gen solar_share_l = solar_share*country_total/load
	cap gen wind_share_l = wind_share*country_total/load
	cap gen Nuc_share_l = Nuc_share*country_total/load
	cap gen Lignite_share_l = (Lignite_share*country_total)/load 
	cap gen Imports_share_l = Imports_share*country_total/load
	cap gen hyro_run_share_l = (hydro_run_share*country_total)/load
	cap gen RE_share_l = (RE_share*country_total)/load
	cap gen Biomass_share_L = (Biomass_share*country_total)/load
	cap gen Others_share_l = Biomass_share_l+Oil_share_l +Waste_share_l+Other_share_l


	***By total generation (Used for Figure 7)

	//cap drop coal_tg gas_tg nuc_tg hydro_tg others_tg re_tg
	//cap gen re_tg = 0 

	cap replace re_tg = (RE_gen*1000)/totalgen
	cap replace hydror_tg = gen_Hydro_run/totalgen
	cap replace oil_tg = gen_Oil/totalgen
	cap replace other_tg = gen_Other/totalgen
	cap replace waste_tg = gen_Waste/totalgen
	cap replace bio_tg = gen_Biomass/totalgen
	cap replace others_tg = (oil_tg+bio_tg+other_tg+waste_tg)
	
	*Deal with lignite and coal combined
	cap replace gen_coal =  gen_Lignite
	cap replace gen_coal =  gen_Hard_coal
	cap replace gen_coal = gen_Hard_coal + gen_Lignite

	
	replace re_tg = RE_gen/totalgen
	replace solar_s = gen_Solar/totalgen
	replace wind_s= gen_Wind_onshore/totalgen
	replace Nuc_s=gen_Nuc/totalgen
	replace Gas_s=gen_Gas/totalgen
	replace Coal_s=(gen_Hard_coal+gen_Coal_gas)/totalgen
	replace Hydro_s= (gen_Hydro_reservoir+gen_Hydro_storage)/totalgen
	replace others_tg=(gen_Waste+gen_Biomass+gen_Other+gen_Oil)/totalgen
	replace hydror_tg= gen_Hydro_run/totalgen

	*because RE_gen was converted to GWh
	cap replace re_tg = RE_gen/totalgen *1000



	

	**By hour averages
	
	cap drop Coal_tgm Gas_tgm Nuc_tgm Hydro_tgm others_tgm re_tgm solar_tgm wind_tgm hydror_tgm
	cap drop re_tgm
	cap egen Coal_tgm=mean(Coal_s),by(hour)
	cap egen Gas_tgm=mean(Gas_s),by(hour)
	cap egen Nuc_tgm=mean(Nuc_s),by(hour)
	cap egen Hydro_tgm=mean(Hydro_s),by(hour)
	cap egen others_tgm=mean(others_tg),by(hour)
	cap egen re_tgm=mean(re_tg),by(hour)
	cap egen solar_tgm = mean(solar_s),by(hour)
	cap egen wind_tgm = mean(wind_s),by(hour)
	cap egen hydror_tgm = mean(hydror_tg),by(hour)

	label var Coal_tgm "Coal"
	label var Gas_tgm "Gas"
	label var Nuc_tgm "Nuclear"
	label var Hydro_tgm "Hydro (Dispatchable)"
	label var others_tgm "Other"
	label var re_tgm "Intermittent Renewable"


	label var solar_tgm "Solar"
	label var wind_tgm "Wind"
	label var hydror_tgm "Hydro-run"
	//label var re_tg "% Intermittent Renewable"
	//label var Gas_s "% Gas"

	
	***Generation capacity factors, assuming that capacity=maximum value observed for each generation source
	
	cap gen others_gen = others_tg*totalgen
	cap egen cap_others = max(others_gen)
	cap drop capf_Others capf_Coal
	cap egen capf_Others = mean(others_gen/cap_others), by(hour)
	cap gen coals_gen = Coal_s*totalgen
	cap egen cap_coals = max(coals_gen)
	cap egen capf_Coals = mean(coals_gen/cap_coals),by(hour)
	label var capf_Coals "Coal"
	label var capf_Others "Other"

	*Non-gas dispatchable capacity calculation (coal, hydro, others, nuclear)
	
	cap gen all_gen = Coal_s*totalgen+Hydro_s*totalgen+others_tg*totalgen+Nuc_s*totalgen
	cap egen cap_all=max(all_gen)
	cap drop cf_alls
	cap egen cf_alls= mean(all_gen/cap_all),by(hour)
	label var cf_alls "Σ(Non-gas)"
	label var capf_RE "IRE"
	label var re_tgm "IRE"
	label var re_tg "% IRE"
	label var capf_Hydro "Hydro (Dispatchable)"
	cap gen capf_Gas=0 //for Switzerland
	label var capf_Nuc "Nuclear"
	label var capf_Gas "Gas"

}



***Create dataset with new share calculations for the 6 types in Figure 7

*Output to excel and then input again into new stata dataset (EXAMPLES BELOW)
*Edit in Excel for Averaged DE and NO based on weighting by load per their TSOs

putexcel set newShares replace
putexcel A1 = "labels"
putexcel B1 = "Nuc"
putexcel C1 = "Wind"
putexcel D1 = "Solar"
putexcel E1= "Coal"
putexcel F1= "Gas"
putexcel G1="Lignite"
putexcel H1="Hydro"

local myrow = 2


foreach x in "AT" "BE" "BG" "CH" "CZ" "DE_50Hz" "DE_Amprion" "DE_TransnetBW" "DE_Tennet" "DK"  "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO_1" "NO_2" "NO_3" "NO_4" "PL" "PT" "RO" "RS" "SI" "SK" {


	use `x'_new,clear
	putexcel A`myrow' = "`x'"
        tabstat Nuc_s, save
	putexcel B`myrow' = matrix(r(StatTotal))
	tabstat wind_s , save
	putexcel C`myrow' = matrix(r(StatTotal))
	tabstat solar_s ,save
	putexcel D`myrow' = matrix(r(StatTotal))
	tabstat Coal_s  ,save
	putexcel E`myrow' = matrix(r(StatTotal))
	tabstat Gas_s  ,save
	putexcel F`myrow' = matrix(r(StatTotal))
	tabstat Lignite_s ,save
	putexcel G`myrow' = matrix(r(StatTotal))
	tabstat Hydro_s ,save
	putexcel H`myrow' = matrix(r(StatTotal))


	local myrow = `myrow' + 1

}

*No october for Solar/Wind/Nuc generation shares
*Can edit this template for other shares/restrictions

putexcel set SharesNoOct, replace
putexcel A1 = "Country"
putexcel B1 = "Solar"
putexcel C1 = "Wind"
putexcel D1 = "Nuc"

local myrow = 2

foreach y in "AT" "BE" "BG" "CH" "CZ" "DE_50Hz" "DE_Tennet" "DE_TransnetBW" "DE_Amprion" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO_1" "NO_2" "NO_3" "NO_4"  "PL" "PT" "RO" "RS" "SI" "SK"  {

	use `y'_new, clear   

	putexcel A`myrow' = "`y'"
        tabstat solar_s if month<10,save
	putexcel B`myrow' = matrix(r(StatTotal))
	tabstat  wind_s if month<10,save
	putexcel C`myrow' = matrix(r(StatTotal))
	tabstat  Nuc_s if month<10,save
	putexcel D`myrow' = matrix(r(StatTotal))

	local myrow = `myrow' + 1

}


***Input into dataset with vulnerability metrics and updated generation shares

clear
import excel SharesNoOct, sheet("Sheet1") firstrow
save shares_noOct,replace
//change which one to save it into 
use allcountries_noOct
drop Solar Wind Nuc
merge m:1 Country using shares_noOct
drop _merge
//change where to save it
save allcountries_noOct,replace



***Generate intensity by percentage (Extended Data Figure 2)
use allcountries
drop percIntensity
gen percIntensity = Intensity/historic_wholesale * 100


