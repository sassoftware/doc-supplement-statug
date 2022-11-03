/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX113                                            */
/*   TITLE: Documentation Example 15 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: FACTOR, missing data, full information ML           */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 15                              */
/*    MISC:                                                     */
/****************************************************************/

data missing;
   input x1 x2 x3 y1 y2 y3;
   datalines;
 23   .  16  15  14  16
 29  26  23  22  18  19
 14  21   .  15  16  18
 20  18  17  18  21  19
 25  26  22   .  21  26
 26  19  15  16  17  17
  .  17  19   4   6   7
 12  17  18  14  16   .
 25  19  22  22  20  20
  7  12  15  10  11   8
 29  24   .  14  13  16
 28  24  29  19  19  21
 12   9  10  18  19   .
 11   .  12  15  16  16
 20  14  15  24  23  16
 26  25   .  24  23  24
 20  16  19  22  21  20
 14   .  15  17  19  23
 14  20  13  24   .   .
 29  24  24  21  20  18
 26   .  26  28  26  23
 20  23  24  22  23  22
 23  24  20  23  22  18
 14   .  17   .  16  14
 28  34  27  25  21  21
 17  12  10  14  12  16
  .   1  13  14  15  14
 22  19  19  13  11  14
 18  21   .  15  18  19
 12  12  10  13  13  16
 22  14  20  20  18  19
 29  21  22  13  17   .
;

proc calis data=missing;
   factor
      verbal ===> x1-x3,
      math   ===> y1-y3;
   pvar
      verbal = 1.,
      math   = 1.;
run;

proc calis method=fiml data=missing;
   factor
      verbal ===> x1-x3,
      math   ===> y1-y3;
   pvar
      verbal = 1.,
      math   = 1.;
run;
