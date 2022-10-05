***Robsutness Check Table Data
*Tables edited manually given generated estimates/data from below




*** SI Table 1 and EDF2 for Specifications tests*** 
foreach x in "AT" "FR" "IT" "PL" "PT" {
	eststo clear
	use `x'_new,clear
	replace load= load/1000
	*Bivariate
	reg wholesale_test gas_p, vce(robust) 
	outreg2 using `x'SIs.doc,replace se label adjr2 keep(gas_p  c.load##c.load RE_gen) bdec(2) nocons ctitle("(1)")
	* Including load
	reg wholesale_test gas_p c.load##c.load, vce(robust)
	outreg2 using `x'SIs.doc,append se label adjr2  bdec(2)  keep(gas_p c.load##c.load RE_gen) nocons ctitle("(2)")
	* Including IRE
	reg wholesale_test gas_p c.load##c.load RE_gen, vce(robust)
	outreg2 using `x'SIs.doc,append se label adjr2  bdec(2)  keep(gas_p  c.load##c.load RE_gen) nocons ctitle("(3)")
	*Including month FE
	reg wholesale_test gas_p c.load##c.load RE_gen i.month, vce(robust)
	outreg2 using `x'SIs.doc,append se label adjr2 bdec(2)  keep(gas_p  c.load##c.load RE_gen) addtext(Month FE,YES) nocons ctitle("(4)")
	*Including all FE
	reg wholesale_test gas_p c.load##c.load RE_gen i.month#i.hour i.dow#i.hour, vce(robust)
	outreg2 using `x'SIs.doc,append se label adjr2 bdec(2)  keep(gas_p  c.load##c.load RE_gen) addtext(Month FE, NO, Month-by-Hour FE, YES, Day-of-Week-by-Hour FE, YES) nocons ctitle("(5)")
	*Clustering SE
	reg wholesale_test gas_p c.load##c.load RE_gen i.month#i.hour i.dow#i.hour, cl(dt)
	outreg2 using `x'SIs.doc,append se label adjr2  bdec(2)  keep(gas_p  c.load##c.load RE_gen) addtext(Month FE,NO , Month-by-Hour FE, YES, Day-of-Week-by-Hour FE, YES, Clustered SE, YES) title(`x') nocons ctitle("(6)")


}



***SI Table 2, each country a separate doc file 
foreach x in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK" {
	//foreach x in "AT" {
	use `x'_new,clear
	replace load = load/1000
	*No Controls
	reg wholesale_test gas_p i.month#i.hour i.dow#i.hour, cl(dt) 
	outreg2 using `x'SIT.doc,append se label keep(gas_p) bdec(3) nocons ctitle("(1)")
	* No FE
	reg wholesale_test gas_p RE_gen c.load##c.load, cl(dt)
	outreg2 using `x'SIT.doc,append se label keep(gas_p) bdec(3) nocons ctitle("(2)")
	// 		* No October
	reg wholesale_test gas_p RE_gen c.load##c.load i.month#i.hour i.dow#i.hour if month<10, cl(dt)
	outreg2 using `x'SIT.doc,append se label keep(gas_p) bdec(3) nocons ctitle("(3)")
	// 		*No April
	reg wholesale_test gas_p RE_gen c.load##c.load i.month#i.hour i.dow#i.hour if month>4, cl(dt)
	outreg2 using `x'SIT.doc,append se label keep(gas_p) bdec(3) nocons ctitle("(4)")
	// 		*No April or October
	reg wholesale_test gas_p RE_gen c.load##c.load i.month#i.hour i.dow#i.hour if month>4 & month<10, cl(dt)
	outreg2 using `x'SIT.doc,append se label keep(gas_p) bdec(3) nocons ctitle("(5)")
	// 		*Log-Log
	gen ln_wholesale_test = ln(wholesale_test)
	reg ln_wholesale_test ln_gas_p RE_gen c.load##c.load i.month#i.hour i.dow#i.hour, cl(dt)
	outreg2 using `x'SIT.doc,append se label keep(ln_gas_p) bdec(3) nocons ctitle("(6)")
	// 		*Preferred, used specification
	reg wholesale_test gas_p RE_gen c.load##c.load i.month#i.hour i.dow#i.hour, cl(dt)
	outreg2 using `x'SIT.doc,append se label keep(gas_p) bdec(3) nocons ctitle("(7)")

}

