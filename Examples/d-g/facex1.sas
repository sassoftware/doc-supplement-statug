/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: facex1                                              */
/*   TITLE: Documentation Example 1 for PROC FACTOR             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: factor analysis                                     */
/*   PROCS: FACTOR                                              */
/*     REF: Harman (1976), Modern Factor Analysis, 3rd Ed.      */
/****************************************************************/

/*
This example demonstrates a principal component analysis.
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

proc factor data=SocioEconomics simple corr;
run;

proc factor data=SocioEconomics n=5 score;
run;

proc princomp data=SocioEconomics;
run;

proc factor data=SocioEconomics n=5 score;
   ods output StdScoreCoef=Coef;
run;

proc stdize method=ustd mult=.44721 data=Coef out=eigenvectors;
   var Factor1-Factor5;
run;

proc print data=eigenvectors;
run;

