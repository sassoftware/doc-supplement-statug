
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: GENMEX11                                            */
/*   TITLE: Example 11 for PROC GENMOD                          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: generalized linear models, exact Poisson regression */
/*   PROCS: GENMOD                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC GENMOD, EXAMPLE 11                             */
/*    MISC:                                                     */
/****************************************************************/

/* The data, taken from Cox and Snell (1989, pp 10-11), consists of
the number, Notready, of ingots not ready for rolling, out of Total
tested, for a number of combinations of heating time and soaking
time.  PROC GENMOD is invoked to fit asymptotic and exact
conditional Poisson regression models to the data.  */

title 'Exact Poisson Regression';

data ingots;
   input Heat Soak Notready Total @@;
   lnTotal= log(Total);
   datalines;
7 1.0 0 10  14 1.0 0 31  27 1.0 1 56  51 1.0 3 13
7 1.7 0 17  14 1.7 0 43  27 1.7 4 44  51 1.7 0  1
7 2.2 0  7  14 2.2 2 33  27 2.2 0 21  51 2.2 0  1
7 2.8 0 12  14 2.8 0 31  27 2.8 1 22  51 4.0 0  1
7 4.0 0  9  14 4.0 0 19  27 4.0 1 16
;

proc genmod data=ingots;
   class Heat Soak / param=ref;
   model Notready=Heat Soak / offset=lnTotal dist=Poisson link=log;
   exact Heat Soak / joint estimate;
   exactoptions statustime=10;
run;

