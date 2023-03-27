/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: facex2                                              */
/*   TITLE: Documentation Example 2 for PROC FACTOR             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: factor analysis                                     */
/*   PROCS: FACTOR                                              */
/*     REF: Harman (1976), Modern Factor Analysis, 3rd Ed.      */
/****************************************************************/

/*
This example demonstrates a principal factor analysis.
*/

data SocioEconomics;
   input Population School Employment Services HouseValue;
   datalines;
5700     12.8      2500      270       25000
1000     10.9      600       10        10000
3400     8.8       1000      10        9000
3800     13.6      1700      140       25000
4000     12.8      1600      140       25000
8200     8.3       2600      60        12000
1200     11.4      400       10        16000
9100     11.5      3300      60        14000
9900     12.5      3400      180       18000
9600     13.7      3600      390       25000
9600     9.6       3300      80        12000
9400     11.4      4000      100       13000
;


ods graphics on;

proc factor data=SocioEconomics
   priors=smc msa residual
   rotate=promax reorder
   outstat=fact_all
   plots=(scree initloadings preloadings loadings);
run;

proc factor data=SocioEconomics rotate=promax
   priors=smc plots=preloadings(vector);
run;


proc print data=fact_all;
run;


data fact2(type=factor);
   set fact_all;
   if _TYPE_ in('PATTERN' 'FCORR') then delete;
   if _TYPE_='UNROTATE' then _TYPE_='PATTERN';
run;

proc factor data=fact2 rotate=quartimax reorder;
run;

proc factor data=fact2 rotate=hk norm=weight reorder plots=loadings;
run;

ods graphics off;

