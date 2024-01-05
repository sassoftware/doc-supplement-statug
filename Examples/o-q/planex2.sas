/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: planex2                                             */
/*   TITLE: Example 2 for PROC PLAN                             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: heirarchical design                                 */
/*   PROCS: PLAN                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC PLAN, EXAMPLE 2.                               */
/*    MISC:                                                     */
/****************************************************************/


/* A hierarchical design ---------------------------------------*/

title 'Hierarchical Design';
proc plan seed=17431;
   factors Houses=3 Pots=4 Plants=3 / noprint;
   output out=nested;
run;

proc print data=nested;
run;

