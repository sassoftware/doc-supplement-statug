/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX09                                             */
/*   TITLE: Documentation Example 27 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: confirmatory factor model, dependent parameters     */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 27                              */
/*    MISC:                                                     */
/****************************************************************/

data kinzer(type=corr);
title "Data Matrix of Kinzer & Kinzer, see GUTTMAN (1957)";
   _type_ = 'corr';
   input _name_ $ var1-var6;
   datalines;
var1  1.00   .     .     .     .     .
var2   .51  1.00   .     .     .     .
var3   .46   .51  1.00   .     .     .
var4   .46   .47   .54  1.00   .     .
var5   .40   .39   .49   .57  1.00   .
var6   .33   .39   .47   .45   .56  1.00
;

proc calis data=kinzer nobs=326 nose;
   factor
      factor1 ===> var1-var6   = b11 b21 b31 b41 b51 b61 (6 *.6),
      factor2 ===> var1-var6   = b12 b22 b32 b42 b52 b62;
   pvar
      factor1-factor2 = 2 * 1.,
      var1-var6       = psi1-psi6 (6 *.3);
   cov
      factor1 factor2 = 0.;
   parameters alpha (1.);
   /* SAS Programming Statements to define dependent parameters */
   b12 = alpha - b11;
   b22 = alpha - b21;
   b32 = alpha - b31;
   b42 = alpha - b41;
   b52 = alpha - b51;
   b62 = alpha - b61;
   fitindex on(only)=[chisq df probchi];
run;

proc calis data=Kinzer nobs=326 nose;
   factor
      factor1 ===> var1-var6   = t11 t21 t31 t41 t51 t61,
      factor2 ===> var1-var6   = t12 t22 t32 t42 t52 t62;
   pvar
      factor1-factor2 = 2 * 1.,
      var1-var6       = k1-k6;
   cov
      factor1 factor2 = 0.;
   parameters alpha (1.) d1-d6 (6 * 1.)
              b11 b21 b31 b41 b51 b61 (6 *.6),
              b12 b22 b32 b42 b52 b62
              psi1-psi6;
   /* SAS Programming Statements */
   /* 12 Constraints on Correlation structures */
   b12  = alpha - b11;
   b22  = alpha - b21;
   b32  = alpha - b31;
   b42  = alpha - b41;
   b52  = alpha - b51;
   b62  = alpha - b61;
   psi1 = 1. - b11 * b11 - b12 * b12;
   psi2 = 1. - b21 * b21 - b22 * b22;
   psi3 = 1. - b31 * b31 - b32 * b32;
   psi4 = 1. - b41 * b41 - b42 * b42;
   psi5 = 1. - b51 * b51 - b52 * b52;
   psi6 = 1. - b61 * b61 - b62 * b62;
   /* Defining Covariance Structure Parameters */
   t11  = d1 * b11;
   t21  = d2 * b21;
   t31  = d3 * b31;
   t41  = d4 * b41;
   t51  = d5 * b51;
   t61  = d6 * b61;
   t12  = d1 * b12;
   t22  = d2 * b22;
   t32  = d3 * b32;
   t42  = d4 * b42;
   t52  = d5 * b52;
   t62  = d6 * b62;
   k1   = d1 * d1 * psi1;
   k2   = d2 * d2 * psi2;
   k3   = d3 * d3 * psi3;
   k4   = d4 * d4 * psi4;
   k5   = d5 * d5 * psi5;
   k6   = d6 * d6 * psi6;
   fitindex on(only)=[chisq df probchi];
run;