***Data for SITable2 into excel file combined all countries

putexcel set SI_Table2, replace

putexcel A1 = "Country"
putexcel B1= "No Covariates"
putexcel C1= "std"
putexcel D1= "No FE"
putexcel E1= "std"
putexcel F1= "Excluding October"
putexcel G1= "std"
putexcel H1= "Excluding April"
putexcel I1= "std"
putexcel J1= "Excluding April & October"
putexcel K1= "std"
putexcel L1= "Log-Log"
putexcel M1= " std"
putexcel N1= " Preferred"
putexcel O1= " std"



local myrow = 2


foreach x in "AT" "BE" "BG" "CH" "CZ" "DE"  "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK"{
	use `x'_new, clear    

	if trend==0{
		putexcel A`myrow' = "`x'"
		reg wholesale_test gas_p i.month#i.hour i.dow#i.hour, cl(dt) 
		putexcel B`myrow' = matrix(e(b)[1,1]) //coefficient
		mat t1= r(table)
		putexcel C`myrow' = t1[2,1] //std
		reg wholesale_test gas_p RE_gen c.load##c.load, cl(dt)
		putexcel D`myrow' = matrix(e(b)[1,1])
		mat t2= r(table)
		putexcel E`myrow' = t2[2,1]
		reg wholesale_test gas_p RE_gen c.load##c.load i.month#i.hour i.dow#i.hour if month<10, cl(dt)
		putexcel F`myrow' = matrix(e(b)[1,1])
		mat t3= r(table)
		putexcel G`myrow' = t3[2,1]
		reg wholesale_test gas_p RE_gen c.load##c.load i.month#i.hour i.dow#i.hour if month>4, cl(dt)
		putexcel H`myrow' = matrix(e(b)[1,1])
		mat t4=r(table)
		putexcel I`myrow' = t4[2,1]
		reg wholesale_test gas_p RE_gen c.load##c.load i.month#i.hour i.dow#i.hour if month>4 & month<10, cl(dt)
		putexcel J`myrow' = matrix(e(b)[1,1])
		mat t5=r(table)
		putexcel K`myrow' = t5[2,1]
		gen ln_wholesale_test = ln(wholesale_test)
		reg ln_wholesale_test ln_gas_p RE_gen c.load##c.load i.month#i.hour i.dow#i.hour, cl(dt)
		putexcel L`myrow' = matrix(e(b)[1,1])
		mat t6=r(table)
		putexcel M`myrow' = t6[2,1]
		reg wholesale_test gas_p RE_gen c.load##c.load i.month#i.hour i.dow#i.hour, cl(dt)
		putexcel N`myrow' = matrix(e(b)[1,1])
		mat t7=r(table)
		putexcel O`myrow' = t7[2,1]
		local myrow = `myrow' + 1


	}
	//for GR
	if trend==1{
		putexcel A`myrow' = "`x'"
		reg wholesale_test gas_p i.dow#i.hour c.t, cl(dt) 
		putexcel B`myrow' = matrix(e(b)[1,1]) //coefficient
		mat t1= r(table)
		putexcel C`myrow' = t1[2,1] //std
		reg wholesale_test gas_p RE_gen c.load##c.load, cl(dt)
		putexcel D`myrow' = matrix(e(b)[1,1])
		mat t2= r(table)
		putexcel E`myrow' = t2[2,1]
		reg wholesale_test gas_p RE_gen c.load##c.load i.dow#i.hour c.t if month<10, cl(dt)
		putexcel F`myrow' = matrix(e(b)[1,1])
		mat t3= r(table)
		putexcel G`myrow' = t3[2,1]
		reg wholesale_test gas_p RE_gen c.load##c.load i.dow#i.hour c.t if month>4, cl(dt)
		putexcel H`myrow' = matrix(e(b)[1,1])
		mat t4=r(table)
		putexcel I`myrow' = t4[2,1]
		reg wholesale_test gas_p RE_gen c.load##c.load c.t i.dow#i.hour if month>4 & month<10, cl(dt)
		putexcel J`myrow' = matrix(e(b)[1,1])
		mat t5=r(table)
		putexcel K`myrow' = t5[2,1]
		gen ln_wholesale_test = ln(wholesale_test)
		reg ln_wholesale_test ln_gas_p RE_gen c.load##c.load c.t i.dow#i.hour, cl(dt)
		putexcel L`myrow' = matrix(e(b)[1,1])
		mat t6=r(table)
		putexcel M`myrow' = t6[2,1]
		reg wholesale_test gas_p RE_gen c.load##c.load c.t i.dow#i.hour, cl(dt)
		putexcel N`myrow' = matrix(e(b)[1,1])
		mat t7=r(table)
		putexcel O`myrow' = t7[2,1]
		local myrow = `myrow' + 1

	}
}



**Table for all countries with preferred specification and showing all coefficients-- EDF Table 3 
*Pass-Through and Covariate Coefficient Results for all Countries, combined load effect, observations, and R-squared
*Import into one excel file, manually edited and added combined load effect

foreach x in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK" {

	use `x'_new,clear
	replace load = load/1000
	reg wholesale_test gas_p RE_gen c.load##c.load i.month#i.hour i.dow#i.hour, cl(dt)
	sum load,detail
	local m = r(mean)
	**combined load effect
	lincom _b[load]+(2*_b[c.load#c.load])*`m'
	outreg2 using SIs_6.xls,append se label keep(gas_p RE_gen c.load##c.load) auto(3) nocons ctitle(`x') 
}



***Data for Table EDF 2 for Pass-Through  Results for all Countries across Hours (reflected in Figure panels A,C,D,E,F)

putexcel set Table3, replace

putexcel A1 = "Country"
putexcel B1= " Am"
putexcel C1= " Am_std"
putexcel D1= " Am_p"
putexcel E1= " Pm"
putexcel F1= " Pm_std"
putexcel G1= " Pm_p"
putexcel H1= " Pmm"
putexcel I1= " Pmm_std"
putexcel J1= " P,m_p"
putexcel K1= " Avg"
putexcel L1= " Avg_std"
putexcel M1= " Avg_p"



local myrow = 2


foreach x in "AT" "BE" "BG" "CH" "CZ" "DE"  "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK"{

	use `x'_new, clear    
	if trend==0{
		putexcel A`myrow' = "`x'"
		reg wholesale_test gas_p c.load##c.load RE_gen i.month#i.hour i.hour#i.dow if hour_bin==1, cluster(dt)	
		putexcel B`myrow' = matrix(e(b)[1,1]) //coefficient
		mat t1= r(table)
		putexcel C`myrow' = t1[2,1] //std
		putexcel D`myrow' = t1[4,1] //p-value

		reg wholesale_test gas_p c.load##c.load RE_gen i.month#i.hour i.hour#i.dow if hour_bin==2, cluster(dt)	
		putexcel E`myrow' = matrix(e(b)[1,1])
		mat t2= r(table)

		putexcel F`myrow' = t2[2,1]
		putexcel G`myrow' = t2[4,1]
		reg wholesale_test gas_p c.load##c.load RE_gen i.month#i.hour i.hour#i.dow if hour_bin==3, cluster(dt)	
		putexcel H`myrow' = matrix(e(b)[1,1])
		mat t3= r(table)
		putexcel I`myrow' = t3[2,1]
		putexcel J`myrow' = t3[4,1]
		reg wholesale_test gas_p c.load##c.load RE_gen i.month#i.hour i.hour#i.dow, cluster(dt)
		putexcel K`myrow' = matrix(e(b)[1,1])
		mat t4=r(table)
		putexcel L`myrow' = t4[2,1]
		putexcel M`myrow' = t4[4,1]
	}

	if trend==1{
		putexcel A`myrow' = "`x'"
		reg wholesale_test gas_p c.load##c.load RE_gen i.hour#i.dow c.t if hour_bin==1, cluster(dt)	
		putexcel B`myrow' = matrix(e(b)[1,1]) //coefficient
		mat t1= r(table)
		putexcel C`myrow' = t1[2,1] 
		putexcel D`myrow' = t1[4,1] 

		reg wholesale_test gas_p c.load##c.load RE_gen i.hour#i.dow c.t if hour_bin==2, cluster(dt)	
		putexcel E`myrow' = matrix(e(b)[1,1])
		mat t2= r(table)

		putexcel F`myrow' = t2[2,1]
		putexcel G`myrow' = t2[4,1]
		reg wholesale_test gas_p c.load##c.load RE_gen i.hour#i.dow c.t if hour_bin==3, cluster(dt)	
		putexcel H`myrow' = matrix(e(b)[1,1])
		mat t3= r(table)
		putexcel I`myrow' = t3[2,1]
		putexcel J`myrow' = t3[4,1]
		reg wholesale_test gas_p c.load##c.load RE_gen i.hour#i.dow c.t, cluster(dt)
		putexcel K`myrow' = matrix(e(b)[1,1])
		mat t4=r(table)
		putexcel L`myrow' = t4[2,1]
		putexcel M`myrow' = t4[4,1]
	}


	local myrow = `myrow' + 1

}



***Data for SI Table 3: Multivariate regression alternative specifgications



*No Controls
use allcountries_noControls,clear
replace Solar = 0.038 in 7 //Denmark educated guess (based on ourworldindata.org Electricity Mix Profile) for solar so it does not omit entire country for missing this value in the regression
reg Intensity Solar Wind Nuc Coal Gas HydroDispatch,vce(robust)
test Solar Wind Nuc Coal Gas HydroDispatch 
outreg2 using SI3Multivariate.doc, replace se label bdec(2) nocons adds(F-test,r(F),Prob>F,`r(p)') adjr2

*NoFE
use allcountries_noFE,clear
replace Solar = 0.038 in 7 //Denmark educated guess (based on ourworldindata.org Electricity Mix Profile) for solar so it does not omit entire country for missing this value in the regression
reg Intensity Solar Wind Nuc Coal Gas HydroDispatch,vce(robust)
test Solar Wind Nuc Coal Gas HydroDispatch 
outreg2 using SI3Multivariate.doc, append se label bdec(2) nocons adds(F-test,r(F),Prob>F,`r(p)') adjr2

*No April
use allcountries_noApril,clear
replace Solar = 0.038 in 7 //Denmark educated guess (based on ourworldindata.org Electricity Mix Profile) for solar so it does not omit entire country for missing this value in the regression
reg Intensity Solar Wind Nuc Coal Gas HydroDispatch,vce(robust)
test Solar Wind Nuc Coal Gas HydroDispatch 
outreg2 using SI3Multivariate.doc, append se label bdec(2) nocons adds(F-test,r(F),Prob>F,`r(p)') adjr2

*No October
use allcountries_noOct,clear
replace Solar = 0.038 in 7 //Denmark educated guess (based on ourworldindata.org Electricity Mix Profile) for solar so it does not omit entire country for missing this value in the regression
reg Intensity Solar Wind Nuc Coal Gas HydroDispatch,vce(robust)
test Solar Wind Nuc Coal Gas HydroDispatch 
outreg2 using SI3Multivariate.doc, append se label bdec(2) nocons adds(F-test,r(F),Prob>F,`r(p)') adjr2

// *Load Shares
// use allcountries_loadshares,clear
// replace Solar = 0.038 in 7 //Denmark educated guess (based on ourworldindata.org Electricity Mix Profile) for solar so it does not omit entire country for missing this value in the regression
// reg Intensity Solar Wind Nuc Coal Gas HydroDispatch,vce(robust)
// test Solar Wind Nuc Coal Gas HydroDispatch 
// outreg2 using SI3Multivariate.doc, append se label bdec(2) nocons adds(F-test,r(F),Prob>F,`r(p)') adjr2

*Alternative Vulnerability
use allcountries_nonsig,clear
replace Solar = 0.038 in 7 //Denmark educated guess (based on ourworldindata.org Electricity Mix Profile) for solar so it does not omit entire country for missing this value in the regression
reg Intensity Solar Wind Nuc Coal Gas HydroDispatch,vce(robust)
test Solar Wind Nuc Coal Gas HydroDispatch 
outreg2 using SI3Multivariate.doc, append se label bdec(2) nocons adds(F-test,r(F),Prob>F,`r(p)') adjr2


**Main specification
use allcountries_genshares,clear
replace Solar = 0.038 in 7 //Denmark educated guess (based on ourworldindata.org Electricity Mix Profile) for solar so it does not omit entire country for missing this value in the regression
reg Intensity Solar Wind Nuc Coal Gas HydroDispatch,vce(robust)
test Solar Wind Nuc Coal Gas HydroDispatch 
outreg2 using SI3Multivariate.doc, append se label bdec(2) nocons adds(F-test,r(F),Prob>F,`r(p)') adjr2

*Output table but it is edited manually
