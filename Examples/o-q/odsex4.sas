/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSEX4                                              */
/*   TITLE: Documentation Example 4 for ODS                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS                                                 */
/*   PROCS: GENMOD                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF: Using the Output Delivery System                    */
/*    MISC:                                                     */
/****************************************************************/

title 'Insurance Claims';

data Insure;
   input n c Car $ Age;
   ln = log(n);
   datalines;
 500   42  Small  1
1200   37  Medium 1
 100    1  Large  1
 400  101  Small  2
 500   73  Medium 2
 300   14  Large  2
;

ods trace on;

proc genmod data=insure;
   class car age;
   model c = car age / dist=poisson link=log offset=ln obstats;
run;

ods trace off;

ods select none;
proc genmod data=insure;
   class car age;
   model c = car age / dist=poisson link=log offset=ln obstats;
   ods output ObStats=myObStats(keep=car age pred
                                rename=(pred=PredictedValue));
run;

proc sort data=myObStats;
   by descending PredictedValue;
run;

ods select all;
proc print data=myObStats noobs;
   title2 'Values of Car, Age, and the Predicted Values';
run;
