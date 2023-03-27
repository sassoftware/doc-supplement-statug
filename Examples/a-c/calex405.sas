/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX405                                            */
/*   TITLE: Documentation Example 32 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: factor analysis, ordinal constraints, COSAN         */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 32                              */
/*    MISC:                                                     */
/****************************************************************/

Data Kinzer(TYPE=CORR);
Title "Data Matrix of Kinzer & Kinzer, see GUTTMAN (1957)";
   _TYPE_ = 'CORR'; INPUT _NAME_ $ var1-var6;
   Datalines;
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
      [ ,1]= b11 b21 b31 b41 b51 b61,
      [ ,2]= 0.  b22 b32 b42 b52 b62;
   matrix Psi
      [1,1]= psi1-psi6;
   matrix D
      [1,1]= d1-d6 ;
   lincon
      b61  <= b51,
      b51  <= b41,
      b41  <= b31,
      b31  <= b21,
      b21  <= b11,
       0.  <= b22,
      b22  <= b32,
      b32  <= b42,
      b42  <= b52,
      b52  <= b62;

   /* SAS Programming Statements */
   /* 6 Constraints on Correlation structures */
   psi1 = 1. - b11 * b11;
   psi2 = 1. - b21 * b21 - b22 * b22;
   psi3 = 1. - b31 * b31 - b32 * b32;
   psi4 = 1. - b41 * b41 - b42 * b42;
   psi5 = 1. - b51 * b51 - b52 * b52;
   psi6 = 1. - b61 * b61 - b62 * b62;
   vnames
       B   = [factor1 factor2],
       Psi = [var1-var6],
       D   = Psi;
run;

