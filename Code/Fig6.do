***Generation Figure 6***


grstyle clear
grstyle init
grstyle set legend 6


clear
foreach y in "AT" "FR"  "IT"  "PL" "PT" {

use `y'_new

**collapse these into Other
//cap gen mean_Others = meanS_Biomass+meanS_Oil +meanS_Waste+meanS_Other 

**Left panel hourly pass-through
reg wholesale_test gas_p RE_gen c.load##c.load c.gas_p#i.hour i.month#i.hour i.dow#i.hour, cluster(dt)
eststo: margins, dydx(gas_p) at(hour=(0(1)23)) vsquish post noestimcheck 
coefplot, vertical recast(connected) msize(*1.3) lwidth(*1.2)  mlabel(cond(@pval<.01, "***", cond(@pval<.05, "**", ""))) xlabel(1 "0"  5 "4" 9 "8" 13 "12" 17 "16" 21 "20" 24 "23",labsize(*1.81) grid gmax gmin) mlabsize(large) xtitle("Hour of day",size(*1.81)) ytitle("Average Pass-through",size(*1.81)) title("",size(*0.92) position(11)) mcolor(%75) msymbol(d) mfcolor(white) levels(95) ciopts(recast(. rcap) color(*0.65)) yline(0, lwidth(*2.1)) yline(1, lwidth(*2.1)) xscale(range(1 24)) name(`y'levf4, replace) ylabel(,labsize(*1.81) grid gmax gmin)  grid(gmax gmin glpattern(dot) glcolor(gray) glwidth(*0.3))

**Right panel hourly share (with a denominator as total generation)
twoway connected coal_tgm gas_tgm hydro_tgm nuc_tgm re_tgm others_tgm hour, xscale(range(1 24)) clcolor(sienna*0.7 midgreen*0.7 orange*0.6 red*0.7 midblue*0.6 dknavy*0.7) mcolor(sienna*0.6 midgreen*0.6 orange*0.5 red*0.6 midblue*0.5 dknavy*0.6) msymbol(D ..) xlabel(0 4 8 12 16 20 23) sort title("",size(*0.95) position(11)) xtitle("Hour of day",size(*1.81)) ytitle("Energy Share",size(*1.81))  name(`y'source2f4,replace) legend(row(3) size(*0.1)) legend(off) xlabel(,labsize(*1.81))  ylabel(,labsize(*1.81))

}

**Combine to add titles per country
graph combine ATlevf4 ATsource2f4, altshrink name(ATg,replace) rows(1) title("A) Austria",size(*1.4))

graph combine FRlevf4 FRsource2f4, altshrink name(FRg,replace) rows(1) title("B) France",size(*1.4))

graph combine ITlevf4 ITsource2f4, altshrink name(ITg,replace) rows(1) title("C) Italy",size(*1.4))

graph combine PTlevf4 PTsource2f4, altshrink name(PTg,replace) rows(1) title("D) Portugal",size(*1.4))

//graph combine PLlevf4 PLsource2f4, altshrink name(PLg,replace) title("E) Poland",size(*1.4)) 

**manually edit place of legend in graph editor
grc1leg PLlevf3 PLsource2f4, altshrink legendfrom(PLsource2f4) name(PLg,replace) title("E) Poland",size(*1.4)) rows(1) position(3) ring(0) iscale(1)


//Figure 6: 5 Country Panels of Hourly Profiles

graph combine ATg FRg ITg PTg PLg, name(fig32,replace) altshrink rows(3)
