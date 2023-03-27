/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: hpgenex2                                            */
/*   TITLE: Example 2 for PROC HPGENSELECT                      */
/*          Modeling binomial data                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Logistic regression analysis,                       */
/*          Binomial response data                              */
/*   PROCS: HPGENSELECT                                         */
/*    DATA:                                                     */
/*                                                              */
/*    REF: SAS/HPA User's Guide, PROC HPGENSELECT chapter       */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 2: Modeling Binomial Data
****************************************************************/

/*
The data, taken from Cox and Snell (1989, pp 10-11), consists of
the number, r, of ingots not ready for rolling, out of n tested,
for a number of combinations of heating time and soaking time.
PROC HPGENSELECT is invoked using events/trials syntax to fit the
binary logit model to the grouped data.
*/

title 'Example 2: Modeling Binomial Data';

data Ingots;
   input Heat Soak r n @@;
   Obsnum= _n_;
   datalines;
7 1.0 0 10  14 1.0 0 31  27 1.0 1 56  51 1.0 3 13
7 1.7 0 17  14 1.7 0 43  27 1.7 4 44  51 1.7 0  1
7 2.2 0  7  14 2.2 2 33  27 2.2 0 21  51 2.2 0  1
7 2.8 0 12  14 2.8 0 31  27 2.8 1 22  51 4.0 0  1
7 4.0 0  9  14 4.0 0 19  27 4.0 1 16
;

proc hpgenselect data=Ingots;
   model r/n = Heat Soak Heat*Soak / dist=Binomial;
   id Obsnum;
   output out=Out xbeta predicted=Pred;
run;

data Out;
   merge Out Ingots;
   by Obsnum;
proc print data=Out;
   where Heat=14 & Soak=1.7;
run;

data Ingots_binary;
   set Ingots;
   do i=1 to n;
     if i <= r then Y=1; else Y = 0;
     output;
   end;
run;

proc hpgenselect data=Ingots_binary;
   model Y(event='1') = Heat Soak Heat*Soak / dist=Binary;
run;

