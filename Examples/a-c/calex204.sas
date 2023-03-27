/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX204                                            */
/*   TITLE: Documentation Example 10 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: PATH, measurement error models, multiple predictors */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 10                              */
/*    MISC:                                                     */
/****************************************************************/

data pg214(type=cov);
   input _type_ $ 1-4  _name_ $ 6-8 @10 y x1 x2 x3;
   datalines;
mean     1.1349 1.5070 1.9214 3.5020
cov  y   1.2129 1.2059 0.2465 4.3714
cov  x1  1.2059 1.2706 0.1633 4.4813
cov  x2  0.2465 0.1633 1.1227 0.6250
cov  x3  4.3714 4.4813 0.6250 16.6909
;

/* Path Model */
title2 'Wayne Fuller''s Original Measurement Error Model: Page 214-215';
proc calis data=pg214 method=ml nobs=43;
   path
      Fy  <===   F1 F2 F3,
      F1  ===>   x1   = 1.,
      F2  ===>   x2   = 1.,
      F3  ===>   x3   = 1.,
      Fy  ===>   y    = 1.;
   pvar
      x1-x3 y = .01 .01 .1403 .01;
   pcov
      x1 x3 = 0.0301;
   mean
      x1-x3 y = 4 * 0.,
      F1-F3 Fy;
run;

/* Lineqs Model */
proc calis data=pg214 method=ml nobs=43;
   lineqs
      Fy = alpha * Intercept + b1 * F1 + b2 * F2 + b3 * F3 + DFy,
      x1 = 0. * Intercept + 1 * F1 + e1,
      x2 = 0. * Intercept + 1 * F2 + e2,
      x3 = 0. * Intercept + 1 * F3 + e3,
       y = 0. * Intercept + 1 * Fy + ey;
    variance
       e1-e3 ey = .01 .01 .1403 .01;
    cov
       e1 e3 = 0.0301;
    mean
       F1-F3;
run;

data multiple(type=cov);
   input _type_ $ 1-4  _name_ $ 6-8 @10 y x1 x2 x3;
   datalines;
mean     0.93   1.33   1.34   4.11
cov  y   1.31    .      .      .
cov  x1  1.24   1.42    .      .
cov  x2  0.21   0.18   1.15    .
cov  x3  3.91   4.21   0.58  14.11
;

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

