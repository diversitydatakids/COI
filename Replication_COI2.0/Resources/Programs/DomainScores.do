***Author: Clemens Noelke

cap program drop DomainScores
program define DomainScores
syntax using/

	version 14.0

	* Save data file currently in memory
	tempfile dta
	qui save `dta'
	
		
	* Import indicator weights, store in locals
	preserve
		clear
		qui import delim "`using'", delim(",") varn(1) stringcol(_all) case(preserve)
		forval i = 1/`=_N' {
			local nme = vrname[`i']
			local `nme' = wgt[`i']
			local vrs = trim("`vrs' `nme'")
			macro drop _nme
		}
	restore

	
	* Reshape to long, geoid-year-indicator rows (will later collapse to geoid-year rows)
	* Add weight variable, drop weight local
	foreach vr in `vrs' {
					
		preserve
		
			keep geoid year `vr'
			
			rename `vr' val
			qui gen wgt=``vr''
			macro drop _`vr'
			qui gen vrname="`vr'"
			
			sort geoid year
			tempfile `vr'
			qui save ``vr''
			
		restore
		
	}

	clear
	foreach vr in `vrs' {
		qui append using ``vr''
		macro drop _`vr'
	}
	macro drop _vrs

	
	* Make domain variable
	qui split vrname, parse("_") gen(_ind)
	rename _ind1 domain
	qui replace domain=substr(domain,2,.) // Trim off leading z
	drop _ind2

	
	* Some rows within geoid-year have missings data
	* Weights still should add up to number of indicators foreach geoid-year-domain
	qui count if val==.
	di "  " 100*`r(N)'/`=_N' " percent missing after initial exclusions."

	
	* Delete missings, now weights no longer sum to one within geoid-year-domain rows
	di "  Drop remaining missings: " _cont
	drop if val==.

	
	* Rescale weight variable so that it sums up to one within observations with the same geoid-year-domain values
	bysort geoid year domain: egen twgt=total(wgt)
	qui gen nwgt=wgt/twgt

	
	* Weight indicator values
	qui gen wgt_val=nwgt*val
			
	
	* Aggregate to domain scores
	collapse (mean) wgt_val, by(geoid year domain)
	rename wgt_val z

	
	* Make wide again
	qui reshape wide z, i(geoid year) j(domain) string

	label var zED ""
	label var zHE ""
	label var zSE ""

	sort geoid year
	tempfile tmp
	qui save `tmp'

	
	*** Merge domain scores onto indicator dataset

	clear
	use `dta'
	sort geoid year
	qui merge 1:1 geoid year using `tmp'
	macro drop _tmp _dta
	drop _merge	

end

	
exit
