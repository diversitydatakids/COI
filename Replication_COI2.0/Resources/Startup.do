** Load Programs

#d ;

local Programs "
	EconomicResourceIndex
	DomainScores
	OverallScore
	Missings
	Reverse
	OpportunityLevels
	OpportunityScores
	";
	

#d cr
	
foreach prg in `Programs' {

	noi run "Resources/Programs/`prg'.do"
	
}

macro dir