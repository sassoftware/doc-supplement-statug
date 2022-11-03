
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LIFEREX3                                            */
/*   TITLE: Example 3 for PROC LIFEREG                          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: survival data analysis, convergence problems        */
/*   PROCS: LIFEREG                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC LIFEREG, EXAMPLE 3.                            */
/*    MISC:                                                     */
/****************************************************************/


data raw;
   input censor x c1 @@;
   datalines;
0 16   0.00  0 17  0.00  0 18  0.00  0 17   0.04  0 18   0.04  0 18   0.04
0 23   0.40  0 22  0.40  0 22  0.40  0 33   4.00  0 34   4.00  0 35   4.00
1 54  40.00  1 54 40.00  1 54 40.00  1 54 400.00  1 54 400.00  1 54 400.00
;

proc print data=raw;
run;

title 'OLS (Default) Initial Values';
proc lifereg data=raw;
   model x*censor(1) = c1 / distribution = Weibull itprint;
run;

proc lifereg data=raw;
   model x*censor(1) = c1 / distribution = llogistic;
run;

proc lifereg data=raw outest=outest;
   model x*censor(1) = c1 / itprint distribution = weibull
                            intercept=2.898 initial=0.16 scale=0.05;
   output out=out xbeta=xbeta;
run;

data in;
   input  intercept c1 _scale_;
   datalines;
2.898 0.16 0.05
;

proc lifereg data=raw inest=in outest=outest;
   model x*censor(1) = c1 / itprint distribution = weibull;
   output out=out xbeta=xbeta;
run;
