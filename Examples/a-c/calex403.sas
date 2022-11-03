/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX403                                            */
/*   TITLE: Documentation Example 31 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: factor analysis, constraints, COSAN                 */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 31                              */
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

proc calis data=Kinzer nobs=326 nose;
   cosan
      var= var1-var6,
      D(6,DIA) * B(2,GEN) + D(6,DIA) * Psi(6,DIA);
   matrix B
      [ ,1] = b11 b21 b31 b41 b51 b61,
      [ ,2] = b12 b22 b32 b42 b52 b62;
   matrix Psi
      [1,1] = psi1-psi6;
   matrix D
      [1,1] = d1-d6;
   parameters alpha (1.);

   /* SAS Programming Statements to Define Dependent Parameters*/
   /* 6 constraints on the factor loadings */
   b12  = alpha - b11;
   b22  = alpha - b21;
   b32  = alpha - b31;
   b42  = alpha - b41;
   b52  = alpha - b51;
   b62  = alpha - b61;

   /* 6 Constraints on Correlation structures */
   psi1 = 1. - b11 * b11 - b12 * b12;
   psi2 = 1. - b21 * b21 - b22 * b22;
   psi3 = 1. - b31 * b31 - b32 * b32;
   psi4 = 1. - b41 * b41 - b42 * b42;
   psi5 = 1. - b51 * b51 - b52 * b52;
   psi6 = 1. - b61 * b61 - b62 * b62;
   vnames
      D   = [var1-var6],
      B   = [factor1 factor2],
      Psi = D;
run;
