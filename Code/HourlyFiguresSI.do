**Hourly figures with multiple (8) panels per each TSO seen in SI Figures**

*legend format
grstyle clear
grstyle init
grstyle set legend 6

//foreach y in "AT" "BE" "BG" "CH" "CZ" "DE_50Hz" "DE_Amprion" "DE_Tennet" "DE_TransnetBW" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO_1" "NO_2" "NO_3" "NO_4" "PL" "PT" "RS" "SI" "SK"  {
foreach y in "DE" "NO" {
use `y'_new,clear



***Hourly Pass-Through*** (A)

*for GR 
if trend==1{
reg wholesale_test gas_p RE_gen c.load##c.load c.gas_p#i.hour i.dow#i.hour c.dt, cluster(dt) 
}

*for all others
if trend==0{
reg wholesale_test gas_p RE_gen c.load##c.load c.gas_p#i.hour i.dow#i.hour i.month#i.hour, cluster(dt) 
}

**Hourly pass-through panel 
eststo: margins, dydx(gas_p) at(hour=(0(1)23)) vsquish post noestimcheck 
coefplot, vertical recast(connected) msize(*1.3) lwidth(*1.2)  mlabel(cond(@pval<.01, "***", cond(@pval<.05, "**", ""))) xlabel(1 "0"  5 "4" 9 "8" 13 "12" 17 "16" 21 "20" 24 "23",labsize(*1.3) grid gmax gmin) mlabsize(large) xtitle("Hour of day",size(*1.45)) ytitle("Average Pass-through",size(*1.45)) mcolor(%75) msymbol(d) mfcolor(white) levels(95) ciopts(recast(. rcap) color(*0.65)) yline(0, lwidth(*2.1)) yline(1, lwidth(*2.1)) xscale(range(1 24)) name(`y'lev, replace) ylabel(,labsize(*1.3) grid gmax gmin)  grid(gmax gmin glpattern(dot) glcolor(gray) glwidth(*0.3)) title("A)",position(11) size(*1.5)) 



*Different title for DE and NO averaged only "Panel A": uncomment and coment above coefplot
//local c = Country
//coefplot, vertical recast(connected) msize(*1.3) lwidth(*1.2)  mlabel(cond(@pval<.01, "***", cond(@pval<.05, "**", ""))) xlabel(1 "0"  5 "4" 9 "8" 13 "12" 17 "16" 21 "20" 24 "23",labsize(*1.3) grid gmax gmin) mlabsize(large) xtitle("Hour of day",size(*1.45)) ytitle("Average Pass-through",size(*1.45)) mcolor(%75) msymbol(d) mfcolor(white) levels(95) ciopts(recast(. rcap) color(*0.65)) yline(0, lwidth(*2.1)) yline(1, lwidth(*2.1)) xscale(range(1 24)) name(`y'lev, replace) ylabel(,labsize(*1.3) grid gmax gmin)  grid(gmax gmin glpattern(dot) glcolor(gray) glwidth(*0.3)) title(`c', size(*1.5)) 
//graph export `y'_hourly, as(jpg) replace
//}



*Wholesale average per hour of day
cap drop wholesale_daily
cap egen wholesale_daily = mean(wholesale_test),by(hour)

twoway connected wholesale_daily hour,sort clcolor(*0.7 ..) mcolor(*0.6 ..) msymbol(D ..) title("E)", position(11) size(*1.5)) xlabel(0 4 8 12 16 20 23)   xtitle("Hour of day",size(*1.45)) ytitle("Average Wholesale Price (EUR/MWh)",size(*1.45))  name(`y'price,replace) plotregion(fcolor(white*0.1)) xlabel(,labsize(*1.3)) ylabel(,labsize(*1.3)) legend(rows(1))


*Energy Sources Average per Hour of day
twoway connected Coal_tgm Gas_tgm Hydro_tgm others_tgm Nuc_tgm re_tgm hour, xscale(range(1 24)) clcolor(sienna*0.7 midgreen*0.7 orange*0.6 dknavy*0.7 red*0.6  midblue*0.6)   mcolor(sienna*0.6 midgreen*0.6 orange*0.5 dknavy*0.6 red*0.5 midblue*0.5) msymbol(D ..) xlabel(0 4 8 12 16 20 23) sort title("B)",size(*1.5) position(11)) xtitle("Hour of day",size(*1.45)) ytitle("Average Energy Source Share",size(*1.45))  name(`y'source2,replace) plotregion(fcolor(white*0.1)) xlabel(,labsize(*1.3)) ylabel(,labsize(*1.3)) legend(size(*1.24) rows(2)) ysc(titlegap(*30))

*Energy Source of the RE broken down
twoway connected hydror_tgm solar_tgm wind_tgm hour, xscale(range(1 24)) clcolor(sienna*0.7 midblue*0.4 stone*0.9) mcolor(sienna*0.7 midblue*0.4 stone*0.9) msymbol(D ..) xlabel(0 4 8 12 16 20 23) sort title("F)" ,size(*1.5) position(11)) xtitle("Hour of day",size(*1.45)) ytitle("Average Energy Source Share: Intermittent RE",size(*1.45))  name(`y'sourcere,replace)   xlabel(,labsize(*1.3)) ylabel(,labsize(*1.3)) legend(size(*1.26) rows(1))

*Load Average per Hour
cap drop mean_total 
cap drop mean_load_nore
cap drop re_hour
egen mean_total = mean(load),by(hour)
cap egen re_hour= mean(RE_gen*1000),by(hour)
cap label var mean_total "Load"
gen mean_load_nore = mean_total - re_hour
cap label var mean_load_nore "Residual Load"

twoway connected mean_total mean_load_nore hour, xscale(range(1 24)) xlabel(0 4 8 12 16 20 23)  clcolor(maroon*0.7 magenta*0.7) mcolor(maroon*0.6 purple*0.6) msymbol(D ..) sort xtitle("Hour of day",size(*1.45)) ytitle("Average Load (MWh)",size(*1.45)) title("D)",size(*1.5) position(11)) name(`y'load,replace) xlabel(,labsize(*1.3)) ylabel(,labsize(*1.3)) plotregion(fcolor(white*0.1)) legend(size(*1.26) rows(1))

*Average Distribution of IRE and Gas share per hour
graph box re_tg Gas_s, over(hour, label(labsize(*0.93))) title("H)",size(*1.5) position(11)) ytitle("Average Hourly Percent Distribution of Gas and Intermittent RE",size(*1.45)) name(`y'box,replace) plotregion(fcolor(white*0.1)) intensity(55) lintensity(55) ylabel(,labsize(*1.3)) legend(size(*1.26) rows(1)) box(2, color(midgreen*0.7)) box(1,color(eltblue*0.9)) marker(2,mcolor(midgreen*0.7)) marker(1,mcolor(eltblue*0.9))


*Average capacity factors per hour
 twoway connected capf_Coals capf_Gas capf_Hydro capf_Others capf_Nuc capf_RE hour, xscale(range(1 24)) sort xtitle("Hour of day",size(*1.45)) clcolor(sienna*0.7 midgreen*0.7 orange*0.6 dknavy*0.7 red*0.6 midblue*0.6 ) mcolor(sienna*0.6 midgreen*0.6 orange*0.5 dknavy*0.6 red*0.5 midblue*0.5 ) xlabel(0 4 8 12 16 20 23)  msymbol(D ..) ytitle("Average Capacity Factor",size(*1.45)) title("C)", size(*1.5) position(11)) name(`y'cap1,replace) xlabel(,labsize(*1.3)) ylabel(,labsize(*1.3)) plotregion(fcolor(white*0.1)) legend(size(*1.24) rows(2)) ysc(titlegap(*30))
 
*Average capacity factor of gas vs Σall non-gas dispatchable sources
 twoway connected capf_Gas  cf_alls hour, sort ytitle("Average Capacity Factor",size(*1.45)) clcolor(green maroon) xlabel(0 4 8 12 16 20 23)  clcolor(midgreen*0.7 navy*0.85) mcolor(green*0.6 navy*0.6) msymbol(D ..) name(`y'capf,replace) title("G)", size(*1.5) position(11)) plotregion(fcolor(white*0.1)) xlabel(,labsize(*1.3)) ylabel(,labsize(*1.3)) xtitle("Hour of day",size(*1.45)) legend(size(*1.26) rows(1))


**Combine above into one figure--> SI Figure per Country
//country Name
local c = Country
graph combine `y'lev `y'source2 `y'cap1 `y'load `y'price `y'sourcere `y'capf `y'box , name(`y'_hourly,replace) altshrink title(`c') rows(2) 
graph export `y'_hourly, as(jpg) replace
}




**Austria Autocorrelation residual plot (Figure S11)
use AT_new
reg wholesale_test gas_p RE_gen c.load##c.load i.month#i.hour i.dow#i.hour, cl(dt)
predict residual,r
ac residual, lags(72)

**France Autocorrelation residual plot (Figure S20)
use FR_new
reg wholesale_test gas_p RE_gen c.load##c.load i.month#i.hour i.dow#i.hour, cl(dt)
predict residual,r
ac residual, lags(72)
