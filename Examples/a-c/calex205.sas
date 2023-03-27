/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX205                                            */
/*   TITLE: Documentation Example 11 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: LINEQS, measurement error models                    */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 11                              */
/*    MISC:                                                     */
/****************************************************************/

data measures;
   input x y;
   datalines;
 7.91736    13.8673
 7.61290    12.9761
 7.60608    12.8040
 7.32266    13.2590
 7.57418    13.2502
 7.17199    13.1750
 5.72741    11.3299
 7.51832    12.3588
 7.15814    13.1556
 5.37445     9.6366
 6.10807    11.7966
 6.77190    11.6356
 6.65642    12.8866
 5.76977    10.7654
 7.17305    13.3416
 8.04604    14.5968
 6.66033    12.5159
 5.48877    11.2211
 7.35485    13.8457
 6.00419    11.7654
 6.94139    12.2174
 6.33328    11.7732
 6.26643    11.9382
 5.62881    11.5041
 8.23123    13.9876
 5.77692    11.5077
 7.14944    12.4988
 7.50323    13.3735
 8.91648    14.4929
 6.89546    13.1493
;

data multiple(type=cov);
   input _type_ $ 1-4  _name_ $ 6-8 @10 y x1 x2 x3;
   datalines;
mean     0.93   1.33   1.34   4.11
cov  y   1.31    .      .      .
cov  x1  1.24   1.42    .      .
cov  x2  0.21   0.18   1.15    .
cov  x3  3.91   4.21   0.58  14.11
;

proc calis data=measures;
   path
      x  <=== Fx  = 1.,
      Fx ===> Fy   ,
      Fy ===> y   = 1.;
   pvar
      x  = 0.019,
      y  = 0.022,
      Fx Fy;
run;

proc calis data=measures;
   lineqs
      x   = 1. * Fx  +  e1,
      y   = 1. * Fy  +  e2,
      Fy  =    * Fx  +   d;
   variance
      e1  = 0.019,
      e2  = 0.022,
      Fx d;
run;

proc calis data=multiple nobs=37;
   path
      Fy  <===   F1 F2 F3,
      F1  ===>   x1   = 1.,
      F2  ===>   x2   = 1.,
      F3  ===>   x3   = 1.,
      Fy  ===>   y    = 1.;
   pvar
      x1 x2 x3 y = .02 .03 .15 .02,
      Fy;
   pcov
      x1 x2 = 0.01;
run;

proc calis data=multiple nobs=37;
   lineqs
      Fy =     * F1 +  * F2 +  * F3 + d,
      x1 =  1. * F1 + e1,
      x2 =  1. * F2 + e2,
      x3 =  1. * F3 + e3,
       y =  1. * Fy + ey;
    variance
       e1-e3 ey = .02 .03 .15 .02,
       d;
    cov
       e1 e2 = 0.01;
run;

proc calis data=multiple nobs=37;
   path
      Fy  <===   F1 F2 F3,
      F1  ===>   x1   = 1.,
      F2  ===>   x2   = 1.,
      F3  ===>   x3   = 1.,
      Fy  ===>   y    = 1.;
   pvar
      x1 x2 x3 y = .02 .03 .15 .02;
   pcov
      x1 x2 = 0.01;
   mean
      x1-x3 y = 4 * 0.,
      Fy F1-F3;
run;

proc calis data=multiple nobs=37;
   lineqs
      Fy = alpha * Intercept + b1 * F1 + b2 * F2 + b3 * F3 + d,
      x1 = 0. * Intercept + 1 * F1 + e1,
      x2 = 0. * Intercept + 1 * F2 + e2,
      x3 = 0. * Intercept + 1 * F3 + e3,
       y = 0. * Intercept + 1 * Fy + ey;
    variance
       e1-e3 ey = .02 .03 .15 .02;
    cov
       e1 e2 = 0.01;
    mean
       F1-F3;
run;

