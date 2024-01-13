import delimited "E:\Temp\FS_Combas.csv", encoding(UTF-8) 
gen year=substr(accper,1,4)
destring year,replace
drop if strmatch(shortname,"*ST*")
drop if strmatch(shortname,"*PT*")
drop if strmatch(shortname,"*退*")
gen x=1
sort stkcd year
save "E:\Temp\01.dta"
import delimited "E:\Temp\Internal control index and ratings (2000-2022).csv", clear 
gen stkcd=substr(证券代码,1,6)
destring stkcd ,replace
gen year=substr(报告期,1,4)
destring year ,replace
sort stkcd year
save "E:\Temp\02.dta"
import delimited "E:\Temp\FS_Comscfd.csv", clear
gen year=substr(accper,1,4)
destring year,replace
sort stkcd year
save "E:\Temp\03.dta"
use "E:\Temp\Control variable set.dta"
merge stkcd year using E:\Temp\03
drop _m
sort stkcd year
merge stkcd year using E:\Temp\02
drop _m
sort stkcd year
merge stkcd year using E:\Temp\01
drop _m
sort stkcd year
xtset stkcd year
save "E:\Temp\04.dta"
import delimited "E:\Temp\PT_LCRDSPENDING.csv", clear
gen stkcd=sym
gen year=substr(end,1,4)
destring year,replace
sort stkcd year
drop if rdspendsum==.
drop if source==1
keep if statetypecode==1
xtset stkcd year
sort stkcd year
save "E:\Temp\05.dta"
use "E:\Temp\04.dta"
merge stkcd year using E:\Temp\05
drop _m
sort stkcd year
keep if year<=2020&year>=2012
keep if x==1
gen totalasset=exp(Size)
gen RD=rdspendsum/totalasset
gen ICQ=ln(内部控制指数评分)
gen OCF=c001000000/totalasset
drop if  ROA==.|RD==.|ICQ==.|Size==.|Lev==.|Grow==.|OCF==.
sum stkcd
xtset stkcd year
xtbalance ,range(2012 2020)
sum stkcd
winsor2 ROA RD ICQ Size Lev Grow OCF ,cut(1 99) replace by(year)
//Descriptive statistical analysis
sum ROA RD ICQ Size Lev Grow OCF
//Descriptive statistical analysis
pwcorr_a  ROA RD ICQ Size Lev Grow OCF
//Regression analysis
reg  ROA RD  Size Lev Grow OCF i.year ,r
est store y1
reg  ROA l.RD  Size Lev Grow OCF i.year ,r
est store y2
reg  ROA l2.RD  Size Lev Grow OCF i.year ,r
est store y3
local s  "using y1.rtf"  
local m  "y1 y2 y3"
 esttab `m' `s', mtitle($m) nogap compress  b(%6.3f) r2 ar2 scalar(N F) replace  star(* 0.1 ** 0.05 *** 0.01) drop (*year*)
//Step Two 
reg  ROA ICQ  Size Lev Grow OCF i.year ,r
est store y1
gen RD_ICQ=RD*ICQ
reg  ROA RD ICQ RD_ICQ Size Lev Grow OCF i.year ,r
est store y2
local s  "using y2.rtf"  
local m  "y1 y2"
 esttab `m' `s', mtitle($m) nogap compress  b(%6.3f) r2 ar2 scalar(N F) replace  star(* 0.1 ** 0.05 *** 0.01) drop (*year*)
//Robustness test
winsor2 TobinQ,cut(1 99) replace
reg  TobinQ RD  Size Lev Grow OCF i.year ,r
est store y1
reg  TobinQ l.RD  Size Lev Grow OCF i.year ,r
est store y2
reg  TobinQ l2.RD  Size Lev Grow OCF i.year ,r
est store y3
reg  TobinQ ICQ  Size Lev Grow OCF i.year ,r
est store y4
reg  TobinQ RD ICQ RD_ICQ Size Lev Grow OCF i.year ,r
est store y5
local m  "y1 y2 y3 y4 y5"
local s  "using y3.rtf"
 esttab `m' `s', mtitle($m) nogap compress  b(%6.3f) r2 ar2 scalar(N F) replace  star(* 0.1 ** 0.05 *** 0.01) drop (*year*)
