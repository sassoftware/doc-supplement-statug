/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ICLFTEX1                                            */
/*   TITLE: Example 1 for PROC ICLIFETEST                       */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: non-detection data, left-censored data              */
/*   PROCS: ICLIFETEST                                          */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC ICLIFETEST, EXAMPLE 1                          */
/*    MISC:                                                     */
/****************************************************************/

data temp;
   input C1 C2;
   datalines;
  .     3
  4     4
  6     6
  8     8
  .     10
  12    12
;

proc iclifetest data=temp method=turnbull plots=survival(failure)
                impute(seed=1234);
   time (c1,c2);
run;

