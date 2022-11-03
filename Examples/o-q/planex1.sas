/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PLANEX1                                             */
/*   TITLE: Example 1 for PROC PLAN                             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: split-plot design                                   */
/*   PROCS: PLAN                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC PLAN, EXAMPLE 1.                               */
/*    MISC:                                                     */
/****************************************************************/

/* A split-plot design -----------------------------------------*/

title 'Split Plot Design';
proc plan seed=37277;
   factors Block=3 ordered a=4 b=2;
run;
