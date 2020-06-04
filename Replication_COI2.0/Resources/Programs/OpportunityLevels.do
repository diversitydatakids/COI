***Author: Clemens Noelke

cap program drop OpportunityLevels
program define OpportunityLevels
syntax varlist, [LVLSOF(string)] SUFF(string) POPVAR(string) 

	version 14.0

	cap label def cats 1 "Very Low" 2 "Low" 3 "Moderate" 4 "High" 5 "Very High"

	* Cat variables
	
	if "`lvlsof'"!="" {
	
		qui flevelsof `lvlsof', local(lvls) 
		
		foreach vr in `varlist' {

			qui gen c5_`vr'`suff'=.

			di in ye _n "`vr'" _col(8) " " _cont

			foreach lvl in `lvls' {
			
				di in white "." _cont
				
				_pctile `vr' if year==2015 & `lvlsof'=="`lvl'" & `vr'!=. [fw=`popvar'], p(20 40 60 80)
			
				qui replace c5_`vr'`suff'=1 if `vr'<=`r(r1)'                 & `vr'!=. & `lvlsof'=="`lvl'"
				qui replace c5_`vr'`suff'=2 if `vr'>`r(r1)'  & `vr'<=`r(r2)' & `vr'!=. & `lvlsof'=="`lvl'"
				qui replace c5_`vr'`suff'=3 if `vr'>`r(r2)'  & `vr'<=`r(r3)' & `vr'!=. & `lvlsof'=="`lvl'"
				qui replace c5_`vr'`suff'=4 if `vr'>`r(r3)'  & `vr'<=`r(r4)' & `vr'!=. & `lvlsof'=="`lvl'"
				qui replace c5_`vr'`suff'=5 if `vr'>`r(r4)'                  & `vr'!=. & `lvlsof'=="`lvl'"
		
			}
							
			label val c5_`vr'`suff' cats
			
		}
		
		macro drop _lvls

	}
	else {
	
		foreach vr in `varlist' {
		
			di in ye "`vr' " _cont

			qui gen c5_`vr'`suff'=.
			
			_pctile `vr' if year==2015 & `vr'!=. [fw=`popvar'], p(20 40 60 80)
			
			qui replace c5_`vr'`suff'=1 if `vr'<=`r(r1)'                 & `vr'!=.
			qui replace c5_`vr'`suff'=2 if `vr'>`r(r1)'  & `vr'<=`r(r2)' & `vr'!=.
			qui replace c5_`vr'`suff'=3 if `vr'>`r(r2)'  & `vr'<=`r(r3)' & `vr'!=.
			qui replace c5_`vr'`suff'=4 if `vr'>`r(r3)'  & `vr'<=`r(r4)' & `vr'!=.
			qui replace c5_`vr'`suff'=5 if `vr'>`r(r4)'                  & `vr'!=.
			
			label val c5_`vr'`suff' cats
			
		}
		
	}
	
end
