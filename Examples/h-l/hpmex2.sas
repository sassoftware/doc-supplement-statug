/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: HPMEX2                                              */
/*   TITLE: Example 2 for PROC HPMIXED                          */
/*          Comparing Results from PROC HPMIXED and PROC MIXED  */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: mixed model analysis                                */
/*   PROCS: HPMIXED                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC HPMIXED, EXAMPLE 2.                            */
/*    MISC:                                                     */
/****************************************************************/
data heights;
   input Family Gender$ Height @@;
   datalines;
1 F 67   1 F 66   1 F 64   1 M 71   1 M 72   2 F 63
2 F 63   2 F 67   2 M 69   2 M 68   2 M 70   3 F 63
3 M 64   4 F 67   4 F 66   4 M 67   4 M 67   4 M 69
;
proc mixed;
   class Family Gender;
   model Height = Gender / s;
   random Family Family*Gender / s;
run;
proc hpmixed;
   class Family Gender;
   model Height = Gender / s;
   random Family Family*Gender / s;
   test gender;
run;
