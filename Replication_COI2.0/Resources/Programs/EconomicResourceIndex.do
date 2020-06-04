***Author: Clemens Noelke

cap program drop EconomicResourceIndex
program define EconomicResourceIndex
syntax using/, NAME(string)

	version 14.0
	
	preserve

		noi di _n "  Import scoring coefficients from sheet `name'"
		clear
		
		qui import delim "`using'", delim(",") stringcol(1) varn(1)
		forval vl = 1/`=_N' {
			local nme = varname[`vl']
			local `nme' = coeff[`vl']
			local vrlist = trim("`vrlist' `nme'")
			macro drop _nme
		}
	
		list
	
	restore
	
	di "Running pca to show that scores are identical to those imported"
	pca `vrlist' [fw=dec_pop] if year==2010, components(1)
	
	* Create weight variable containing the scoring coefficient values,
	* set to missing if indicator is missing
	foreach vr in `vrlist' {
		qui gen `vr'_w1 = ``vr''
		macro drop _`vr'
		qui replace `vr'_w1=. if `vr'==.
	}

	foreach vr in `vrlist' {
		local wlist1 = trim("`wlist1' `vr'_w1")
		local wlist2 = trim("`wlist2' `vr'_w2")
	}
	
	* Create 2nd weight variable that is a rescaled weight variable
	* such that the rescaled weights sum to the total of the first 
	* weight variable 
		
	qui egen wtot=rowtotal(`wlist1')
	macro drop _wlist1
	qui sum wtot
	local maxwt = `r(max)'

	foreach vr in `vrlist' {
		qui gen `vr'_w2=`vr'_w1*`maxwt'/wtot
	}
	macro drop _maxwt

	*** wtot2 does not vary, wtot does because of missings
	qui egen wtot2=rowtotal(`wlist2')
	macro drop _wlist2
	drop *_w1 wtot wtot2

	*** Make index
	
	qui gen double `name'=.
	
	foreach vr in `vrlist' {
		
		local iter = `iter'+1
		
		if `iter'== 1 qui replace `name' = `vr'_w2*`vr'            if `vr'!=.
		else          qui replace `name' = `name' + (`vr'_w2*`vr') if `vr'!=.
		drop `vr'_w2
	}
	macro drop _iter

	*** Recode to missing if 3 or more are missing
	noi di in green _n "  Recode to missing if 3 or more indicators are missing: " _cont
	qui egen ind=rowmiss(`vrlist')
	replace `name'=. if ind>=3
	drop ind
	
	*** Restandardize 
	qui sum `name' [fw=dec_pop] if year==2010
	qui replace `name'=(`name'-`r(mean)')/`r(sd)'
	qui sum `name' [fw=dec_pop] if year==2010
	
end


	
exit
