/******************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                   */
/*                                                                */
/*    NAME: NESTEX1                                               */
/*   TITLE: Example 1 for PROC NESTED                             */
/*          Variability of Calcium Concentration in Turnip Greens */
/* PRODUCT: STAT                                                  */
/*  SYSTEM: ALL                                                   */
/*    KEYS: Variability                                           */
/*   PROCS: NESTED                                                */
/*    DATA:                                                       */
/*                                                                */
/*     REF: PROC NESTED, EXAMPLE 1.                               */
/*    MISC:                                                       */
/******************************************************************/

title 'Calcium Concentration in Turnip Leaves--Nested Random Model';
title2 'Snedecor and Cochran, ''Statistical Methods'', 1967, p. 286';
data Turnip;
   do Plant=1 to 4;
      do Leaf=1 to 3;
         do Sample=1 to 2;
            input Calcium @@;
            output;
         end;
      end;
   end;
   datalines;
3.28 3.09 3.52 3.48 2.88 2.80 2.46 2.44
1.87 1.92 2.19 2.19 2.77 2.66 3.74 3.44
2.55 2.55 3.78 3.87 4.07 4.12 3.31 3.31
;

proc nested data=Turnip;
   class plant leaf;
   var calcium;
run;
