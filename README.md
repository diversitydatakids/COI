# Child Opportunity Index 2.0 Replication Materials.

## diversitydatakids.org. June 2020. 

You need Stata version 14 or higher to run the scripts (do-files) made available here. Please review the COI 2.0 Technical Documentation at http://diversitydatakids.org/research-library/research-brief/how-we-built-it for a description of the methodology and data sources.

To replicate the published zscores.csv and index.csv files, first, run zscores.do and then run index.do.

The zscores.do file converts raw indicator values (Data/indicators_raw.csv) to z-scores, calculates the economic resource index using the weights obtained from principal components 
analysis (stored in Resources/weights_pca.csv). It then calculates domain average z-scores (using Resources/weights_indicators.csv) and the overall average z-scores 
(using Resources/weights_domain_scores.csv). It exports a Stata file (Data/index.dta) containing domain z-scores and a CSV file containing indicator z-scores (Data/zscores.csv), identical to the one published at http://data.diversitydatakids.org/dataset/coi20-child-opportunity-index-2-0-database.
The index.do file calculates COI 2.0 Child Opportunity Scores and Levels (metro, state, and nationally normed versions), taking Data/index.dta as input and exporting a CSV file with these metrics (Data/index.csv) identical to the one published at http://data.diversitydatakids.org/dataset/coi20-child-opportunity-index-2-0-database. The Resources folder contains two auxiliary files, one with a list of indicators that are reversed (Resources/reverse_columns.csv) and a list of variable names and labels for the indicators_raw.csv file (Resources/column_labels.csv). It also includes Stata programs that 
are utilized by the zscores and index do-files.