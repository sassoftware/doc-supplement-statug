/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: nlinex2                                             */
/*   TITLE: Documentation Example 2 for PROC NLIN               */
/*          Iteratively Reweighted Least Squares                */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Robust regression                                   */
/*          Tukey's biweight function                           */
/*   PROCS: NLIN, ROBUSTREG                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

title 'U.S. Population Growth';
data uspop;
   input pop :6.3 @@;
   retain year 1780;
   year   = year+10;
   yearsq = year*year;
   datalines;
3929 5308 7239 9638 12866 17069 23191 31443 39818 50155
62947 75994 91972 105710 122775 131669 151325 179323 203211
226542 248710
;

title 'Beaton/Tukey Biweight Robust Regression using IRLS';
proc nlin data=uspop nohalve;
   parms b0=20450.43 b1=-22.7806 b2=.0063456;
   model pop=b0+b1*year+b2*year*year;
   resid = pop-model.pop;
   sigma = 2;
   k     = 4.685;
   if abs(resid/sigma)<=k then _weight_=(1-(resid / (sigma*k))**2)**2;
   else _weight_=0;
   output out=c r=rbi;
run;

data c;
   set c;
   sigma = 2;
   k     = 4.685;
   if abs(rbi/sigma)<=k then _weight_=(1-(rbi /(sigma*k))**2)**2;
   else _weight_=0;
run;

proc print data=c;
run;

proc robustreg data=uspop method=m(scale=2);
   model pop = year year*year;
   output out=weights weight=w;
run;

proc print data=weights;
run;

