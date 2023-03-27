/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MIXGS1                                              */
/*   TITLE: Getting Started Example for PROC MIXED              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Mixed Linear Models                                 */
/*   PROCS: MIXED                                               */
/*    DATA:                                                     */
/*                                                              */
/* SUPPORT: Tianlin Wang                                        */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data heights;
   input Family Gender$ Height @@;
   datalines;
1 F 67   1 F 66   1 F 64   1 M 71   1 M 72   2 F 63
2 F 63   2 F 67   2 M 69   2 M 68   2 M 70   3 F 63
3 M 64   4 F 67   4 F 66   4 M 67   4 M 67   4 M 69
;

proc mixed data=heights;
   class Family Gender;
   model Height = Gender Family Family*Gender;
run;

proc mixed;
   class Family Gender;
   model Height = Gender;
   random Family Family*Gender;
run;

