***Generation Figure 5***


grstyle clear
grstyle init
grstyle set legend 6


clear
foreach y in "AT" "FR"  "IT"  "PL" "PT"  {

use `y'_new

**collapse these into Other
//cap gen mean_Others = meanS_Biomass+meanS_Oil +meanS_Waste+meanS_Other 

**Left panel hourly pass-through
//reg wholesale_test gas_p RE_gen c.load##c.load c.gas_p#i.hour i.month#i.hour i.dow#i.hour, cluster(dt)
//eststo: margins, dydx(gas_p) at(hour=(0(1)23)) vsquish post noestimcheck 
//coefplot, vertical recast(connected) msize(*1.3) lwidth(*1.2)  mlabel(cond(@pval<.01, "***", cond(@pval<.05, "**", ""))) xlabel(1 "0"  5 "4" 9 "8" 13 "12" 17 "16" 21 "20" 24 "23",labsize(*1.81) grid gmax gmin) mlabsize(large) xtitle("Hour of day",size(*1.81)) ytitle("Average Pass-through",size(*1.81)) title("",size(*0.92) position(11)) mcolor(%75) msymbol(d) mfcolor(white) levels(95) ciopts(recast(. rcap) color(*0.65)) yline(0, lwidth(*2.1)) yline(1, lwidth(*2.1)) xscale(range(1 24)) name(`y'levf4, replace) ylabel(,labsize(*1.81) grid gmax gmin)  grid(gmax gmin glpattern(dot) glcolor(gray) glwidth(*0.3))

*Add PT_load FR_load FR_RE PT_RE  to above regression for robustness check in Spain on including neighbors controls:  PT_load PT_RE FR_RE FR_load


**Right panel hourly share (with a denominator as total generation)
twoway connected coal_tgm gas_tgm hydro_tgm nuc_tgm re_tgm others_tgm hour, xscale(range(1 24)) clcolor(sienna*0.7 midgreen*0.7 orange*0.6 red*0.7 midblue*0.6 dknavy*0.7) mcolor(sienna*0.6 midgreen*0.6 orange*0.5 red*0.6 midblue*0.5 dknavy*0.6) msymbol(D ..) xlabel(0 4 8 12 16 20 23) sort title("",size(*0.95) position(11)) xtitle("Hour of day",size(*1.81)) ytitle("Energy Share",size(*1.81))  name(`y'source2f4,replace) legend(off) xlabel(,labsize(*1.81))  ylabel(,labsize(*1.81)) || line load_tgm hour, yaxis(2) sort lpattern("-") ytitle("Load (MWh)",axis(2) size(*1.81))  ylabel(,labsize(*1.81) axis(2))lwidth(*2.3)

}

**Combine to add titles per country
graph combine ATlevf4 ATsource2f4, altshrink name(ATg,replace) rows(1) title("A)			 				Austria",size(*1.4) position(11))

graph combine FRlevf4 FRsource2f4, altshrink name(FRg,replace) rows(1) title("B)							France",size(*1.4) position(11))

graph combine ITlevf4 ITsource2f4, altshrink name(ITg,replace) rows(1) title("C)							Italy",size(*1.4) position(11))

graph combine PTlevf4 PTsource2f4, altshrink name(PTg,replace) rows(1) title("D)							Portugal",size(*1.4) position(11))

*Poland with the legend
foreach y in  "PL" {

use `y'_new

reg wholesale_test gas_p RE_gen c.load##c.load c.gas_p#i.hour i.month#i.hour i.dow#i.hour, cluster(dt)
eststo: margins, dydx(gas_p) at(hour=(0(1)23)) vsquish post noestimcheck 
// matrix M=r(b)
// cap gen est_g2 = .
// forvalues i = 0/23 {
//     local j = `i' + 1
//     replace est_g2 = M[1, `j'] if hour == `i'
// }

coefplot, vertical recast(connected) msize(*1.3) lwidth(*1.2)  mlabel(cond(@pval<.01, "***", cond(@pval<.05, "**", ""))) xlabel(1 "0"  5 "4" 9 "8" 13 "12" 17 "16" 21 "20" 24 "23",labsize(*1.8) grid gmax gmin) mlabsize(vlarge) xtitle("Hour of day",size(*1.8)) ytitle("Average Pass-through",size(*1.8)) title("",size(*0.92) position(11)) mcolor(%75) msymbol(d) mfcolor(white) levels(95) ciopts(recast(. rcap) color(*0.65)) yline(0, lwidth(*2.1)) yline(1, lwidth(*2.1)) xscale(range(1 24)) name(`y'levf4, replace) ylabel(,labsize(*1.8) grid gmax gmin)  grid(gmax gmin glpattern(dot) glcolor(gray) glwidth(*0.3)) graphregion(margin(b+10))

*Hydro correlations tests
// pwcorr Hydro_dispatch_share Gas_share
// pwcorr Hydro_dispatch_share RE_share
// pwcorr est_g2 Hydro_tgm




**Right panel hourly share (with a denominator as total generation)
twoway connected coal_tgm gas_tgm hydro_tgm nuc_tgm re_tgm others_tgm hour, xscale(range(1 24)) clcolor(sienna*0.7 midgreen*0.7 orange*0.6 red*0.7 midblue*0.6 dknavy*0.7) mcolor(sienna*0.6 midgreen*0.6 orange*0.5 red*0.6 midblue*0.5 dknavy*0.6) msymbol(D ..) xlabel(0 4 8 12 16 20 23) sort title("",size(*0.95) position(11)) xtitle("Hour of day",size(*1.82)) ytitle("Energy Share",size(*1.82))  name(`y'source2f4,replace) legend(row(2) size(*1.4)) xlabel(,labsize(*1.82))  ylabel(,labsize(*2.8)) graphregion(margin(b+30))

}

//graph combine PLlevf4 PLsource2f4, altshrink name(PLg,replace) title("E) Poland",size(*1.4)) 

**manually edit place of legend in graph editor
grc1leg PLlevf4 PLsource2f4, altshrink legendfrom(PLsource2f4) name(PLg,replace) title("D)							Poland",size(*1.4) position(11)) rows(1) position(6) iscale(1)




**Responsivness/slope plot for 5 countries --> Figure 5 last panel 
*Panel F generation

foreach y in "AT" "BE" "BG" "CH" "CZ" "DE" "DK" "EE" "ES" "FI" "FR" "GR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "RO" "RS" "SI" "SK" {
//foreach y in "AT" "FR" "IT" "PL" "PT" {

use `y'_new
reg wholesale_test gas_p RE_gen c.load##c.load i.month#i.hour i.dow#i.hour, cluster(dt)
margins,at(gas_p=(40(10)260)) saving(`y'f,replace)
//marginsplot, recast(connected) noci name(margins1`y',replace) xtitle("Natural gas price (EUR/MWh)") ytitle("Predicted wholesale electricity price (EUR/MWh)") title(`y')

}

grstyle clear
grstyle init
grstyle set legend 12,inside



// combomarginsplot ATf FRf ITf PTf PLf, labels("Austria" "France" "Italy" "Portugal" "Poland") noci xtitle("Natural Gas Price Cap (EUR/MWh)",size(*1.25)) ytitle("Maximum Wholesale Electricity Price (EUR/MWh)",size(*1.2))  title("F)",position(11) size(*1.5)) ylabel(,format(%2.0f) labsize(*1.2)) xlabel(,labsize(*1.1)) legend(rows(1) size(*1.3)) xlabel(#12, labsize(*1.1)) name(pricecap,replace)

combomarginsplot ATf FRf ITf PTf PLf, labels("Austria" "France" "Italy" "Portugal" "Poland") noci xtitle("Natural Gas Price Cap (EUR/MWh)",size(*1.3)) ytitle("Maximum Wholesale Electricity Price (EUR/MWh)",size(*1.24))  title("F)",position(11) size(*1.25)) ylabel(,format(%2.0f) labsize(*1.2)) xlabel(,labsize(*1.1)) legend(off)  lplot1(color(gs2*0.9)) xlabel(#12, labsize(*1.1)) name(pricecap,replace) text(380 268 "Italy" 350 274 "Portugal" 244 271 "France" 180 271 "Austria" 140 271 "Poland") graphregion(margin(r+10))



//Figure 6: 5 Country Panels of Hourly Profiles and panel F, slightly edit manually the positioning of panels and legends

graph combine ATg FRg ITg PTg PLg pricecap, altshrink name(fig32,replace)  rows(3)
