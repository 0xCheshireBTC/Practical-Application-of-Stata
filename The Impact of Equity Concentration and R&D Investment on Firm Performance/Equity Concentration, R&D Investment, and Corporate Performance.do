doedit "E:\Equity Concentration, R&D Investment, and Corporate Performance\src\\Equity Concentration, R&D Investment, and Corporate Performance.do" 
import delimited "E:\Equity Concentration, R&D Investment, and Corporate Performance\src\PT_LCMAINFIN.csv", encoding(UTF-8) 
gen stkcd=symbol
gen year=substr(enddate,1,4)
destring year,replace
sort stkcd year
save "E:\Equity Concentration, R&D Investment, and Corporate Performance\src\PT_LCMAINFIN.dta", replace
import delimited "E:\Equity Concentration, R&D Investment, and Corporate Performance\src\PT_LCRDSPENDING.csv", encoding(UTF-8) clear 
gen stkcd=symbol
gen year=substr(enddate,1,4)
destring year,replace
sort stkcd year
save "E:\Equity Concentration, R&D Investment, and Corporate Performance\src\PT_LCRDSPENDING.dta", replace
merge stkcd year using E:\Equity Concentration, R&D Investment, and Corporate Performance\src\PT_LCMAINFIN.dta
drop _m
sort stkcd year
save "E:\Equity Concentration, R&D Investment, and Corporate Performance\src\02.dta", replace
use "E:\Equity Concentration, R&D Investment, and Corporate Performance\src\Original variables excluding financial STPT.dta"
sort stkcd year
merge stkcd year using E:\Equity Concentration, R&D Investment, and Corporate Performance\src\PT_LCRDSPENDING.dta
drop _merge 
sort stkcd year
gen RD=rdspendsum/operatingevenue
keep if 年末是否ST==0
drop if Top10==.|TobinQ==.|RD==.|ROA==.|Size==.|Lev==.|Cashflow==.|Growth==.|SOE==.
keep if year>=2017&year<=2021
keep if stkcd>=300000&stkcd<=399999
winsor2 Top10 TobinQ  RD ROA Size Lev Cashflow Growth ,cut(1 99) replace by(year)
sum Top10 TobinQ  RD ROA Size Lev Cashflow Growth SOE
pwcorr_a  Top10 TobinQ  RD ROA Size Lev Cashflow Growth SOE
logout, save(1) word replace: pwcorr_a  Top10 TobinQ  RD ROA Size Lev Cashflow Growth SOE
encode Industry,gen(Indnme)
reg TobinQ Top10  Size Lev Growth Cashflow SOE i.Indnme i.year
esttab
reg TobinQ Top10 ROA Size Lev Growth Cashflow SOE i.Indnme i.year
esttab
reg TobinQ Top10 ROA Size Lev Growth Cashflow SOE i.Indnme i.year
est store y1
reg RD Top10 ROA Size Lev Growth Cashflow SOE i.Indnme i.year
est store y2
reg TobinQ RD  ROA Size Lev Growth Cashflow SOE i.Indnme i.year
est store y3
reg TobinQ Top10 RD  ROA Size Lev Growth Cashflow SOE i.Indnme i.year
est store y4
local s  "using y1.rtf"  
local m  "y1 y2 y3 y4"
 esttab `m' `s', mtitle($m) nogap compress  b(%6.3f)  r2 ar2 scalar(N F) replace  star(* 0.1 ** 0.05 *** 0.01)
 esttab `m' `s', mtitle($m) nogap compress  b(%6.3f)  r2 ar2 scalar(N F) replace  star(* 0.1 ** 0.05 *** 0.01) drop (*Ind* *year*)
reg f.TobinQ Top10 ROA Size Lev Growth Cashflow SOE i.Indnme i.year
est store y1
reg f.RD Top10 ROA Size Lev Growth Cashflow SOE i.Indnme i.year
est store y2
local m  "y1 y2"
local s  "using y2.rtf"
 esttab `m' `s', mtitle($m) nogap compress  b(%6.3f)  r2 ar2 scalar(N F) replace  star(* 0.1 ** 0.05 *** 0.01) drop (*Ind* *year*)