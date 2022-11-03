/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ORTHOREX3                                           */
/*   TITLE: Example 3 for PROC ORTHOREG                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: regression analysis                                 */
/*   PROCS: ORTHOREG GLM                                        */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC ORTHOREG, EXAMPLE 3.                           */
/*    MISC:                                                     */
/****************************************************************/
/* Example 3: Fitting Polynomials ------------------------------*/
title 'Polynomial Data';
data Polynomial;
   do i = 1 to 101;
      x = (i-1)/(101-1);
      y = 10**(9/2);
      do j = 0 to 8;
         y = y * (x - j/8);
      end;
      output;
   end;
run;
ods graphics on;

proc orthoreg data=Polynomial;
   effect xMod = polynomial(x / degree=9);
   model y = xMod;
   effectplot fit / obs;
   store OStore;
run;

ods graphics off;
data Zeros(keep=x);
   do j = 0 to 8;
      x = j/8;
      output;
   end;
run;

proc plm restore=OStore noprint;
   score data=Zeros out=OZeros pred=OPred;
run;

proc print noobs;
run;
proc glm data=Polynomial;
   model y = x|x|x|x|x|x|x|x|x;
   store GStore;
run;
proc plm restore=GStore noprint;
   score data=Zeros out=GZeros pred=GPred;
run;

data Zeros;
   merge OZeros GZeros;
run;

proc print noobs;
run;
