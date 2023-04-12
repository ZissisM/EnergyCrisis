
**Excel of all possible baselines to use 
*Ended up using 2016-current 
*where current is the sample start at April 2021
putexcel set baselines2, replace
putexcel A1 = "Country"
putexcel B1= "2016-current"
putexcel C1="2017-current"
putexcel D1="2018-current"
putexcel E1="2019-current"
putexcel F1="2020-current"
putexcel G1="2021-current"






local myrow = 2

foreach y in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK"  {

	putexcel A`myrow' = "`y'"
	tabstat `y'_h if ym<735 & ym>671 , save
	putexcel B`myrow' = matrix(r(StatTotal))
	tabstat `y'_h if ym<735 & ym>683 , save
	putexcel C`myrow' = matrix(r(StatTotal))
	tabstat `y'_h if ym<735 & ym>695 , save
	putexcel D`myrow' = matrix(r(StatTotal))
	tabstat `y'_h if ym<735 & ym>707 , save
	putexcel E`myrow' = matrix(r(StatTotal))
	tabstat `y'_h if ym<735 & ym>719 , save
	putexcel F`myrow' = matrix(r(StatTotal))
	tabstat `y'_h if ym<735 & ym>731 , save
	putexcel G`myrow' = matrix(r(StatTotal))
	

	
	local myrow = `myrow' + 1

}


*Calculate absolute Vulnerability

replace baseline= b2016
replace relV= Hours_PT*(baseline+Intensity)
replace nonV= (24-Hours_PT)*(baseline)
replace absV=(relV+nonV)/24
