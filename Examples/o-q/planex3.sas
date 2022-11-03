/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PLANEX3                                             */
/*   TITLE: Example 3 for PROC PLAN                             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: block design, incomplete block design, BIBD         */
/*   PROCS: PLAN                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC PLAN, EXAMPLE 3.                               */
/*    MISC:                                                     */
/****************************************************************/

/* An incomplete block design ----------------------------------*/
title 'Generalized Cyclic Block Design';
proc plan seed=33373;
   factors Block=13 Plot=8;
   treatments Treatment=8 of 52 cyclic (1 2 3 4 32 43 46 49) 4;
   output out=GCBD;
quit;
proc sort data=GCBD out=GCBD;
   by Block Plot;
run;
proc transpose data= GCBD(rename=(Plot=_NAME_))
               out =tGCBD(drop=_NAME_);
   by Block;
   var Treatment;
run;
proc print data=tGCBD noobs;
run;
