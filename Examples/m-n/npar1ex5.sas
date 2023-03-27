/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: NPAR1EX5                                            */
/*   TITLE: Documentation Example 5 for PROC NPAR1WAY           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: nonparametric methods, categorical data analysis,   */
/*    KEYS: multisample Savage test, exact tests                */
/*   PROCS: NPAR1WAY                                            */
/*     REF: PROC NPAR1WAY, Example 5                            */
/****************************************************************/

data Mice;
   input Treatment $ Days @@;
   datalines;
1 1 1 1 1 3 1 3 1 4
2 3 2 4 2 4 2 4 2 15
3 4 3 4 3 10 3 10 3 26
;

proc npar1way savage data=Mice;
   class Treatment;
   var Days;
   exact savage;
run;

