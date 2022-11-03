/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX201                                            */
/*   TITLE: Documentation Example 7 for PROC CALIS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: LINEQS, PATH, multivariate regression               */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 7                               */
/*    MISC:                                                     */
/****************************************************************/

data sales;
   input q1 q2 q3 q4;
   datalines;
1.03   1.54   1.11   2.22
1.23   1.43   1.65   2.12
3.24   2.21   2.31   5.15
1.23   2.35   2.21   7.17
 .98   2.13   1.76   2.38
1.02   2.05   3.15   4.28
1.54   1.99   1.77   2.00
1.76   1.79   2.28   3.18
1.11   3.41   2.20   3.21
1.32   2.32   4.32   4.78
1.22   1.81   1.51   3.15
1.11   2.15   2.45   6.17
1.01   2.12   1.96   2.08
1.34   1.74   2.16   3.28
;

proc calis data=sales;
   path   q1 q2 q3 ===>  q4;
run;

proc calis data=sales;
   path   q1       ===>  q2,
          q2       ===>  q3,
          q1 q2 q3 ===>  q4;
run;

proc calis data=sales;
   path   q1   ===>  q2,
          q2   ===>  q3,
          q3   ===>  q4;
run;

proc calis data=sales;
   path   q1   ===>  q2      = gamma,
          q2   ===>  q3      = gamma,
          q3   ===>  q4      = gamma;
run;

proc calis data=sales;
   path   q1   ===>  q2      = gamma,
          q2   ===>  q3      = gamma,
          q3   ===>  q4      = gamma;
   pvar   q2 q3 q4 = 3 * evar;
run;

proc calis data=sales;
   path   q1   ===>  q2      = gamma,
          q2   ===>  q3      = gamma,
          q3   ===>  q4      = gamma;
   pvar   q2 q3 = 2 * evar,
          q4 q1;
run;

proc calis data=sales;
   path   q1   ===>  q2      = gamma,
          q2   ===>  q3      = gamma,
          q3   ===>  q4      = gamma,
          <==>    q2 q3      = 2 * evar,
          <==>    q4 q1;
run;

proc calis data=sales;
   path   q1   ===>  q2      = gamma,
          q2   ===>  q3      = gamma,
          q3   ===>  q4      = gamma,
          q2   <==>  q2      = evar,
          q3   <==>  q3      = evar,
          q4   <==>  q4,
          q1   <==>  q1;
run;

proc calis data=sales;
   path   q1   ===>  q4  ,
          q2   ===>  q4  ,
          q3   ===>  q4  ,
          q1   <==>  q1  ,
          q2   <==>  q2  ,
          q3   <==>  q3  ,
          q1   <==>  q2  ,
          q2   <==>  q3  ,
          q1   <==>  q3  ,
          q4   <==>  q4  ;
run;

proc calis data=sales;
   path   q1 q2 q3  ===>  q4  ,
          <==>  [q1-q3]  ,
          <==>  q4  ;
run;

proc calis data=sales;
   path   q1   ===>  q4  ,
          q2   ===>  q4  ,
          q3   ===>  q4  ,
          q1   <==>  q1  ,
          q2   <==>  q1  ,
          q2   <==>  q2  ,
          q3   <==>  q1  ,
          q3   <==>  q2  ,
          q3   <==>  q3  ,
          q4   <==>  q4  ;
run;
