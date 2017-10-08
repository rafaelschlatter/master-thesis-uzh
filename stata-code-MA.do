****************
*****Remarks****
****************

*BvDID is the unique firm identifier
*Year is the time variable

set more off


	
////////////////////////////////////////////
/////								   /////
/////   PART 1:    DATA PREPARATIONS   /////
/////								   /////
////////////////////////////////////////////

********************************************
*****DATA IMPORT AND DATA MANIPULATIONS*****
********************************************

*Import data from excel
*This dataset includes all firms which are owned by a Swiss parent firm
*with at least 10% ownership (Dataset contains 10'070 firms, with 9 years
*Dataset has 10'070*9=90'630 observations)
import excel "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/ORBIS all year (10-100%).xlsx", sheet("Blatt1") firstrow

*Convert string variables into numeric
destring TotalassetsCHF2015 FixedassetsCHF2015 TangiblefixedassetsCHF2015 ///
	IntangiblesCHF2015 IntangiblefixedassetsCHF2015 OtherIntangiblesCHF2015 ///
	SalesCHF2015 CostsofemployeesCHF2015 OperatingPLEBITCHF2015 ///
	PLbeforetaxCHF2015 IncomeTaxesCHF2015 ResearchDevelopmentexpenses ///
	NetPropertyPlantEquipment Numberofemployees2015 ///
	TotalLiabilitiesandDebtCHF2 TotalShareholdersEquityCHF20, replace force
destring NACERev2Corecode4digits, replace
encode BvDIDnumber, generate(BvDID)
encode CountryISOCode, generate(CountryISO)
encode Conscode, generate (CONSCode)
drop CountryISOCode Conscode
	
*Rearrange data and put bulky companyname to the end
order BvDID BvDIDnumber Year CountryISO CONSCode Country
order NACERev2mainsection Companyname Informationprovider ///
	Standardisedlegalform Dateofincorporation Reportingbasis, last
sort BvDIDnumber Year
drop A

*Rename variables to more convenient names, relabel variables
rename TotalassetsCHF2015 TA
rename FixedassetsCHF2015 FA
rename TangiblefixedassetsCHF2015 TFA
rename IntangiblesCHF2015 I
rename IntangiblefixedassetsCHF2015 IFA
rename OtherIntangiblesCHF2015 OI
rename SalesCHF2015 SALES
rename CostsofemployeesCHF2015 CEmployees
rename OperatingPLEBITCHF2015 EBIT
rename PLbeforetaxCHF2015 PTI
rename IncomeTaxesCHF2015 INC_TAXES
rename ResearchDevelopmentexpenses R_D
rename NetPropertyPlantEquipment PPE
rename Numberofemployees2015 NEmployees
rename TotalLiabilitiesandDebtCHF2 DEBT
rename TotalShareholdersEquityCHF20 EQUITY
rename Numberofpatents PATENTS
rename Numberoftrademarks TRADEMARKS
rename NACERev2Corecode4digits NACE_Core_Code

*create log variables
gen LTA=log(TA)
gen LFA=log(FA)
gen LTFA=log(TFA)
gen LI=log(I)
gen LIFA=log(IFA)
gen LOI=log(OI)
gen LSALES=log(SALES)
gen LCEmployees=log(CEmployees)
gen LEBIT=log(EBIT)
gen LPTI=log(PTI)
gen LINC_TAXES=log(INC_TAXES)
gen LR_D=log(R_D)
gen LPPE=log(PPE)
gen LNEmployees=log(NEmployees)
gen LDEBT=log(DEBT)
gen LEQUITY=log(EQUITY)
gen LPATENTS=log(PATENTS)
gen LTRADEMARKS=log(TRADEMARKS)
	
*Numbering the rows
decode BvDID, generate(BvDID_temp)
gen ObsID_temp=BvDID_temp+string(Year)
egen ObsID=group(ObsID_temp)
drop BvDID_temp ObsID_temp
order ObsID
		
*Save this dataset
save "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data.dta"
clear



****************************************
*****PRODUCE/MERGING OWNERSHIP DATA*****
****************************************

