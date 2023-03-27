/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ICALEX5                                             */
/*   TITLE: Documentation Example 1 for Introduction to SEM     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Patterned Covariance Matrix                         */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: Introduction to SEM, Example 1                      */
/*    MISC:                                                     */
/****************************************************************/

data motor(type=cov);
   input _type_ $ _name_ $ x1 x2 x3;
   datalines;
COV     x1      3.566   1.342   1.114
COV     x2      1.342   4.012   1.056
COV     x3      1.114   1.056   3.776
N        .         36      36      36
;

proc calis data=motor;
   mstruct var  = x1-x3;
   matrix _cov_ = phi
                  theta phi
                  theta theta phi;
run;

proc calis data=motor;
   mstruct var  = x1-x3;
   matrix _cov_ = phi1
                     0.   phi2
                     0.      0.    phi3;
run;

proc calis data=motor covpattern=uncorr;
run;

