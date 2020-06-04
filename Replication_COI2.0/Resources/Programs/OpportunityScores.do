***Author: Clemens Noelke

cap program drop OpportunityScores
program define OpportunityScores
syntax varlist, [LVLSOF(string) LBLSTUB(string) SUFF(string)] POPVAR(string)

	version 13.1

	if "`lvlsof'"!="" {

		qui flevelsof `lvlsof', local(lvls) 
		
		foreach vr in `varlist' {

			qui gen r_`vr'`suff'=.

			di in ye _n "`vr'" _col(8) " " _cont

			foreach lvl in `lvls' {
			
				di in white "." _cont
				
				* Calculate percentiles by period
				_pctile `vr' if `vr'!=. & year==2015 & `lvlsof'=="`lvl'" [fw=`popvar'], p(1/99)
				forval r = 1/99 {
					local p`r' = `r(r`r')'
				}
				
				* Code scores 1 = less than first, 2 = more than first and less than second, 
				* 99 = more than 98th and less than 99th, 100 = more than 99th
				forval p = 1/100 {
				
						 if `p'==1 	 	    qui replace r_`vr'`suff'=`p' if `vr'<=`p1'              & `lvlsof'=="`lvl'" & `vr'!=.
					else if `p'>1 & `p'<100 {
											local low = `p'-1
											local low = `p`low''
											local hi  = `p`p''
											qui replace r_`vr'`suff'=`p' if `vr'>`low' & `vr'<=`hi' & `lvlsof'=="`lvl'" & `vr'!=.
					}
					else if `p'==100        qui replace r_`vr'`suff'=`p' if `vr'>`p99'              & `lvlsof'=="`lvl'" & `vr'!=.
					else exit 1
					
					macro drop _low _hi
				}

				* Drop percentiles
				forval p = 1/99 {
					macro drop _p`p'
				}
				
				
			}
			
		}
		
		macro drop _lvls
		
	}
	else {

		foreach vr in `varlist' {

			di in ye "`vr' " _cont
			
			qui gen r_`vr'`suff'=.
		
			* Calculate percentiles by period
			_pctile `vr' if `vr'!=. & year==2015 [fw=`popvar'], p(1/99)
			forval r = 1/99 {
				local p`r' = `r(r`r')'
			}
			
			* Code scores 1 = less than first, 2 = more than first and less than second, 
			* 99 = more than 98th and less than 99th, 100 = more than 99th
			forval p = 1/100 {
			
					 if `p'==1 	 	    qui replace r_`vr'`suff'=`p' if `vr'<=`p1'              & `vr'!=.
				else if `p'>1 & `p'<100 {
										local low = `p'-1
										local low = `p`low''
										local hi  = `p`p''
										qui replace r_`vr'`suff'=`p' if `vr'>`low' & `vr'<=`hi' & `vr'!=.
				}
				else if `p'==100        qui replace r_`vr'`suff'=`p' if `vr'>`p99'              & `vr'!=.
				else exit 1
				
				macro drop _low _hi
			}

			* Drop percentiles
			forval p = 1/99 {
				macro drop _p`p'
			}
			
		}
	}
	
end


