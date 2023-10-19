
*Control for neighboring loads and/or IRE for 5 countries: AT,PT,FR,IT,PL, SI country-specific Figures

*AT: de_load ch_load it_load si_load sk_load hu_load cz_load ||  de_load ch_load it_load si_load sk_load hu_load cz_load de_ire ch_ire it_ire si_ire sk_ire hu_ire cz_ire 

*FR: be_load de_load ch_load es_load it_load || be_load de_load ch_load es_load it_load be_ire de_ire ch_ire es_ire it_ire

*IT: gr_load hr_load si_load at_load ch_load fr_load || gr_load hr_load si_load at_load ch_load fr_load gr_ire hr_ire si_ire at_ire ch_ire fr_ire

*PT: es_load || es_load es_ire

*PL: de_load cz_load sk_load lt_load || de_load cz_load sk_load lt_load de_ire cz_ire sk_ire lt_ire

*ES: Add PT_load FR_load || Add PT_load FR_load FR_RE PT_RE


*Change the regression specification to include appropriate neighboring countries *_load or *_ire
reg wholesale_test gas_p RE_gen c.load##c.load c.gas_p#i.hour i.month#i.hour i.dow#i.hour, cluster(dt)
eststo: margins, dydx(gas_p) at(hour=(0(1)23)) vsquish post noestimcheck 
coefplot, vertical recast(connected) msize(*1.3) lwidth(*1.2)  mlabel(cond(@pval<.01, "***", cond(@pval<.05, "**", ""))) xlabel(1 "0"  5 "4" 9 "8" 13 "12" 17 "16" 21 "20" 24 "23",labsize(*1.81) grid gmax gmin) mlabsize(large) xtitle("Hour of day",size(*1.81)) ytitle("Average Pass-through",size(*2.07)) title("A) No Neighbor Controls", size(*1.2) position(11))  mcolor(%75) msymbol(d) mfcolor(white) levels(95) ciopts(recast(. rcap) color(*0.65)) yline(0, lwidth(*2.1)) yline(1, lwidth(*2.1)) xscale(range(1 24)) name(PLstandard, replace) ylabel(,labsize(*1.81) grid gmax gmin)  grid(gmax gmin glpattern(dot) glcolor(gray) glwidth(*0.3))


reg wholesale_test gas_p RE_gen c.load##c.load c.gas_p#i.hour i.month#i.hour i.dow#i.hour de_load cz_load sk_load lt_load, cluster(dt)
eststo: margins, dydx(gas_p) at(hour=(0(1)23)) vsquish post noestimcheck 
coefplot, vertical recast(connected) msize(*1.3) lwidth(*1.2)  mlabel(cond(@pval<.01, "***", cond(@pval<.05, "**", ""))) xlabel(1 "0"  5 "4" 9 "8" 13 "12" 17 "16" 21 "20" 24 "23",labsize(*1.81) grid gmax gmin) mlabsize(large) xtitle("Hour of day",size(*1.81)) title("B) Load Neighbor Controls",size(*1.2) position(11)) mcolor(%75) msymbol(d) mfcolor(white) levels(95) ciopts(recast(. rcap) color(*0.65)) yline(0, lwidth(*2.1)) yline(1, lwidth(*2.1)) xscale(range(1 24)) name(PLloads, replace) ylabel(,labsize(*1.81) grid gmax gmin)  grid(gmax gmin glpattern(dot) glcolor(gray) glwidth(*0.3))


reg wholesale_test gas_p RE_gen c.load##c.load c.gas_p#i.hour i.month#i.hour i.dow#i.hour de_load cz_load sk_load lt_load de_ire cz_ire sk_ire lt_ire, cluster(dt)
eststo: margins, dydx(gas_p) at(hour=(0(1)23)) vsquish post noestimcheck 
coefplot, vertical recast(connected) msize(*1.3) lwidth(*1.2)  mlabel(cond(@pval<.01, "***", cond(@pval<.05, "**", ""))) xlabel(1 "0"  5 "4" 9 "8" 13 "12" 17 "16" 21 "20" 24 "23",labsize(*1.81) grid gmax gmin) mlabsize(large) xtitle("Hour of day",size(*1.81)) title("C) Load and IRE Neighbor Controls",size(*1.2) position(11)) mcolor(%75) msymbol(d) mfcolor(white) levels(95) ciopts(recast(. rcap) color(*0.65)) yline(0, lwidth(*2.1)) yline(1, lwidth(*2.1)) xscale(range(1 24)) name(PLloadsire, replace) ylabel(,labsize(*1.81) grid gmax gmin)  grid(gmax gmin glpattern(dot) glcolor(gray) glwidth(*0.3))


*graph combine ATstandard ATloads ATloadsire, altshrink name(AT_neighbors,replace) rows(1) title("Austria",size(*1.1))

*graph combine FRstandard FRloads FRloadsire, altshrink name(FR_neighbors,replace) rows(1) title("France",size(*1.1))

*graph combine ITstandard ITloads ITloadsire, altshrink name(IT_neighbors,replace) rows(1) title("Italy",size(*1.1))

*graph combine PTstandard PTloads PTloadsire, altshrink name(PT_neighbors,replace) rows(1) title("Portugal",size(*1.1))

graph combine PLstandard PLloads PLloadsire, altshrink name(PL_neighbors,replace) rows(1) title("Poland",size(*1.1))

