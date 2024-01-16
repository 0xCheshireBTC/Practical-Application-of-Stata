use "E:\Temp\Dataset.dta" 
gen Econ1=In(高管前三名薪酬总额+1)
gen Econ2=高管持股数量/总股数
gen Debt=lev
gen Y1=ATO
drop if ROA==.|Econ1==.|Econ2==.|Size==.|Top1==.|Debt==.|Y1==.
keep if year>=2015&year<=2021
winsor2 ROA ROE Econ1 Econ2 Size Top1 Debt Y1,cut(1 99) replace by(year)
sum ROA Econ1 Econ2 Size Top1 Debt Y1
pwcorr_a  ROA Econ1 Econ2 Size Top1 Debt Y1
reg  ROA Econ1 Size Top1 Debt Y1 i.year i.Ind
reg  ROA Econ2 Size Top1 Debt Y1 i.year i.Ind
reg  ROA Econ1 Size Top1 Debt Y1 i.year i.Ind if SOE==1
est store y1
reg  ROA Econ1 Size Top1 Debt Y1 i.year i.Ind if SOE==0
est store y2
reg  ROA Econ2 Size Top1 Debt Y1 i.year i.Ind if SOE==1
est store y3
reg  ROA Econ2 Size Top1 Debt Y1 i.year i.Ind if SOE==0
est store y4
local s  "using y1.rtf"  
local m  "y1 y2 y3 y4"
 esttab `m' `s', mtitle($m) nogap compress  b(%6.3f)  ar2 scalar(N F) replace  star(* 0.1 ** 0.05 *** 0.01) drop (*Ind* *year*)