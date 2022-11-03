/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: VARCEX1                                             */
/*   TITLE: Example 1 for PROC VARCOMP                          */
/*          Using the Four General Estimation Methods           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Estimation method                                   */
/*          Type1 estimate, REML estimate, ML estimate          */
/*   PROCS: VARCOMP                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC VARCOMP, EXAMPLE 1.                            */
/*    MISC:                                                     */
/****************************************************************/
data a;
   input a b y @@;
   datalines;
1 1 237   1 1 254   1 1 246   1 2 178   1 2 179
2 1 208   2 1 178   2 1 187   2 2 146   2 2 145   2 2 141
3 1 186   3 1 183   3 2 142   3 2 125   3 2 136
;
proc varcomp method=type1 data=a;
   class a b;
   model y=a|b / fixed=1;
run;
proc varcomp method=mivque0 data=a;
   class a b;
   model y=a|b / fixed=1;
run;
proc varcomp method=ml data=a;
   class a b;
   model y=a|b / fixed=1;
run;
proc varcomp method=reml data=a;
   class a b;
   model y=a|b / fixed=1;
run;
