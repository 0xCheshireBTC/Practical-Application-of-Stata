import excel "E:\Temp\Calculation of the Theil Index for Urban-Rural Income Gap.xlsx", sheet("Sheet1") firstrow
gen year=年份
drop if year<2005
gen I_urban= 城镇居民人均可支配收入* 城镇人口万人*10000
gen I_rural= 农村居民人均可支配收入* 乡村人口万人*10000
sort I_rural
drop in 528/528
gen I_t=I_urban+I_rural
gen P_t= 城镇人口+ 乡村人口
gen I1=I_urban/I_t
gen I2=I_rural/I_t
gen P1=城镇人口/P_t
gen P2=乡村人口/P_t
gen lnIP_urban=ln(I1/P1)
gen lnIP_rural=ln(I2/P2)
gen theil=I1*lnIP_urban+I2*lnIP_rural
sum theil
sum theil if year<=2020&year>=2011