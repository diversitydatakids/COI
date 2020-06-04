***Author: Clemens Noelke

cap program drop Missings
program define Missings
syntax, MTHRESH(integer)

version 14.0

	noi di _n "  Dropping 100% water tracts: " _cont
	drop if percent_water==100
	drop percent_water 

	foreach domain in ED HE SE {
	    
		di "  `domain': " _cont
		
		unab vrs : `domain'_*
		
		* percmiss = percent variables missing in a given domain
		qui egen percmiss=rowmiss(`vrs')
		qui replace percmiss=100*percmiss/`: word count `vrs''
		macro drop _vrs
	
		* Dropping tracts if more than `mthresh'% missing in any of the domains
		drop if percmiss>`mthresh'
		drop percmiss
		
	}
	
end
	
exit
