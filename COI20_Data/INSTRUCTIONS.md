## Child Opportunity Index 2.0 Replication Materials

[diversitydatakids.org](http://diversitydatakids.org/ "diversitydatakids.org"). June 8, 2020. 

For comments and questions, please email <info@diversitydatakids> or fill in the "Contact us" form [here](http://diversitydatakids.org/contact-us, "diversitydatakids.org/contact-us")

Please review the [COI 2.0 Technical Document](http://diversitydatakids.org/research-library/research-brief/how-we-built-it "diversitydatakids.org/research-library/research-brief/how-we-built-it") for a description of COI 2.0 methodology and data sources.

***

**Instructions**  

`COI20_Data` contains COI 2.0 replication materials. 

You need Stata version 14 or higher to run the scripts (do-files). Download the complete contents of the COI20_Data folder, preserving the directory structure. You can do this by clicking "Clone or download" and then "Download ZIP", which will download a zipped version of the COI20_Data folder. 

To replicate published z-scores, Child Opportunity Scores and Child Opportunity Levels, download the complete contents of the COI20_Data folder while preserving the directory structure. You can do this by clicking "Clone or download" and then "Download ZIP", which will download a zipped version of the COI20_Data folder. 

To replicate the published zscores.csv and index.csv files, first, run zscores.do and then run index.do.

The zscores.do file converts raw indicator values (COI20_Data/indicators_raw.csv) to z-scores, calculates the economic resource index using the weights obtained from principal components analysis (stored in COI20_Data/Resources/weights_pca.csv). It then calculates domain average z-scores (using COI20_Data/Resources/weights_indicators.csv) and the overall average z-scores (using COI20_Data/Resources/weights_domain_scores.csv). It exports a Stata file (COI20_Data/Data/index.dta) containing domain z-scores and a CSV file containing indicator z-scores (COI20_Data/Data/zscores.csv), identical to the one published at [data.diversitydatakids.org](http://data.diversitydatakids.org/dataset/coi20-child-opportunity-index-2-0-database).

The index.do file calculates COI 2.0 Child Opportunity Scores and Levels (metro, state, and nationally normed versions), taking Data/index.dta as input and exporting a CSV file with these metrics (COI20_Data/Data/index.csv) identical to the one published at [data.diversitydatakids.org](http://data.diversitydatakids.org/dataset/coi20-child-opportunity-index-2-0-database). 

The Resources folder contains two auxiliary files, one with a list of indicators that are reversed (COI20_Data/Resources/reverse_columns.csv) and a list of variable names and labels for the indicators_raw.csv file (COI20_Data/Resources/column_labels.csv). It also includes Stata programs that  are utilized by the zscores and index do-files.