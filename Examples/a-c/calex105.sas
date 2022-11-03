/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX105                                            */
/*   TITLE: Documentation Example 4 for PROC CALIS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: MSTRUCT, testing covariance patterns                */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 4                               */
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
   mstruct var=q1-q4;
   matrix _cov_ [1,1] = 4*sigma_sq;
run;

title "Sphericity Test for the Sales Data Using MSTRUCT: "
      "Equivalent Specification";
proc calis data=sales;
   mstruct var=q1-q4;
   matrix _cov_ [1,1] = sigma_sq,
                [2,2] = sigma_sq,
                [3,3] = sigma_sq,
                [4,4] = sigma_sq;
   fitindex on(only)=[chisq df probchi];
run;

data frets(type=cov);
   input _type_ $ _name_ $ x1 x2;
   datalines;
cov   x1    91.481   66.875
cov   x2    66.875   96.775
n      .      25      25
;
title "Sphericity Test verification: Mardia, Kent, and Bibby - "
      "Multivariate Analysis p.134";
proc calis data=frets vardef=n;
   mstruct var=x1-x2;
   matrix _cov_ [1,1] = 2*sigma_sq;
   fitindex on(only)=[chisq df probchi];
run;
