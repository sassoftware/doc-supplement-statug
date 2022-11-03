/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: pwrex10                                             */
/*   TITLE: Documentation Example 10 for PROC POWER             */
/*          (Wilcoxon-Mann-Whitney Test)                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: power                                               */
/*          sample size                                         */
/*          power analysis                                      */
/*          rank-sum                                            */
/*          Mann-Whitney U                                      */
/*          graphs                                              */
/*   PROCS: POWER                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

ods graphics on;

proc power;
   twosamplewilcoxon
      vardist("lidocaine") = ordinal ((-3 -2 -1 0 1 2 3) :
                                      (.01 .04 .20 .50 .20 .04 .01))
      vardist("Mir+lido") = ordinal ((-3 -2 -1 0 1 2 3) :
                                      (.01 .03 .15 .35 .30 .10 .06))
      variables = "lidocaine" | "Mir+lido"
      sides = u
      ntotal = 100 250
      power = .;
   plot step=10;
run;

ods graphics off;
