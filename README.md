# Master-Thesis-UZH
1. GENERAL INFO

The code in the Do-File „Stata Code MA“ has been written with Stata 14 and one additional package. The package is called „kountry“ by Raciborski (2008). The full reference is found in the thesis in the reference list. The package needs to be installed to run Part 1 of the code in the Do-File „Stata Code MA“.


2. DO-FILE „Stata Code MA“

PART 1: DATA PREPARATIONS
Part 1 in „Stata Code MA“ contains the code to put together all necessary data, this is messy, because the data stems from different sources and i put them together saving and importing many datasets. But if the first three slashes „/Users/rafaelschlatter/Desktop/“ of all file paths are replaced, the whole Do-File can be run at once. But, Stata’s „margin“ command (which i used frequently) took long to run on my computer, so it could take a while to run the whole file. Also important, in order that this works, the file names and locations of datafiles in the folder „MA DATA“ should not be changed.

PART 2 AND Part 3: REGRESSION ANALYSIS
Part 2 contains the regression analysis. You can easily skip Part 1 and jump right to this section. To do so, open the .dta file called „MA_Data_OW2_Tax_Ind_GDP_Debt.dta“ within the folder „MA Data“ -> „ORBIS Data“. This is the data file after all data preparations from Part 1 have been done. The code from Part 2 can be run straight away when this datafile is loaded in Stata. No file paths need to be changed here. Part 3 contains additional analysis.

PART 4: DATA AND SAMPLE STATISTICS
Part 4 contains mostly descriptive statistics and exports data into .csv format, which is then used in R to do some graphics.


3. FIGURES

Most of the Figures are done within R, the .r scripts are located in the Folder „Figures“ and can be run to produce the figures. I tried to include all necessary packages in the beginning of the scripts, i hope i didnt miss any. All figures are also provided in .pdf format and .svg format, which i used to add them into the thesis.


4. THESIS DOCUMENT FORMAT

I wrote the thesis in openoffice in an .odt format, which is not perfectly supported by microsoft word (but maybe can be opened with newer versions of word). I exported the .odt file into a word .doc file, however, the formatting is not transferred perfectly, but all text, tables and figures are also included in the word .doc. I also submitted the original .odt files, which can be read with openoffice/libreoffice.


5. ADDITIONAL

I also saved the lists and search strategy from ORBIS (in „MA Data“ -> „Raw Data and Search“). These files can be used to reproduce the data downloaded from ORBIS, but i think the dataset will be slightly different, since the ORBIS database is constantly updated.


I hope this helps.
Kind regards,
Rafael Schlatter
