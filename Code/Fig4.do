***Figure 4 generation Panels C,D,E

*Maps A and B were constructed using outside software (https://app.datawrapper.de) but with esitmates from here:
*Map A used the average column (K1 one excel) and the corresponding confidence intervals as the inputs for the average pass-through coefficient
*Map B used estimates from HourlyEstimates.do for the number of hours of pass-through in a day  (https://www.datawrapper.de/_/ptcUf/)
*Panel C is at the bottom, used estimates from HourlyEstimates.do


set scheme white_tableau

**Regressions for each country by hour group (and entire day "average") exported to excel, then improted again into new file (Fig5_Level)

*in Country datasets
 cd ~/Downloads/Nature_Energy_Crisis/Datasets/Country datasets


putexcel set Fig4_Level, replace

putexcel A1 = "Country"
putexcel B1= " am_coef" //coefficient
putexcel C1= " am_h" //upper 95% CI
putexcel D1= " am_l" //lowe 95% CI
putexcel E1= " Pm_coef"
putexcel F1= " pm_h"
putexcel G1= " pm_l"
putexcel H1= " pmm_coef"
putexcel I1= " pmm_h"
putexcel J1= " pmm_l"
putexcel K1= " Average"
putexcel L1= " avg_h"
putexcel M1= " avg_l"

local myrow = 2


foreach x in "AT" "BE" "BG" "CH" "CZ" "DE"  "DK" "EE" "ES" "FI" "FR" "HR" "HU" "IT" "LT" "NL" "NO" "PL" "PT" "ROs" "RS" "SI" "SK"{

	use `x'_new, clear    

	putexcel A`myrow' = "`x'"
	reg wholesale_test gas_p c.load##c.load RE_gen i.month#i.hour i.hour#i.dow if hour_bin==1, cluster(dt)	 //Overnight
	putexcel B`myrow' = matrix(e(b)[1,1]) //coefficient
	mat t1= r(table)
	putexcel C`myrow' = t1[6,1] //upper 95% confidence interval
	putexcel D`myrow' = t1[5,1] //lower 95% confidence interval

	reg wholesale_test gas_p c.load##c.load RE_gen i.month#i.hour i.hour#i.dow if hour_bin==2, cluster(dt)	//Mid-day
	putexcel E`myrow' = matrix(e(b)[1,1])
	mat t2= r(table)

	putexcel F`myrow' = t2[6,1]
	putexcel G`myrow' = t2[5,1]
	reg wholesale_test gas_p c.load##c.load RE_gen i.month#i.hour i.hour#i.dow if hour_bin==3, cluster(dt)	//Evening
	putexcel H`myrow' = matrix(e(b)[1,1])
	mat t3= r(table)
	putexcel I`myrow' = t3[6,1]
	putexcel J`myrow' = t3[5,1]
	reg wholesale_test gas_p c.load##c.load RE_gen i.month#i.hour i.hour#i.dow, cluster(dt) //Entire day "Average"
	putexcel K`myrow' = matrix(e(b)[1,1])
	mat t4=r(table)
	putexcel L`myrow' = t4[6,1]
	putexcel M`myrow' = t4[5,1]

	local myrow = `myrow' + 1

}


**For Greece remove month fixed effects but add time-trend 
foreach x in "GR"{

	use `x'_2021, clear    
	putexcel A`myrow' = "`x'"
	reg wholesale_test gas_p cc.load##c.load RE_gen i.hour#i.dow c.t if hour_bin==1, cluster(dt)	
	putexcel B`myrow' = matrix(e(b)[1,1]) //coefficient
	mat t1= r(table)
	putexcel C`myrow' = t1[6,1] //upper 95% confidence interval
	putexcel D`myrow' = t1[5,1] //lower 95% confidence interval

	reg wholesale_test gas_p c.load##c.load RE_gen i.hour#i.dow c.t if hour_bin==2, cluster(dt)	
	putexcel E`myrow' = matrix(e(b)[1,1])
	mat t2= r(table)

	putexcel F`myrow' = t2[6,1]
	putexcel G`myrow' = t2[5,1]
	reg wholesale_test gas_p c.load##c.load RE_gen i.hour#i.dow c.t if hour_bin==3, cluster(dt)	
	putexcel H`myrow' = matrix(e(b)[1,1])
	mat t3= r(table)
	putexcel I`myrow' = t3[6,1]
	putexcel J`myrow' = t3[5,1]
	reg wholesale_test gas_p c.load##c.load RE_gen i.hour#i.dow c.t, cluster(dt)
	putexcel K`myrow' = matrix(e(b)[1,1])
	mat t4=r(table)
	putexcel L`myrow' = t4[6,1]
	putexcel M`myrow' = t4[5,1]

	local myrow = `myrow' + 1

}


// *** GENERATE FIGURE 4 Panel C D E **saved as Fig4_new (now not used in main text!)

// ***Import the excel sheet into Stata and save as Fig4_level***
// import excel "Fig4_Level.xlsx", sheet("Sheet1") firstrow clear


// *input country variable name manually for labeling
// cap gen country = .
// order country,before(Country)

// **Different colorings of countries based on CIs
// *am: overnight, pm:mid-day, pmm:Evening
// * 0: gray, 1: blue, 2: red, 3: green
// gen exlcude=0
// drop am_sig pm_sig pmm_sig
// gen am_sig = 0 if am_l<0 
// replace am_sig=1 if am_l>0
// gen pm_sig = 0 if pm_l<0
// replace pm_sig=1 if pm_l>0
// gen pmm_sig = 0 if pmm_l<0
// replace pmm_sig=1 if pmm_l>0


// replace am_sig=2 if am_h<1 & am_l<0
// replace pm_sig= 2 if pm_h<1 & pm_l<0
// replace pmm_sig= 2 if pmm_h<1 & pmm_l<0


// replace am_sig= 3 if am_h<1 & am_l>0
// replace pm_sig= 3 if pm_h<1 & pm_l>0
// replace pmm_sig= 3 if pmm_h<1 & pmm_l>0

// **changed back from purple to navy for those with lower CI greater than one
// replace am_sig= 1 if am_l>1 
// replace pm_sig= 1 if pm_l>1 
// replace pmm_sig= 1 if pmm_l>1 

// //Sort Figure by increasing order of Pass-Through of Mid-day
// drop n2
// sort Pm_coef pm_sig
// gen n2=_n
// labmask n2, values(country)


// label var am_coef "Overnight"
// label var Pm_coef "Mid-day"
// label var pmm_coef "Evening"
// label var am_sig "0: gray, 1: blue, 2: red, 3: green"
// label var n2 "ordering"

// *dataset already created in 

// *in Other datsets
// cd ~/Downloads/Nature_Energy_Crisis/Datasets/Other datasets

// *Not actually Fig5!
// use Fig5,clear

// graph twoway (rcap  am_l am_h n2 if exlcude==0&am_sig==1, lwidth(*1.7) msize(*1.5) horizontal lcolor(navy*0.9) xline(1, lwidth(*1.9)) xline(0, lwidth(*1.9))) || (dot am_coef n2 if exlcude==0 & am_sig==1, horizontal xtitle("Pass-through coefficient", size(*1.4)) mcolor(navy%85) msymbol(d)  msize(*2.05) ysc(r(0 1)) ytitle("") title(" C) Overnight (12:00 - 9:00)",position(11) size(*0.95)) barw(1.3) legend(off) ylabel(0(0.1)1) ylabel(1(1)24,valuelabel labsize(medium) angle(horizontal))) || (dot am_coef n2 if exlcude==0 & am_sig==0, horizontal ysc(r(0 1)) msymbol(d)  mcolor(ltblue*0.8) barw(1.3) msize(*2.05) legend(off) ylabel(0(0.1)1) ylabel(1(1)24,valuelabel labsize(medium)  grid gmax gmin glwidth(0.2) angle(horizontal)) name(a3,replace)) || (rcap  am_l am_h n2 if exlcude==0 &am_sig==0, lwidth(*1.7) msize(*1.5) horizontal lcolor(ltblue*0.9) xline(1, lwidth(*1.9)) xline(0, lwidth(*1.9))) || (dot am_coef n2 if exlcude==0 & am_sig==2, horizontal ysc(r(0 1)) msymbol(d)  mcolor(maroon*0.8) barw(1.3) msize(*2.05) legend(off) ylabel(0(0.1)1) ylabel(1(1)24,valuelabel labsize(medium)  grid gmax gmin glwidth(0.2) angle(horizontal))) || (rcap  am_l am_h n2 if exlcude==0 &am_sig==2, lwidth(*1.7) msize(*1.5) horizontal lcolor(maroon*0.9) xline(1, lwidth(*1.9)) xline(0, lwidth(*1.9))) || (dot am_coef n2 if exlcude==0 & am_sig==3, horizontal ysc(r(0 1)) msymbol(d)  mcolor(emerald*0.8) barw(1.3) msize(*2.05) legend(off) ylabel(0(0.1)1) ylabel(1(1)24,valuelabel labsize(medium)  grid gmax gmin glwidth(0.2) angle(horizontal))) || (rcap  am_l am_h n2 if exlcude==0 &am_sig==3, lwidth(*1.7) msize(*1.5) horizontal lcolor(emerald*0.9) xline(1, lwidth(*1.9)) xline(0, lwidth(*1.9))) || (dot am_coef n2 if exlcude==0 & am_sig==4, horizontal ysc(r(0 1)) msymbol(d)  mcolor(purple*0.8) barw(1.3) msize(*2.05) legend(off) ylabel(0(0.1)1) ylabel(1(1)24,valuelabel labsize(medium)  grid gmax gmin glwidth(0.2) angle(horizontal))) || (rcap  am_l am_h n2 if exlcude==0 &am_sig==4, lwidth(*1.7) msize(*1.5) horizontal lcolor(purple*0.9) xline(1, lwidth(*1.9)) xline(0, lwidth(*1.9)))

// graph twoway (rcap  pm_l pm_h n2 if exlcude==0&pm_sig==1, lwidth(*1.7) msize(*1.5) horizontal lcolor(navy*0.9) xline(1, lwidth(*1.9)) xline(0, lwidth(*1.9)))||  (dot Pm_coef n2 if exlcude==0 & pm_sig==1, horizontal xtitle("Pass-through coefficient", size(*1.4)) xlabel(,labsize(*1.3))  mcolor(navy%85) msymbol(d)  msize(*2.05) ysc(r(0 1)) ytitle("") title(" D) Mid-day (10:00 - 16:00)",position(11) size(*0.95)) barw(1.3) legend(off) ylabel(0(0.1)1) ylabel(1(1)24,valuelabel labsize(medium) angle(horizontal))) || (dot Pm_coef n2 if exlcude==0 & pm_sig==0, horizontal ysc(r(0 1)) msymbol(d)  mcolor(ltblue*0.8) barw(1.3) msize(*2.05) legend(off) ylabel(0(0.1)1) ylabel(1(1)24,valuelabel labsize(medium) grid gmax gmin glwidth(0.2) angle(horizontal)) name(b3,replace)) || (rcap  pm_l pm_h n2 if exlcude==0 &pm_sig==0, lwidth(*1.7) msize(*1.5) horizontal lcolor(ltblue*0.9) xline(1, lwidth(*1.9)) xline(0, lwidth(*1.9))) || (dot Pm_coef n2 if exlcude==0 & pm_sig==2, horizontal ysc(r(0 1)) msymbol(d)  mcolor(maroon*0.8) barw(1.3) msize(*2.05) legend(off) ylabel(0(0.1)1) ylabel(1(1)24,valuelabel labsize(medium)  grid gmax gmin glwidth(0.2) angle(horizontal))) || (rcap  pm_l pm_h n2 if exlcude==0 &pm_sig==2, lwidth(*1.7) msize(*1.5) horizontal lcolor(maroon*0.9) xline(1, lwidth(*1.9)) xline(0, lwidth(*1.9))) || (dot Pm_coef n2 if exlcude==0 & pm_sig==3, horizontal ysc(r(0 1)) msymbol(d)  mcolor(emerald*0.8) barw(1.3) msize(*2.05) legend(off) ylabel(0(0.1)1) ylabel(1(1)24,valuelabel labsize(medium)  grid gmax gmin glwidth(0.2) angle(horizontal))) || (rcap  pm_l pm_h n2 if exlcude==0 &pm_sig==3, lwidth(*1.7) msize(*1.5) horizontal lcolor(emerald*0.9) xline(1, lwidth(*1.9)) xline(0, lwidth(*1.9))) || (dot Pm_coef n2 if exlcude==0 & pm_sig==4, horizontal ysc(r(0 1)) msymbol(d)  mcolor(purple*0.8) barw(1.3) msize(*2.05) legend(off) ylabel(0(0.1)1) ylabel(1(1)24,valuelabel labsize(medium)  grid gmax gmin glwidth(0.2) angle(horizontal))) || (rcap  pm_l pm_h n2 if exlcude==0 &pm_sig==4, lwidth(*1.7) msize(*1.5) horizontal lcolor(purple*0.9) xline(1, lwidth(*1.9)) xline(0, lwidth(*1.9)))

// graph twoway  (rcap  pmm_l pmm_h n2 if exlcude==0 &pmm_sig==1, lwidth(*1.7) msize(*1.5) horizontal lcolor(navy*0.9) xline(1, lwidth(*1.9)) xline(0, lwidth(*1.9))) || (dot pmm_coef n2 if exlcude==0 & pmm_sig==1, horizontal xtitle("Pass-Through coefficient", size(*1.4)) xlabel(,labsize(*1.3)) mcolor(navy%85) msymbol(d)  msize(*2.05) ysc(r(0 1)) ytitle("") title(" E) Evening (17:00 - 23:00)",position(11) size(*0.95)) barw(1.3) legend(off) ylabel(0(0.1)1) ylabel(1(1)24,valuelabel labsize(medium) angle(horizontal))) || (dot pmm_coef n2 if exlcude==0 & pmm_sig==0, horizontal ysc(r(0 1)) msymbol(d)  mcolor(ltblue*0.8) barw(1.3) msize(*2.05) legend(off) ylabel(0(0.1)1) ylabel(1(1)24,valuelabel labsize(medium) grid gmax gmin glwidth(0.2) angle(horizontal)) name(c3,replace)) || (rcap  pmm_l pmm_h n2 if exlcude==0 &pmm_sig==0, lwidth(*1.7) msize(*1.5) horizontal lcolor(ltblue*0.9) xline(1, lwidth(*1.9)) xline(0, lwidth(*1.9))) || (dot pmm_coef n2 if exlcude==0 & pmm_sig==2, horizontal ysc(r(0 1)) msymbol(d)  mcolor(maroon*0.8) barw(1.3) msize(*2.05) legend(off) ylabel(0(0.1)1) ylabel(1(1)24,valuelabel labsize(medium)  grid gmax gmin glwidth(0.2) angle(horizontal))) || (rcap  pmm_l pmm_h n2 if exlcude==0 &pmm_sig==2, lwidth(*1.7) msize(*1.5) horizontal lcolor(maroon*0.9) xline(1, lwidth(*1.9)) xline(0, lwidth(*1.9))) || (dot pmm_coef n2 if exlcude==0 & pmm_sig==3, horizontal ysc(r(0 1)) msymbol(d)  mcolor(emerald*0.8) barw(1.3) msize(*2.05) legend(off) ylabel(0(0.1)1) ylabel(1(1)24,valuelabel labsize(medium)  grid gmax gmin glwidth(0.2) angle(horizontal))) || (rcap  pmm_l pmm_h n2 if exlcude==0 &pmm_sig==3, lwidth(*1.7) msize(*1.5) horizontal lcolor(emerald*0.9) xline(1, lwidth(*1.9)) xline(0, lwidth(*1.9))) || (dot pmm_coef n2 if exlcude==0 & pmm_sig==4, horizontal ysc(r(0 1)) msymbol(d)  mcolor(purple*0.8) barw(1.3) msize(*2.05) legend(off) ylabel(0(0.1)1) ylabel(1(1)24,valuelabel labsize(medium)  grid gmax gmin glwidth(0.2) angle(horizontal))) || (rcap  pmm_l pmm_h n2 if exlcude==0 &pmm_sig==4, lwidth(*1.7) msize(*1.5) horizontal lcolor(purple*0.9) xline(1, lwidth(*1.9)) xline(0, lwidth(*1.9)))


**Panel C** (Some manual edits to get to final figure)
*added country names manually
*
use 3dfig

heatplot Rel_Vul Intensity Frequency, scatter bins(24) color(,reverse opacity(85)) stat(asis)   p(lalign(center) lwidth(thin)) size(2+gas_share*2)  recenter   keylabels(1 15) ylabel(, nogrid) xlabel(,nogrid)  title("C)",size(*1.3) position(11))
*note("Marker size according to natural gas share")

*values(format(%9.0f) size(*1.05) color(white))

gr_edit legend.plotregion1.label[1].text = {}
gr_edit legend.plotregion1.label[1].text.Arrpush 92.1
gr_edit legend.plotregion1.label[6].text = {59.6}
*gr_edit legend.plotregion1.label[5].text.Arrpush 60
gr_edit legend.plotregion1.label[10].text = {29.8}
*gr_edit legend.plotregion1.label[10].text.Arrpush 30
gr_edit legend.plotregion1.label[15].text = {}
gr_edit legend.plotregion1.label[15].text.Arrpush 3.3





