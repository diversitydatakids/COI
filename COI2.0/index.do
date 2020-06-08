***Author: Clemens Noelke

#d ;
clear all; version 14.0; set more off; set seed 1003; run "Resources/Startup"; 
#d cr
 
* Import domain and overall z-scores
use "Data/index"


*** Nationally normed metrics

* National levels
OpportunityLevels zED zHE zSE zCOI, popvar(pop) suff("_nat")
foreach vr in zED zHE zSE zCOI { 
	tab c5_`vr'_nat year [fw=pop], m col nofreq
}

* National scores
OpportunityScores zED zHE zSE zCOI, popvar(pop) suff("_nat")
foreach vr in zED zHE zSE zCOI { 
	tab r_`vr'_nat year [fw=pop], m col nofreq
}


*** State normed metrics

* State levels
OpportunityLevels zED zHE zSE zCOI, lvlsof("statefips") popvar(pop) suff("_stt")
foreach vr in zED zHE zSE zCOI { 
	tab c5_`vr'_stt year [fw=pop], m col nofreq
}

* State scores
OpportunityScores zED zHE zSE zCOI, lvlsof("statefips") popvar(pop) suff("_stt")
foreach vr in zED zHE zSE zCOI { 
	tab r_`vr'_stt year [fw=pop], m col nofreq
}


*** Metro normed metrics
preserve 

	keep if in100==1
	keep geoid year msaid15 pop zED-zCOI

	* Metro area levels
	OpportunityLevels zED zHE zSE zCOI, lvlsof("msaid15") popvar(pop) suff("_met") 
	foreach vr in zED zHE zSE zCOI { 
		tab c5_`vr'_met year [fw=pop], m col nofreq
	}

	* Metro area scores
	OpportunityScores zED zHE zSE zCOI, lvlsof("msaid15") popvar(pop) suff("_met") 
	foreach vr in zED zHE zSE zCOI { 
		tab r_`vr'_met year [fw=pop], m col nofreq
	}
	keep geoid year *_met

	sort geoid year
	tempfile tmp
	save `tmp'
	
restore

sort geoid year
merge 1:1 geoid year using `tmp'
macro drop _tmp
count if _merge==2
if `r(N)'!=0 exit 1
drop _merge

*** Export index.csv file with domain/overall z-scores and metrics

rename c5_z* c5_*
rename  r_z*  r_*
foreach vr of varlist zED-zCOI {
	rename `vr' `vr'_nat
}
rename z* z_*
drop in100-pop

isid geoid year
sort geoid year
export delim "Data/index.csv", delim(",") replace

