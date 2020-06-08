***Author: Clemens Noelke

cap program drop Reverse
program define Reverse
syntax using/

	version 14.0

	* Load list of variables to be reversed
	preserve
		clear
		import delim using "`using'", delim(",") stringcols(_all) varn(1)
		qui levelsof column, clean local(reverselist)
	restore

	* Reverse
	foreach vr in `reverselist' {
		di "  `vr': " _cont
		replace z`vr'=(-1)*z`vr'
	}
	macro drop _reverselist
	

end

	
exit
