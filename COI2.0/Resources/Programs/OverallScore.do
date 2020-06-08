***Author: Clemens Noelke

cap program drop OverallScore
program define OverallScore
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
	
	* No missing data on any of the domain scores
	
	
	* Weight indicator values
	qui gen wgt_val=wgt*val
			
	
	* Aggregate to overall score
	collapse (mean) wgt_val, by(geoid year)
	rename wgt_val zCOI

	label var zCOI ""

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
