/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PLANEX6                                             */
/*   TITLE: Example 6 for PROC PLAN                             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: permutations, combinations                          */
/*   PROCS: PLAN                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC PLAN, EXAMPLE 6.                               */
/*    MISC:                                                     */
/****************************************************************/

/* Permutations and combinations -------------------------------*/
title 'All Permutations of 1,2,3,4';
proc plan seed=60359;
   factors    Subject  = 24
              Order    = 4  ordered;
   treatments Stimulus = 4  perm;
   output out=Psych;
run;
proc sort data=Psych out=Psych;
   by Subject Order;
run;
proc transpose data= Psych(rename=(Order=_NAME_))
               out =tPsych(drop=_NAME_);
   by Subject;
   var Stimulus;
run;
proc print data=tPsych noobs;
run;
title 'All Combinations of (6 Choose 4) Integers';
proc plan;
   factors Block=15 ordered
           Treat= 4 of 6 comb;
   ods output Plan=Combinations;
run;
proc print data=Combinations noobs;
run;
