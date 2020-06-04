***Author: Clemens Noelke

#d ;
clear all; version 14.0; set more off; set seed 1003; run "Resources/Startup"; 
#d cr

********************************************************************************

* List of indicators and labels
import delim using "Resources/column_labels.csv", varn(1) delim(",") case(preserve) stringcol(1)
list
clear

********************************************************************************

* Import raw indicator values
import delim using "Data/indicators_raw.csv", varn(1) delim(",") case(preserve) stringcol(1 4/5)

********************************************************************************

* Delete tracts fully covered by water 
* Delete tracts with more than 50% (mthresh) missing in any of the three domains
Missings, mthresh(50)

********************************************************************************

* Bottom-code values below the 1st and top-code values above the 99th percentile
foreach vr of varlist ED_* HE_* SE_* {
	di "`vr' " _cont
	foreach year in 2010 2015 {
		_pctile `vr' if year==`year' [fw=dec_pop], p(1 99)
		qui replace `vr'=`r(r1)' if `vr'<`r(r1)' & `vr'!=. & year==`year'
		qui replace `vr'=`r(r2)' if `vr'>`r(r2)' & `vr'!=. & year==`year'
	}
}

********************************************************************************

* Make z-scores
foreach vr of varlist ED_* HE_* SE_* {
	qui sum `vr' [fw=dec_pop] if year==2010
	qui gen z`vr'=(`vr'-`r(mean)')/`r(sd)' if `vr'!=.
}

********************************************************************************

* Reverse subset of indicator z-scores
Reverse using "Resources/reverse_columns.csv"

********************************************************************************

* Make Economic Resource Index
EconomicResourceIndex using "Resources/weights_pca.csv", name("zSE_ECRES") 

********************************************************************************

* Make domain average z-scores
DomainScores using "Resources/weights_indicators.csv"

********************************************************************************

* Make domain overall z-score
OverallScore using "Resources/weights_domain_scores.csv"

********************************************************************************

drop dec_pop ED_* HE_* SE_*
rename acs_pop pop

* Export indicator zscores
preserve
	keep geoid year z*_*
	sort geoid year
	export delim "Data/zscores.csv", delim(",") replace
restore

* Export Stata file with domain and overall z-scores
keep geoid year pop statefips msaid15 in100 zED-zCOI
sort geoid year
save "Data/index", replace