*Import dataset with BvDIDs of subsidiaries owned by 51%-99% ownership
*and do similar steps as before (Dataset contains 1'465 firms)
import excel "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/ORBIS (51-99%).xls", sheet("Blatt1") firstrow
encode BvDIDnumber, generate(BvDID)
drop Companyname A
order BvDID BvDIDnumber
sort BvDIDnumber
save "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data_51-99.dta"
clear

*Combine the two datasets
*The BvDIDs that match are companies with between 51% and 99% ownership
use "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data.dta"
sort BvDIDnumber
merge m:1 BvDIDnumber using "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data_51-99.dta"
*Merge control: 13'185 observations are matched, 9 years * 1'465 firms
*=13'185 observations matched
tab _merge

*Drop temporary data
drop CountryISOCode

*Create ownership dummy variable OW_51_99
*OW_51_99 = 1 if between 51%-99% owned by Swiss parent firm
*OW_51_99 = 0 otherwise
gen OW_51_99=0
replace OW_51_99=1 if _merge ==3
label variable OW_51_99 "OW_51_99 = 1 if sub is owned between 51-99%"
tab OW_51_99
drop _merge

*save dataset
save "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data_OW1.dta"
clear

*repeat step with dataset with BvDID of 100% owned subsidiaries
*Import dataset with BvDIDs of subsidiaries owned by 100% ownership
*and do similar steps as before (Dataset contains 6'598 firms)
import excel "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/ORBIS (100%).xls", sheet("Blatt1") firstrow
encode BvDIDnumber, generate(BvDID)
drop Companyname A
order BvDID BvDIDnumber
sort BvDIDnumber
save "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data_100.dta"
clear

*Combine the two datasets
*The BvDIDs that match are companies with 100% ownership
use "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data_OW1.dta"
sort BvDIDnumber
merge m:1 BvDIDnumber using "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data_100.dta"
*Merge control: 59'382 observations are matched, 9 years * 6'598 firms
*= 59'382 observations matched
tab _merge

*Drop temporary data
drop CountryISOCode

*Create ownership dummy variable OW_100
*OW_100 = 1 if between 100% owned by Swiss parent firm
*OW_100 = 0 otherwise
gen OW_100=0
replace OW_100=1 if _merge ==3
label variable OW_100 "OW_100 = 1 if sub is owned 100%"
tab OW_100
drop _merge

*prepare for merging with tax data
decode CountryISO, generate(CountryISO_S)
order CountryISO_S Year
sort CountryISO_S Year

*save dataset
save "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data_OW2.dta"
clear



*******************************************************
*****CREATING TAX DATA AND MERGING WITH OTHER DATA*****
*******************************************************

*Tax data is downloaded from Damodarans Website, which uses KPMG as a source,
*Data was last updated in January 2017 according to Damodaran website
*http://people.stern.nyu.edu/adamodar/New_Home_Page/datafile/countrytaxrate.htm
*(Source: KPMG Corporate tax rate tables)
import excel "/Users/rafaelschlatter/Desktop/MA Data/TAX Data/Tax Rates KPMG.xlsx", sheet("Blatt1") firstrow

*Rename variables
rename B Year2006
rename C Year2007
rename D Year2008
rename E Year2009
rename F Year2010
rename G Year2011
rename H Year2012
rename I Year2013
rename J Year2014
rename K Year2015
rename L Year2016

*Reshaping into panel-structure, renaming variables
reshape long Year, i(Country)
rename Year TaxRate
rename _j Year

*Drop unnecessary data
drop if Year ==2006
drop if Year ==2016

*generate matching variable (CountryISO_S) to match tax data with ORBIS data.
*Matching is done using the CountryISO_S and Year variable
*CountryISO_S is the two-digit ISO country code stored as a string in the ORBIS
*data set. The tax dataset only contains country names, but not ISO codes.
*Racibowski (2008) Stata package is used to translate country names into ISO
*codes.

*reference: Raciborski (2008), p. 391-392
*install necessary packages
ssc install kountry
help kountry

*translate country names into ISO numeric codes using "stuck" option for 
*unstandardized names. The resulting ISO numeric codes can be converted into 
*ISO2 codes. see Racibowksi (2008), p. 396, or help kountry in Stata.
*marker adds a categorical variable to manually check the conversion success.
kountry Country, from(other) stuck marker
tab MARKER

*Most of the cases where conversion failed, were not countries but things like:
*"EU average", "Americas average" etc. This is left untreated as this data is
*not needed. The only case where the package failed is Hong Kong (SAR). The
*country is renamed and the task is performed again.
drop _ISO3N_ MARKER
replace Country="Hong Kong" if Country=="Hong Kong SAR"
kountry Country, from(other) stuck marker
rename _ISO3N_ CountryISO3N
drop MARKER
kountry CountryISO3N, from(iso3n) to(iso2c) marker

*Taiwan now shows as unconverted, however a ISO2 code is displayed, Curacao does
*not have an ISO2 code, but the country is not present in the ORBIS dataset, so
*everything is fine.

*cleaning data
drop if MARKER==0
drop CountryISO3N NAMES_STD MARKER
rename _ISO2C_ CountryISO_S
order CountryISO_S Year
sort CountryISO_S Year

save "/Users/rafaelschlatter/Desktop/MA Data/TAX Data/MA_Data_TAX.dta"
clear

*Merge datasets
use "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data_OW2.dta"
sort CountryISO_S Year
merge m:m CountryISO_S Year using "/Users/rafaelschlatter/Desktop/MA Data/TAX Data/MA_Data_TAX.dta"
tab _merge
*_merge==1 are countries where no Taxrate is available from KPMG. This is Taiwan
*and Ivory Coast.
*_merge==2 are countries where no ORBIS data is available.
*Both unmerged cases are dropped.
drop if _merge==1
drop if _merge==2
drop _merge

*Country has 74 unique values, but CountryISO has 72 unique values
*this is because "Reunion" is treated as France, and "Canary Islands" as Spain
codebook Country
codebook CountryISO

*bring more usefol structure
order BvDIDnumber BvDID Year CountryISO_S CountryISO
sort BvDIDnumber Year

*generate Swiss tax rate variable (Source: KPMG tax rates table)
gen CHTaxRate =0.1792 if Year == 2015
replace CHTaxRate =0.1792 if Year == 2014
replace CHTaxRate =0.1801 if Year == 2013
replace CHTaxRate =0.1806 if Year == 2012
replace CHTaxRate =0.1831 if Year == 2011
replace CHTaxRate =0.1875 if Year == 2010
replace CHTaxRate =0.1896 if Year == 2009
replace CHTaxRate =0.1920 if Year == 2008
replace CHTaxRate =0.2063 if Year == 2007

*generate tax differential and dummy variable for case identification
gen TaxDiff = TaxRate - CHTaxRate

gen Case2 = 1 if TaxDiff > 0
replace Case2 = 0 if TaxDiff < 0

order BvDIDnumber BvDID Year CountryISO_S CountryISO Country ObsID TaxRate ///
	CHTaxRate TaxDiff Case2

save "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data_OW2_Tax.dta"



***********************************
******GENERATING INDUSTRY DATA*****
***********************************

*NACE Rev. 2 Codes are used to as an industry classification.
*Source of the data is ORBIS, the classification can be found here:
*http://ec.europa.eu/eurostat/documents/3859598/5902521/KS-RA-07-015-EN.PDF

use "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data_OW2_Tax.dta"
*generating a Section Variable for the Main Sector:
gen NACE_Main = substr(NACERev2mainsection, 1, 1)
*generate an industry classification that can be used in regression
*encode string to labelled numeric
encode NACE_Main, generate(NACE_MainN)
order BvDIDnumber BvDID Year CountryISO_S CountryISO ObsID TaxRate ///
	CHTaxRate TaxDiff Case2 NACE_Main NACE_MainN
tab NACE_Main
* 396 observations are missing a sector infromation.
save "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data_OW2_Tax_Ind.dta"
clear



**************************
*****MERGING GDP DATA*****
**************************

*Import GDP Data. Data is from World Bank Databank world development indicators
import excel "/Users/rafaelschlatter/Desktop/MA Data/GDP Data/GDP Data MA.xls", sheet("Data") firstrow
*Convert strings into numerics, replacing ".." by missing values
destring YR2007 YR2008 YR2009 YR2010 YR2011 YR2012 YR2013 YR2014 ///
	YR2015, replace force

*drop empty rows
drop in 658/662

*Bring data in better format, code is from Princton website
*see Princton website: http://www.princeton.edu/~otorres/Stata/Reshape
gen ID = _n
reshape long YR, i(ID) j(Year)
encode SeriesName, gen(varlabel)
tab varlabel
egen ID2 = group(CountryCode Year)
order ID ID2 Year
gen CountryCode2= CountryCode+CountryName
drop ID SeriesName SeriesCode CountryName
order ID2 CountryCode2 Year
sort ID2 CountryCode2 Year varlabel
reshape wide YR, i(ID2) j(varlabel)

*rename the variables
rename YR1 GDP_constant_LCU
rename YR2 GDP_current_LCU
rename YR3 GDP_current_USD
rename YR4 GDP_growth
rename YR5 GDP_per_capita_constant_LCU
rename YR6 GDP_per_capita_current_LCU
rename YR7 GDP_per_capita_current_USD
rename YR8 GDP_per_capita_growth
rename YR9 GDP_PPP

order ID2 CountryCode CountryCode2 Year

*World Bank provides country codes in ISO3 codes, again Raciborski's Stata
*package is used to convert the ISO3 codes into ISO2 codes to match with the 
*ORBIS data.
kountry CountryCode, from(iso3c) to(iso2c) marker
tab MARKER
*all codes are converted.

*clean data
drop NAMES_STD MARKER
rename _ISO2C_ CountryISO_S
drop ID2 CountryCode CountryCode2
order CountryISO_S Year
sort CountryISO_S Year

*save dataset
save "/Users/rafaelschlatter/Desktop/MA Data/GDP Data/MA_Data_GDP.dta"
clear

*Merge datasets
use "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data_OW2_Tax_Ind.dta"
sort CountryISO_S Year
merge m:m CountryISO_S Year using "/Users/rafaelschlatter/Desktop/MA Data/GDP Data/MA_Data_GDP.dta"
tab _merge
*GDP data from the Ivory coast could not be matched, as this country is not
*represented in the ORBIS dataset. All observations from the ORBIS dataset
*are matched.
drop if _merge==2
drop _merge

*Generate log variables where necessary
gen LGDP_constant_LCU = log(GDP_constant_LCU)
gen LGDP_current_LCU = log(GDP_current_LCU)
gen LGDP_current_USD = log(GDP_current_USD)
gen LGDP_per_capita_constant_LCU = log(GDP_per_capita_constant_LCU)
gen LGDP_per_capita_current_LCU = log(GDP_per_capita_current_LCU)
gen LGDP_per_capita_current_USD = log(GDP_per_capita_current_USD)
gen LGDP_PPP = log(GDP_PPP)

save "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data_OW2_Tax_Ind_GDP.dta"
clear



**************************************
*****MERGING DEBT AND EQUITY DATA*****
**************************************

*I forgot to download this data from ORBIS in the first instance.

import excel "/Users/rafaelschlatter/Desktop/MA Data/Debt:Equity Data/Cos_Debt.xls", sheet("Blatt1") firstrow
destring ED2015 ED2014 ED2013 ED2012 ED2011 ED2010 ED2009 ED2008 ED2007 ///
	E2015 E2014 E2013 E2012 E2011 E2010 E2009 E2008 E2007, replace force
drop A
*Bring data into proper format
reshape long E ED, i(BvDIDnumber) j(Year)
sort BvDIDnumber Year
save "/Users/rafaelschlatter/Desktop/MA Data/Debt:Equity Data/MA_Data_Debt.dta"
clear

use "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data_OW2_Tax_Ind_GDP.dta"
sort BvDIDnumber Year
merge m:m BvDIDnumber Year using "/Users/rafaelschlatter/Desktop/MA Data/Debt:Equity Data/MA_Data_Debt.dta"
tab _merge
*98.5% of the observations are matched.
*drop observations with BvDIDnumbers that only appear in the MA_Data_Debt file
drop if _merge==2
*819 observations are deleted

*Clean data
drop CountryISOCode
drop _merge
label variable ED "Total Shareholder funds and liabilities"
label variable E "Total shareholder funds"

*generating log variables and debt ratio variables
gen LED=log(ED)
gen LE=log(E)

gen D=ED-E
gen LD=log(D)

gen DED=D/ED
gen LDED=log(DED)



************************************
*****FURTHER DATA MANIPULATIONS*****
************************************

*a geographic region variable is also added for later use, when summary
*statistics are based on specific regions. Again the kountry package by
*Raciborksi (2008) is used. The UN geoscheme is used (Code takes long to run).
kountry CountryISO_S, from(iso2c) geo(un) marker
tab MARKER
*1 firm from the United Arab Emirates is not assigned a geographic region. This
*is done manually. It is assigned to Asia.
replace GEO="Asia" if CountryISO_S=="AE"
drop NAMES_STD MARKER
rename GEO UN_Broad

kountry CountryISO_S, from(iso2c) geo(undet) marker
tab MARKER
*The same firm is not assigned again. It is now assigned to Western Asia.
replace GEO="Western Asia" if CountryISO_S=="AE"
drop NAMES_STD MARKER
rename GEO UN_Detailed
tab UN_Broad
*Montenegro was forgotten somehow...
replace UN_Broad="Europe" if CountryISO_S=="ME"
replace UN_Detailed="Southern Europe" if CountryISO_S=="ME"
tab UN_Broad

*Delete Swiss observations
drop if CountryISO_S=="CH"

save "/Users/rafaelschlatter/Desktop/MA Data/ORBIS Data/MA_Data_OW2_Tax_Ind_GDP_Debt.dta", replace



//////////////////////////////////////////////
/////								     /////
/////   PART 2:    REGRESSION ANALYSIS   /////
/////								     /////
//////////////////////////////////////////////

***************************** WARNING *************************************
*The "margins" command might take long to evaluate depending on the       *
*complexity of the regression model. I suggest not to run the whole       *
*do-file at once, but do it step by step.                                 *
***************************************************************************



*********************************
*****BASIC MODEL REGRESSIONS*****
*********************************

xtset BvDID Year 
*(1) Basic Regression with year dummies
******************************************
quietly xtreg LEBIT i.Year LFA LCEmployees LGDP_per_capita_current_LCU ///
	TaxDiff if NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store FE_1
*Hausman specification test (not possible with clustered SE)
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff if NACE_Main=="C"|NACE_Main=="G", fe
est store FIXED
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff if NACE_Main=="C"|NACE_Main=="G", re
est store RANDOM
hausman FIXED RANDOM
drop _est_FIXED _est_RANDOM

*(2) Baseline Regression with year dummies and industry-year dummies (BENCHMARK)
********************************************************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff if NACE_Main=="C"|NACE_Main=="G", ///
	fe vce(cluster BvDID)
est store FE_2
*This is the PREFERRED regression, so the sample is marked to calculate 
*summary statistics and other data visualization (only done for one sample).
count if e(sample)
su `x' if e(sample)
*Create a variable indicating whether the observeation was used (=1) in
*the regression or not (=0)
gen Used=e(sample)
codebook Used
codebook BvDID

*(3) Additional control variables (Leverage + GDP growth)
*********************************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees LDED ///
	LGDP_per_capita_current_LCU GDP_growth TaxDiff  if ///
	NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store FE_3

*(4) TaxDiff as a quadratic term (Hines & Rice 1994, Dowd et al. 2017)
**********************************************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff c.TaxDiff#c.TaxDiff if ///
	NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store FE_4
*calculate meaningful marginal effects and standard errors
*(Brambor et al. 2005)
summarize TaxDiff if Used==1, detail
*marginal effects are equal to partial derivatives, and standard errors are
	*calculated according to Aiken & West (1991),
	*found here: http://mattgolder.com/interactions
	*margins command might take long to run
estat vce
margins, dydx(TaxDiff) at(TaxDiff=(-0.25(0.05)0.4))
*graphics are done in R, however, also shown here for a quick analysis.
	*This is FIGURE 6 in the thesis
marginsplot, yline(0) recast(line) recastci(rarea) level(90)
*Conclusion: even marginal effects are significant for some ranges of
	*TaxDiff, it is not economically significant. For simplicity reasons, the
	*quadratic term is omitted in the following models (to simplify
	*interpretations of the following interactions (Berry et al. 2012, p. 9).
*marginal effects for Table 9 in thesis:
margins, dydx(TaxDiff) at(TaxDiff=0.031)
margins, dydx(TaxDiff) at(TaxDiff=0.082)
margins, dydx(TaxDiff) at(TaxDiff=0.133)
		
*generate TABLE 6 (font size or size of result window might have to be
	*adjusted in order for the table to be displayed in proper format)
	*N_g ist the number of firms, g_avg is the average number of observations 
	*per group, r2_a is the within r-squared and F is the overall F-statistic

esttab FE_1 FE_2 FE_3 FE_4, b(%9.3f) t(%9.3f) scalars(N_g g_avg r2_a F) ///
	drop ( ****.Year **.NACE_MainN) ///
	star(* 0.1 ** 0.05 *** 0.01 ) staraux star ///
	mtitle("Basic" "Benchmark" "Add. Control" "Quad. Spec.")
drop _est_FE_1 _est_FE_2 _est_FE_3 _est_FE_4
	

	
************************************
*****EXTENDED MODEL REGRESSIONS*****
************************************

*1. SINGLE INTERACTIONS AT A TIME
/////////////////////////////////

xtset BvDID Year
*(1) Capital interaction (continuous spec)
******************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff c.TaxDiff#c.LFA if ///
	NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store FEI_1
*Marginal effects (margins commands take long to run)
	*similar comments as with the quadratic regression apply
summarize LFA if Used==1, detail
estat vce
margins, dydx(TaxDiff) at(LFA=(1(1)25))
*This is PART 1 of FIGURE 7
marginsplot, yline(0) recast(line) recastci(rarea) level(90)
*Conclusion: Firms with large amounts of capital shift more income. This
	*result might suggest that there are fixcosts involved with income shifting.
*Marginal effects for table 9 in thesis
margins, dydx(TaxDiff) at(LFA=12.031)
margins, dydx(TaxDiff) at(LFA=13.942)
margins, dydx(TaxDiff) at(LFA=15.812)

*(2) Capital interaction (dummy spec)
*************************************
*create capital dummy
egen LFA_m=mean(LFA)
gen LFA_d=LFA-LFA_m
replace LFA_d = 0 if LFA_d <0
replace LFA_d = 1 if LFA_d >0
replace LFA_d = . if missing(LFA)
drop LFA_m
*Note that LFA_d (Dummy) is used instead of LFA (cont.).
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff i.LFA_d c.TaxDiff#i.LFA_d  ///
	if NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store FEI_2
*Marginal effects (not plotted)
margins, dydx(TaxDiff) at(LFA_d=(0(1)1))
*Conclusion: Firms with above mean log fixed assets shift income, firms
	*with assets below do not shift income. Supports the fix costs idea.

*(3) Intangibles interaction (continuous spec)
**********************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff LIFA c.TaxDiff#c.LIFA  if ///
	NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store FEI_3
*Marking the sample used when intangibles are used (for various calculations)
count if e(sample)
su `x' if e(sample)
*Create a variable indicating whether the observeation was used (=1) in
*the regression or not (=0)
gen Used_int=e(sample)
*Marginal effects (estat vce is needed to calculate data to plot the
	*marginal effects in R
summarize LIFA if Used==1, detail
estat vce
margins, dydx(TaxDiff) at(LIFA=(-5(1)24))
*This is PART 2 of FIGURE 7
marginsplot, yline(0) recast(line) recastci(rarea) level(90)
*Conclusion: Only firms with high intangibles endowment shift income.
	*(LIFA above 17)
*Marginal effects for table 9 in thesis:
margins, dydx(TaxDiff) at(LIFA=8.853)
margins, dydx(TaxDiff) at(LIFA=10.921)
margins, dydx(TaxDiff) at(LIFA=12.915)

*(4) INTANGIBLES INTERACTION (dummy spec)
*****************************************
*create intangibles dummy
egen LIFA_m=mean(LIFA)
gen LIFA_d=LIFA-LIFA_m
replace LIFA_d = 0 if LIFA_d<0
replace LIFA_d = 1 if LIFA_d>0
replace LIFA_d = . if missing(LIFA)
drop LIFA_m
*Note that LIFA_d (Dummy) is used instead of LIFA (cont.).
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff i.LIFA_d c.TaxDiff#i.LIFA_d  ///
	if NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store FEI_4
*Marginal effects (not plotted)
margins, dydx(TaxDiff) at(LIFA_d=(0(1)1))
*Conclusion: Only firms with above mean ln intangible assets shift income
	*significantly.
*90% confidence intervals for discussion in appendix D.2
di -.6393081-1.645*.5857945
di -.6393081+1.645*.5857945
di -1.124253-1.645*.5257229
di -1.124253+1.645*.5257229

*(5) OWNERSHIP INTERACTION (one dummy)
**************************************
*Note that the Ownership variables cannot be included by itself as they do not
	*change over time and are therefore eliminated when doing the fixed effects
	*transformation.
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff c.TaxDiff#OW_100  if ///
	NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store FEI_5
*Marginal effect of TaxDiff at OW_100=0 (not wholly-owned)
	*and OW_100=1 (wohlly-owned) (not plotted)
margins, dydx(TaxDiff) at (OW_100=(0(1)1))
*Conclusion: Only wholly-owned firms shift income.

*(6) OWNERSHIP INTERACTION (two dummies)
****************************************
*Suspicion: OW_100 is only significant because the sample also includes firms
	*with below majority ownership (which have less possibility to shift income
	*as argued by other authors). 
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff c.TaxDiff#OW_51_99 c.TaxDiff#OW_100 ///
	if NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store FEI_6
*Marginal effect of TaxDiff (must be done manually to rule out impossible
	*combos) (for table 9 in thesis)
margins, dydx(TaxDiff) at(OW_51_99=0 OW_100=0)
margins, dydx(TaxDiff) at(OW_51_99=1 OW_100=0)
margins, dydx(TaxDiff) at(OW_51_99=0 OW_100=1)
*Conclusion: Only wholly-owned firms shift income (same as above, almost
	*equal coefficient estimates and marginal effects for wholly-owned firms).
	*Suspicion from above is nullified. As the difference between firms with
	*less then 51% and firms with between 51 and 99% is statistically and
	*substantively irrelevant, this distinction is no longer made when
	*analysing marginal effects in the following.
	
*Discussion of (5) and (6) ownership interaction (not reported in thesis)
*************************************************************************
gen MAJOR = 1 if OW_100==1
replace MAJOR = 1 if OW_51_99==1
xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff c.TaxDiff#OW_100 if NACE_Main=="C" ///
	& MAJOR==1|NACE_Main=="G" & MAJOR==1, fe vce(cluster BvDID)
*Marginal effects:	
margins, dydx(TaxDiff) at (OW_100=(0(1)1))

*(7) SHIFTING DIRECTION INTERACTION
***********************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff c.TaxDiff#i.Case2 i.Case2  if ///
	NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store FEI_7
*Marginal effect of TaxDiff when shifting direction is to subsidiary (Case1)
	*and to parent (Case2) (for table 9 in thesis)
margins, dydx(TaxDiff) at(Case2=(0(1)1))
*Conclusion: Only shifting into Switzerland is significant.

*generate TABLE 7 (font size or size of result window might have to be
	*adjusted in order for the table to be displayed in proper format)
	*N_g ist the number of firms, g_avg is the average number of observations
	*per group, r2_a is the within r-squared and F is the overall F-statistic
esttab FEI_1 FEI_2 FEI_3 FEI_4 FEI_5 FEI_6 FEI_7, b(%9.3f) t(%9.3f) ///
	scalars(N_g g_avg r2_a F) drop ( ****.Year **.NACE_MainN 0.LFA_d ///
	0.LFA_d#c.TaxDiff 0.LIFA_d 0.LIFA_d#c.TaxDiff 0.OW_100#c.TaxDiff ///
	0.OW_51_99#c.TaxDiff 0.Case2 0.Case2#c.TaxDiff) ///
	star(* 0.1 ** 0.05 *** 0.01 ) staraux star ////
	mtitle("Capital c" "Capital i" "Int c" "Int i" "OW 1i" "OW 2i" "Dir")
drop _est_FEI_1 _est_FEI_2 _est_FEI_3 _est_FEI_4 _est_FEI_5 _est_FEI_6 ///
	_est_FEI_7



*Discussion of (7) Shifting Interaction
***************************************
*Results here do not reflect the theory and are therefore analyzed in greater
	*detail.
*(1) Direction Interaction with NACE_Main =="C"
***********************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU c.TaxDiff##i.Case2 if ///
	NACE_Main=="C", fe vce(cluster BvDID)
est store SD_1
*Marginal effect of TaxDiff when shifting direction is to subsidiary (Case1)
	*and to parent (Case2) (not estimable, but with workaround)
margins, dydx(TaxDiff) at(Case2=(0(1)1))
xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU c.TaxDiff#i.Case2 i.Case2 if ///
	NACE_Main=="C", fe vce(cluster BvDID)
*Conclusion: only shifting to Switzerland is significant.

*Sample split (results not shown, but discussed verbally)
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff if NACE_Main=="C" & Case2==0, ///
	fe vce(cluster BvDID)
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff if NACE_Main=="C" & Case2==1, ///
	fe vce(cluster BvDID)

*(2) Direction Interaction with NACE_Main =="G"
***********************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU c.TaxDiff##i.Case2 if ///
	NACE_Main=="G", fe vce(cluster BvDID)
est store SD_2
*Marginal effect of TaxDiff when shifting direction is to subsidiary (Case1)
	*and to parent (Case2) (not estimable, but with workaround)
margins, dydx(TaxDiff) at(Case2=(0(1)1))
xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU c.TaxDiff#i.Case2 i.Case if ///
	NACE_Main=="G", fe vce(cluster BvDID)
*Conclusion: Only shifting out of Switzerland is significant.

*Sample split (results not shown, but discussed verbally)
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff if NACE_Main=="G" & Case2==0, ///
	fe vce(cluster BvDID)
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff if NACE_Main=="G" & Case2==1, ///
	fe vce(cluster BvDID)
	
*generate TABLE 20 (font size or size of result window might have to be
	*adjusted in order for the table to be displayed in proper format)
	*N_g ist the number of firms, g_avg is the average number of observations
	*per group, r2_a is the within r-squared and F is the overall F-statistic
esttab SD_1 SD_2, b(%9.3f) t(%9.3f) ///
	scalars(N_g g_avg r2_a F) drop ( ****.Year **.NACE_MainN ///
	0.Case2#c.TaxDiff 0.Case2) star(* 0.1 ** 0.05 *** 0.01 ) staraux star ///
	mtitle("Manufacturing" "Wholesale")
drop _est_SD_1 _est_SD_2
	
	

*2. COMBINING INTERACTIONS TERMS 
////////////////////////////////

xtset BvDID Year
*(1) Including all interaction terms (continuous spec) (Preferred regression)
*****************************************************************************
xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff c.TaxDiff#c.LFA LIFA c.TaxDiff#c.LIFA ///
	c.TaxDiff#i.OW_51_99 c.TaxDiff#i.OW_100 i.Case2 c.TaxDiff#i.Case2 if ///
	NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store FEIC_1
*Marginal effects, (vce is for FIGURE 8 in R), the marginal effects are 
	*plotted separately to make drawing in R easier (due to highly complex 
	*standard error formulas, they are just copied without using formula in R),
	*2 cases are distinguished. FIGURE 8 plots the interactions of capital
	*and intangibles in a combined 3D plot.
estat vce
summarize LFA if Used==1, detail
summarize LIFA if Used==1, detail
corr LFA LIFA if Used==1
*1.	LFA whole range, LIFA=11 (roughly mean, it has been shown to be of 
	*little importance in plot 8), OW_100=1, OW_51=0, Case2=1, part 1 of
	*FIGURE 9, databasis for 3D FIGURE 8
	margins, dydx(TaxDiff) at(LFA=(1(1)25) LIFA=11 OW_100=1 OW_51=0 Case2=1)
	marginsplot, yline(0) recast(line) recastci(rarea)
	*Conclusion: Firms with above mean LFA shift income (roughly), given
	*the other conditions.
*2. LFA wholle range, LIFA=11, OW_51=1, OW_100=0, Case2=1, PART 2 of FIGURE 9
	margins, dydx(TaxDiff) at(LFA=(1(1)25) LIFA=11 OW_100=0 OW_51=1 Case2=1)
	marginsplot, yline(0) recast(line) recastci(rarea)
	*Conclusion: No income shifting unless LFA > 23, given the other
	*conditions.
*3. LFA wholle range, LIFA=11, OW_51=OW_100=0, Case2=1, PART 3 of FIGURE 9
	margins, dydx(TaxDiff) at(LFA=(1(1)25) LIFA=11 OW_100=0 OW_51=0 Case2=1)
	marginsplot, yline(0) recast(line) recastci(rarea)
	*Conclusion: Firms with fairly large LFA (above 17) shift income, given
	*the other conditions.
*4. LFA wholle range, LIFA=11, OW_100=1 OW_51=0, Case2=0, PART 4 of FIGURE 9
	margins, dydx(TaxDiff) at(LFA=(1(1)25) LIFA=11 OW_100=1 OW_51=0 Case2=0)
	marginsplot, yline(0) recast(line) recastci(rarea)
	*Conclusion: No sig. income shifting unless LFA is really high (above
	*22).
*5. LFA wholle range, LIFA=11, OW_100=0 OW_51=1, Case2=0, PART 5 of FIGURE 9
	margins, dydx(TaxDiff) at(LFA=(1(1)25) LIFA=11 OW_100=0 OW_51=1 Case2=0)
	marginsplot, yline(0) recast(line) recastci(rarea)
	*Conclusion: No sig. income shifting
*6. LFA wholle range, LIFA=11, OW_100=OW_51=0, Case2=0, PART 6 of FIGURE 9
	margins, dydx(TaxDiff) at(LFA=(1(1)25) LIFA=11 OW_100=0 OW_51=0 Case2=0)
	marginsplot, yline(0) recast(line) recastci(rarea)
	*Conclusion: No sig. income shifting.
*Marginal effect at sample means:
margins, dydx(TaxDiff) at(LFA=13.942 LIFA=10.921 OW_100=1 OW_51=0 Case2=1)
		
*(2) Including only significant interactions (cont. spec)
*********************************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff c.TaxDiff#c.LFA c.TaxDiff#i.OW_51_99 ///
	c.TaxDiff#i.OW_100 if NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store FEIC_2
*Marginal effects:
*1.	<51% Ownership (not plotted in thesis)
	margins, dydx(TaxDiff) at(LFA=(1(1)25) OW_51_99=0 OW_100=0)
	marginsplot, level(90)
	*Conclusion: No significant income shifting unless high LFA (above 20).
	*Qualitatively the same result as in Regression (1) above.
*2. Between 51 and 99% ownership (not plotted in Thesis)
	margins, dydx(TaxDiff) at(LFA=(1(1)25) OW_51_99=1 OW_100=0)
	marginsplot, level(90)
	*Conclusion: No significant income shifting unless high LFA (above 20).
	*Qualitatively the same result as in Regression (1) above.
*3. Wholly-owned subsidiaries (not plotted in Thesis)
	margins, dydx(TaxDiff) at(LFA=(1(1)25) OW_51_99=0 OW_100=1)
	marginsplot, level(90)
	*Conclusion: Significant income shifting found if LFA is bigger than 12 
	*(roughly). OVERALL conclusion: The results between Regressions (1) and
	*(2) do not change substansively when only capital and ownership
	*interaction are included.
*marginal effects for table 9 in thesis:
	margins, dydx(TaxDiff) at(LFA=13.942 OW_51_99=0 OW_100=1)
	margins, dydx(TaxDiff) at(LFA=13.942 OW_51_99=1 OW_100=0)
	margins, dydx(TaxDiff) at(LFA=13.942 OW_51_99=0 OW_100=0)

*(3) Including all interaction terms (dummy spec)
*************************************************
*Continous variables of LFA and LIFA are replaced by dummy variables.
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff i.LFA_d c.TaxDiff#i.LFA_d i.LIFA_d ///
	c.TaxDiff#i.LIFA_d c.TaxDiff#i.OW_51_99 c.TaxDiff#i.OW_100 i.Case2 ///
	c.TaxDiff#i.Case2 if NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store FEIC_3
	*Marginal effects (the advantage of this model is that the commands are
	*much faster executed by stata and the results can be easily visualized in 
	*a 2d plot. The command could be done in one step, however, invalid cases 
	*(such as OW_51_99 and OW_100 both equal to 1 or both equal do 0 have to
	*be eliminated)
*1. <51% Ownership, PART 1 of FIGURE 10
	margins, dydx(TaxDiff) at(LFA_d=(0(1)1) LIFA_d=(0(1)1) Case2=(0(1)1) ///
	OW_51_99=(0) OW_100=(0))
	marginsplot, level(90)
	tab LFA_d if Used_int==1 & OW_51_99==0 & OW_100==0
	*Conclusion: no significant income shifting in any possible case
*2. Between 51 and 99% Ownership, PART 2 of FIGURE 10
	margins, dydx(TaxDiff) at(LFA_d=(0(1)1) LIFA_d=(0(1)1) Case2=(0(1)1) ///
	OW_51_99=(1) OW_100=(0))
	marginsplot, level(90)
	tab LFA_d if Used_int==1 & OW_51_99==1 & OW_100==0
	*Conclusion: no significant income shifting in any possible case
*3. Wholly-owned subs, PART 3 of FIGURE 10
	margins, dydx(TaxDiff) at(LFA_d=(0(1)1) LIFA_d=(0(1)1) Case2=(0(1)1) ///
	OW_51_99=(0) OW_100=(1))
	marginsplot, level(90)
	tab LFA_d if Used_int==1 & OW_51_99==0 & OW_100==1
	*Conclusion: significant income shifting found if LFA are above mean.
	*OVERALL conclusion: Similar conlcusion as in FIGURE 9, ownership 
	*interaction seems to have more influence than the shifting direction 
	*interaction and the capital interaction seems to have more influence 
	*than the intangibles interaction.

*(4) Including only combined significant interactions (dummy spec)
**********************************************************************
*Continous variable of LFA is replaced by corresponding dummy variable
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year i.LFA_d LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff c.TaxDiff#i.LFA_d c.TaxDiff#i.OW_51_99 ///
	c.TaxDiff#i.OW_100 if NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store FEIC_4
*Marginal effects
*1.	<51% Ownership
	margins, dydx(TaxDiff) at(LFA_d=(0(1)1) OW_51_99=0 OW_100=0)
	*Conclusion: No significant income shifting
*2. Between 51 and 99% ownership
	margins, dydx(TaxDiff) at(LFA_d=(0(1)1) OW_51_99=1 OW_100=0)
	*Conclusion: No significant income shifting
*3. Wholly-owned subsidiaries
	margins, dydx(TaxDiff) at(LFA_d=(0(1)1) OW_51_99=0 OW_100=1)
	*Conclusion: Significant income shifting found.
	*OVERALL conclusion: Qualitatively the same results as in FIGURE 10,
	*except that wholly-owned firms shift income with below mean LFA.
	*However, the insignificance in FIGURE 10 was borderline.
*Marginal effects for table 9 in thesis:
margins, dydx(TaxDiff) at(LFA_d=1 OW_51_99=0 OW_100=0)
margins, dydx(TaxDiff) at(LFA_d=1 OW_51_99=1 OW_100=0)
margins, dydx(TaxDiff) at(LFA_d=1 OW_51_99=0 OW_100=1)
margins, dydx(TaxDiff) at(LFA_d=0 OW_51_99=0 OW_100=0)
margins, dydx(TaxDiff) at(LFA_d=0 OW_51_99=1 OW_100=0)
margins, dydx(TaxDiff) at(LFA_d=0 OW_51_99=0 OW_100=1)

*generate TABLE 8 (font size or size of result window might have to be
	*adjusted in order for the table to be displayed in proper format)
	*N_g ist the number of firms, g_avg is the average number of observations
	*per group, r2_a is the within r-squared and F is the overall F-statistic
esttab FEIC_1 FEIC_2 FEIC_3 FEIC_4, b(%9.3f) t(%9.3f) ///
	scalars(N_g g_avg r2_a F) drop ( ****.Year **.NACE_MainN ///
	0.OW_100#c.TaxDiff 0.OW_51_99#c.TaxDiff 0.Case2 0.Case2#c.TaxDiff ///
	0.LFA_d 0.LFA_d#c.TaxDiff 0.LIFA_d 0.LIFA_d#c.TaxDiff) ///
	star(* 0.1 ** 0.05 *** 0.01 ) staraux star ///
	mtitle("All c" "Sig c" "All i" "Sig i" "Sig c" )
drop _est_FEIC_1 _est_FEIC_2 _est_FEIC_3 _est_FEIC_4 
	


********************************
*****ROBUSTNESS REGRESSIONS*****
********************************

*1. Robustness for Basic Model
//////////////////////////////
*all regressions are based on the benchmark regression (2) in table 6.

*(1) Benchmark Regression with LPTI as dependent variable
*********************************************************
quietly xtreg LPTI i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff if NACE_Main=="C"|NACE_Main=="G", ///
	fe vce(cluster BvDID)
est store ROB1_1

*(2) Benchmark Regression with different inputs for production function
***********************************************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LTFA LNEmployees ///
	LGDP_per_capita_current_LCU TaxDiff if NACE_Main=="C"|NACE_Main=="G", ///
	fe vce(cluster BvDID)
est store ROB1_2

*(3) Benchmark Regression on expanded industries
************************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff if NACE_Main=="A"|NACE_Main=="B"| ///
	NACE_Main=="C"|NACE_Main=="D"|NACE_Main=="E"|NACE_Main=="F"| ///
	NACE_Main=="G"|NACE_Main=="H"|NACE_Main=="I", fe vce(cluster BvDID)
est store ROB1_3

*(4) Benchmark Regression on sample of only majority owned subsidiaries
***********************************************************************
gen MAJOR = 1 if OW_100==1
replace MAJOR = 1 if OW_51_99==1
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff if NACE_Main=="C" & MAJOR==1| ///
	NACE_Main=="G" & MAJOR==1, fe vce(cluster BvDID)
est store ROB1_4

*(5) Benchmark with TaxRate instead of TaxDiff
**********************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxRate if NACE_Main=="C"|NACE_Main=="G", ///
	fe vce(cluster BvDID)
est store ROB1_5

*generate TABLE 10 (font size or size of result window might have to be
	*adjusted in order for the table to be displayed in proper format)
	*N_g ist the number of firms, g_avg is the average number of observations 
	*per group, r2_a is the within r-squared and F is the overall F-statistic.
esttab ROB1_1 ROB1_2 ROB1_3 ROB1_4 ROB1_5, b(%9.3f) t(%9.3f) ///
	scalars(N_g g_avg r2_a F) drop ( ****.Year **.NACE_MainN) ///
	star(* 0.1 ** 0.05 *** 0.01 ) staraux star ///
	mtitle("P/L" "Alt. Prod." "Exp. Ind." "Major" "TaxRate" )
drop _est_ROB1_1 _est_ROB1_2 _est_ROB1_3 _est_ROB1_4 _est_ROB1_5	

	
	
*2. Robustness for Extended Model (single interactions)
///////////////////////////////////////////////////////
*Regressions (1), (3), (6) and (7) from Table 7 + additional control variables
	*add. controls: LDED (leverage), GDP_growth

*(1) Capital interaction (continuous) + add. Controls
*****************************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees LDED ///
	LGDP_per_capita_current_LCU GDP_growth TaxDiff c.TaxDiff#c.LFA if ///
	NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store ROB2_1
*Marginal effects (not plotted in thesis)
margins, dydx(TaxDiff) at(LFA=(1(1)25))
marginsplot
*Conclusion: same qualitative results as before.
*Marginal effect at sample mean:
margins, dydx(TaxDiff) at(LFA=13.942)

*(2) Intangibles interaction (continuous) + add. Controls
*********************************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees LDED ///
	LGDP_per_capita_current_LCU GDP_growth TaxDiff LIFA c.TaxDiff#c.LIFA if ///
	NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store ROB2_2
*Marginal effects (not plotted in thesis)
margins, dydx(TaxDiff) at(LIFA=(-5(1)24))
marginsplot
*Conclusion: same qualitative result as before.

*(3) Ownership interaction + add. Controls
******************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees LDED ///
	LGDP_per_capita_current_LCU GDP_growth TaxDiff c.TaxDiff#i.OW_51_99 ///
	c.TaxDiff#i.OW_100 if NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store ROB2_3
*Marginal effects
*1. <51% ownership
	margins, dydx(TaxDiff) at(OW_51_99=0 OW_100=0)
	*Conclusion: No significant income shifting (same as before).
*2. Between 51 and 99% ownershio
	margins, dydx(TaxDiff) at(OW_51_99=1 OW_100=0)
	*Conclusion: No significant income shifting (same as before).
*3. Wholly-owned subsidiaries
	margins, dydx(TaxDiff) at(OW_51_99=0 OW_100=1)
	*Conclusion: Significant income shifting (same as before).

*(4) Shifting direction interaction + add. controls
***************************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees LDED ///
	LGDP_per_capita_current_LCU GDP_growth TaxDiff c.TaxDiff#i.Case2 i.Case2 ///
	if NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store ROB2_4
*Marginal effects:
margins, dydx(TaxDiff) at(Case2=(0(1)1))
*Conclusion: Significant income shifting if shifting direction is towards
	*the parent only (same as before).

*generate TABLE 11 (font size or size of result window might have to be
	*adjusted in order for the table to be displayed in proper format)
	*N_g ist the number of firms, g_avg is the average number of observations
	*per group, r2_a is the within r-squared and F is the overall F-statistic
esttab ROB2_1 ROB2_2 ROB2_3 ROB2_4, b(%9.3f) t(%9.3f) ///
	scalars(N_g g_avg r2_a F) drop ( ****.Year **.NACE_MainN ///
	0.OW_51_99#c.TaxDiff 0.OW_100#c.TaxDiff 0.Case2 0.Case2#c.TaxDiff) ///
	star(* 0.1 ** 0.05 *** 0.01 ) staraux star ///
	mtitle("Capital" "Intangibles" "Ownership" "Direction")
drop _est_ROB2_1 _est_ROB2_2 _est_ROB2_3 _est_ROB2_4

	

*3. Robustness for Extendend Model (combined interactions)
//////////////////////////////////////////////////////////
*all regression are based on regression (2) from table 8 with the following
*variations:

*(1) Regression (2) from TABLE 8 + additional controls
**************************************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees LDED ///
	LGDP_per_capita_current_LCU GDP_growth TaxDiff c.TaxDiff#c.LFA ///
	c.TaxDiff#i.OW_51_99 c.TaxDiff#i.OW_100 if ///
	NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store ROB3_1
*Marginal effect at sample mean:
margins, dydx(TaxDiff) at(LFA=13.942 OW_100=1 OW_51_99=0)

*(2) Regression (2) from TABLE 8 + P/L as dependent variable
********************************************************************
quietly xtreg LPTI i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff c.TaxDiff#c.LFA c.TaxDiff#i.OW_51_99 ///
	c.TaxDiff#i.OW_100 if NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store ROB3_2
*Marginal effect at sample mean:
margins, dydx(TaxDiff) at(LFA=13.942 OW_100=1 OW_51_99=0)
margins, dydx(TaxDiff) at(LFA=13.942 OW_100=0 OW_51_99=1)
margins, dydx(TaxDiff) at(LFA=13.942 OW_100=0 OW_51_99=0)

*(3) Regression (2) from TABLE 8 + different production factors
***********************************************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LTFA LNEmployees ///
	LGDP_per_capita_current_LCU TaxDiff c.TaxDiff#c.LTFA ///
	c.TaxDiff#i.OW_51_99 c.TaxDiff#i.OW_100 if ///
	NACE_Main=="C"|NACE_Main=="G", fe vce(cluster BvDID)
est store ROB3_3
*Marginal effect at sample mean:
summarize LTFA if Used==1
margins, dydx(TaxDiff) at(LTFA=13.480 OW_100=1 OW_51_99=0)

*(4) Regression (2) from TABLE 8 + on expanded industries
***************************************************************
*expanded industries: if NACE_Main=="A"|NACE_Main=="B"|NACE_Main=="C"|
	*NACE_Main=="D"|NACE_Main=="E"|NACE_Main=="F"|NACE_Main=="G"|NACE_Main=="H"|
	*NACE_Main=="I"
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff c.TaxDiff#c.LFA c.TaxDiff#i.OW_51_99 ///
	c.TaxDiff#i.OW_100 if NACE_Main=="A"|NACE_Main=="B"|NACE_Main=="C"| ///
	NACE_Main=="D"|NACE_Main=="E"|NACE_Main=="F"|NACE_Main=="G"| ///
	NACE_Main=="H"|NACE_Main=="I", fe vce(cluster BvDID)
est store ROB3_4
*Marginal effect at sample mean:
margins, dydx(TaxDiff) at(LFA=13.942 OW_100=1 OW_51_99=0)


*generate TABLE 12 (font size or size of result window might have to be
	*adjusted in order for the table to be displayed in proper format)
	*N_g ist the number of firms, g_avg is the average number of observations
	*per group, r2_a is the within r-squared and F is the overall F-statistic
esttab ROB3_1 ROB3_2 ROB3_3 ROB3_4, b(%9.3f) t(%9.3f) ///
	scalars(N_g g_avg r2_a F) drop ( ****.Year **.NACE_MainN ///
	0.OW_51_99#c.TaxDiff 0.OW_100#c.TaxDiff) ///
	star(* 0.1 ** 0.05 *** 0.01 ) staraux star ///
	mtitle("Add Control" "P/L" "Alt. Prod" "Exp. Ind")
drop _est_ROB3_1 _est_ROB3_2 _est_ROB3_3 _est_ROB3_4

	

//////////////////////////////////////////////
/////								     /////
/////   PART 3:  DISCUSSION OF RESULTS   /////
/////								     /////
//////////////////////////////////////////////
	
*1. Did income shifting deacrease over time?
////////////////////////////////////////////
*Superficially studied by (Lohse & Riedel 2012), marginal effects not properly 
*analysed.
*Benchmark regression from TABLE 6 with continous time + Time interaction
*Note that her construction of an additional time variable is unnecessary (does
*not change coefficient estimate nor significance), however, her newly created
*time index results in having more convenient estimate of the TaxDiff variable
*(here the coefficient is huge, because the time trend is in actual years
*instead of numbers 1 to 9).
quietly xtreg LEBIT i.NACE_MainN##c.Year LFA LCEmployees ///
LGDP_per_capita_current_LCU TaxDiff c.TaxDiff#c.Year if NACE_Main=="C"| ///
NACE_Main=="G", fe vce(cluster BvDID)
est store TIME_1
	*Marginal effects, PART 1 of FIGURE 11:
	estat vce
	tab Year if Used==1
	margins, dydx(TaxDiff) at(Year=(2007(1)2015)) vsquish
	marginsplot, x(Year) yline(0) recast(line) recastci(rarea) level(90)
	*Conclusion: Income shifting decreased over time and seems to be absent in
	*the most recent years of the sample period.

*A more detailed estimation can be achieved by using dummy variables instead of 
*a linear time trend. This is done below.
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
LGDP_per_capita_current_LCU TaxDiff c.TaxDiff#i.Year if NACE_Main=="C"| ///
NACE_Main=="G", fe vce(cluster BvDID)
est store TIME_2	
	*Marginal effect, PART 2 of FIGURE 11:
	margins, dydx(TaxDiff) at(Year=(2007(1)2015)) vsquish
	marginsplot, x(Year) yline(0) recast(line) recastci(rarea) level(90)
	*Conclusion: Income shifting varies over time, with a decreasing trend.
	*Dummy variable specification allows more detailed insight. Income shifting
	*is also present in recent sample years.
	
*generate TABLE 13 (font size or size of result window might have to be
	*adjusted in order for the table to be displayed in proper format)
	*N_g ist the number of firms, g_avg is the average number of observations
	*per group, r2_a is the within r-squared and F is the overall F-statistic
esttab TIME_1 TIME_2, b(%9.3f) t(%9.3f) scalars(N_g g_avg r2_a F) drop ///
	(****.Year **.NACE_MainN 2007.Year#c.TaxDiff) ///
	star(* 0.1 ** 0.05 *** 0.01 ) staraux star ///
	mtitle("Continuous" "Dummy")
drop _est_TIME_1 _est_TIME_2



*2. Are income shifting patterns different across the globe?
////////////////////////////////////////////////////////////
*Superficially studied by Huizinga & Laeven (2008), marginal effects not
	*properly analysed.
*Same procedure as with time interation dummies (BENCHMARK REGRESSION +
	*Location interaction). Note that the dummy variables depicting the region
	*cannot be included in the regression as the dummies do not vary over time.
encode UN_Broad, generate(UN_B)
encode UN_Detailed, generate(UN_D)
*(1) for the broad UN geoscheme
*******************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff c.TaxDiff#i.UN_B if NACE_Main=="C"| ///
	NACE_Main=="G", fe vce(cluster BvDID)
est store LOC_1
*Marginal effects, (1=Africa, 2=Americas, 3=Asia, 4=Europe, 5=Oceania)
	*PART 1 of FIGURE 12
tab UN_Broad if Used==1
margins, dydx(TaxDiff) at(UN_B=(1 2 3 4 5)) vsquish
marginsplot, yline(0) recast(line) level(90)
*Conclusion: Significant income shifting in Americas, Europe, Oceania.
	
*(2) for the UN detailed geoscheme (for Europe only)
****************************************************
*Data sample is restricted to European observations
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
	LGDP_per_capita_current_LCU TaxDiff c.TaxDiff#i.UN_D if ///
	NACE_Main=="C" & UN_Broad=="Europe" | NACE_Main=="G" & ///
	UN_Broad=="Europe", fe vce(cluster BvDID)
est store LOC_2	
	*Marginal effects, (6=Eastern Europe, 10=Northern Europe, 15=Southern
	*Europe, 18=Western Europe). PART 2 of FIGURE 12.
	*annotation in R FIGURE 12 require this sample to be marked:
	count if e(sample)
	su `x' if e(sample)
	*Create a variable indicating whether the observeation was used (=1) in
	*the regression or not (=0)
		gen Used1=e(sample)
		codebook Used1
	tab UN_Detailed if Used1==1
	margins, dydx(TaxDiff) at(UN_D=(6 10 15 18)) vsquish
	marginsplot, level(90)
	*Conclusion: Significant income shifting in Western and Northern Europe.
	
*generate Table 14 (font size or size of result window might have to be
*adjusted in order for the table to be displayed in proper format)
*N_g ist the number of firms, g_avg is the average number of observations per
*group, r2_a is the within r-squared and F is the overall F-statistic
esttab LOC_1 LOC_2, b(%9.3f) t(%9.3f) scalars(N_g g_avg r2_a F) drop ///
	(****.Year **.NACE_MainN 1.UN_B#c.TaxDiff 6.UN_D#c.TaxDiff) ///
	star(* 0.1 ** 0.05 *** 0.01 ) staraux star ///
	mtitle("Worldwide" "Europe")
drop _est_LOC_1 _est_LOC_2 UN_B UN_D



//////////////////////////////////////////////
/////								     /////
/////   PART 4:    DATA AND SAMPLE       /////
/////								     /////
//////////////////////////////////////////////	
	
****************************
*****SUMMARY STATISTICS*****
****************************
*Table 2 in thesis.

summarize LEBIT if Used==1, detail
summarize LPTI if Used==1, detail
summarize LTA if Used==1, detail
summarize LFA if Used==1, detail
summarize LIFA if Used==1, detail
summarize LCEmployees if Used==1, detail
summarize LNEmployees if Used==1, detail
summarize LDED if Used==1, detail
summarize LGDP_per_capita_current_LCU if Used==1, detail
summarize TaxRate if Used==1, detail
summarize TaxDiff if Used==1, detail
summarize OW_51_99 if Used==1, detail
summarize OW_100 if Used==1, detail
summarize Case2 if Used==1, detail



****************************
*****CORRELATION MATRIX*****
****************************
*For Table 3 in thesis.

pwcorr LEBIT LFA LCEmployees LGDP_per_capita_current_LCU LIFA LDED TaxDiff ///
if Used==1, obs sig star(0.1)



****************************
*****COUNTRY STATISTICS*****
****************************
*For Table 4 in thesis.

preserve

drop if Used==0

egen tag = tag(Country BvDIDnumber)
egen distinct = total(tag), by(Country)
bysort Country : gen freq = _N
gen fraction = distinct / freq
tabdisp Country, c(distinct freq fraction)
drop tag distinct freq fraction

tab UN_Broad
codebook BvDID
tab Country
codebook Country

restore



*****************************
*****TAX RATE STATISTICS*****
*****************************	

*This will mark all observations within a firm that has at least one year
*that is used in estimation. NEED is equal to 1 for every year per Firm, if at
*least one of the years is used for estimation.
by BvDID: egen NEED=max(Used)
*mark the first observation that is needed per country 
egen FIRST= tag(CountryISO_S NEED)
*Redo the first command, but this time. After this third command, each Country
*that is at least used once in the regression has a value of 1 at the variable
*NEED2 for every year. These are the observations that are used to calculate
*unweighted Tax rate statistics across regions.
by BvDID: egen NEED2=max(FIRST) if NEED==1
*As a check, the number of observations with NEED2 ==1 should be: 9*63=567,
*because there are 63 countries present in the sample, and i need the tax
*rate in every year to do the calulations.
tab NEED2

*now the tax rate statistics can be calculated and it is assured that it will
*be unweighted measures.
summarize TaxRate if UN_Broad=="Africa" & NEED2==1, detail
summarize TaxRate if UN_Broad=="Americas" & NEED2==1, detail
summarize TaxRate if UN_Broad=="Asia" & NEED2==1, detail
summarize TaxRate if UN_Broad=="Europe" & NEED2==1, detail
summarize TaxRate if UN_Broad=="Oceania" & NEED2==1, detail
summarize TaxRate if NEED2==1, detail

*detailed for Europe
summarize TaxRate if UN_Detailed=="Eastern Europe" & NEED2==1, detail
summarize TaxRate if UN_Detailed=="Northern Europe" & NEED2==1, detail
summarize TaxRate if UN_Detailed=="Southern Europe" & NEED2==1, detail
summarize TaxRate if UN_Detailed=="Western Europe" & NEED2==1, detail

*same with the tax differentials
summarize TaxDiff if UN_Broad=="Africa" & NEED2==1, detail
summarize TaxDiff if UN_Broad=="Americas" & NEED2==1, detail
summarize TaxDiff if UN_Broad=="Asia" & NEED2==1, detail
summarize TaxDiff if UN_Broad=="Europe" & NEED2==1, detail
summarize TaxDiff if UN_Broad=="Oceania" & NEED2==1, detail
summarize TaxDiff if NEED2==1, detail

summarize TaxDiff if UN_Detailed=="Eastern Europe" & NEED2==1, detail
summarize TaxDiff if UN_Detailed=="Northern Europe" & NEED2==1, detail
summarize TaxDiff if UN_Detailed=="Southern Europe" & NEED2==1, detail
summarize TaxDiff if UN_Detailed=="Western Europe" & NEED2==1, detail

*prepare and export data for tax rate graphs in R (Figures 3,4 and 15 in thesis)
preserve

keep if NEED2==1
keep Year CountryISO_S TaxRate CHTaxRate TaxDiff UN_Broad UN_Detailed

bysort UN_Broad Year: egen UN_B_max_TR = max(TaxRate)
bysort UN_Broad Year: egen UN_B_min_TR = min(TaxRate)
bysort UN_Detailed Year: egen UN_D_max_TR = max(TaxRate)
bysort UN_Detailed Year: egen UN_D_min_TR = min(TaxRate)
bysort UN_Broad Year: egen UN_B_mean_TR = mean(TaxRate)
bysort UN_Detailed Year: egen UN_D_mean_TR = mean(TaxRate)
bysort UN_Broad Year: egen UN_B_sd_TR = sd(TaxRate)
bysort UN_Detailed Year: egen UN_D_sd_TR = sd(TaxRate)
gen UN_B_Lower= UN_B_mean_TR-UN_B_sd_TR
gen UN_B_Upper= UN_B_mean_TR+UN_B_sd_TR
gen UN_D_Lower= UN_D_mean_TR-UN_D_sd_TR
gen UN_D_Upper= UN_D_mean_TR+UN_D_sd_TR

sort CountryISO_S Year
export delimited using "/Users/rafaelschlatter/Desktop/R Figures/Tax Rate Graphs/Tax Rates CSV.csv", replace

restore



***********************************************
*****REGRESSION DIAGNOSTICS AND HISTOGRAMS*****
***********************************************

*Export Dataset for regression Diagnostics in R
***********************************************

*rerun model for which predictions and residuals are wanted, this is:
*(2) Benchmark Regression with year dummies and industry-year dummies
*********************************************************************
quietly xtreg LEBIT i.Year i.NACE_MainN##i.Year LFA LCEmployees ///
LGDP_per_capita_current_LCU TaxDiff if NACE_Main=="C"|NACE_Main=="G", ///
fe vce(cluster BvDID)
est store FE_2

*save model predictions and residuals
*prediction without fixed effect
predict PRED, xb
*prediction with fixed effect
predict PRED_FIXED, xbu
*Plain Error
predict RES, e
*Residual (Error and Fixed effect)
predict RES_FIXED, ue

preserve

drop if Used==0
keep BvDIDnumber Year CountryISO_S TaxRate TaxDiff Case2 NACE_Main LEBIT ///
LPTI LTFA LFA LTA LIFA LCEmployees LNEmployees LGDP_per_capita_current_LCU ///
TaxDiff LDED UN_Broad UN_Detailed PRED PRED_FIXED RES RES_FIXED

export delimited using "/Users/rafaelschlatter/Desktop/Figures/Regression Diagnostics + Histograms/Regression Diagnostics Data.csv", replace

restore



*UN Geo classification (TABLE 17 in Appendix)
tab Country if UN_Broad=="Africa"
tab Country if UN_Broad=="Asia"
tab Country if UN_Broad=="Americas"
tab Country if UN_Detailed=="Western Europe"
tab Country if UN_Detailed=="Eastern Europe"
tab Country if UN_Detailed=="Northern Europe"
tab Country if UN_Detailed=="Southern Europe"
tab Country if UN_Broad=="Oceania"




