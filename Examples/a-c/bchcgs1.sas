/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: BCHCGS1                                             */
/*   TITLE: Getting Started Example 1 for PROC BCHOICE          */
/*          A Simple Logit Model Example                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: BCHOICE                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC BCHOICE, GETTING STARTED EXAMPLE 1             */
/*    MISC:                                                     */
/****************************************************************/

title 'Conjoint Analysis of Chocolate Candies';

data Chocs;
   input Subj Choice Dark Soft Nuts;
   datalines;
1 0 0 0 0
1 0 0 0 1
1 0 0 1 0
1 0 0 1 1
1 1 1 0 0
1 0 1 0 1
1 0 1 1 0
1 0 1 1 1
2 0 0 0 0
2 0 0 0 1
2 0 0 1 0
2 0 0 1 1
2 0 1 0 0
2 1 1 0 1
2 0 1 1 0
2 0 1 1 1
3 0 0 0 0
3 0 0 0 1
3 0 0 1 0
3 0 0 1 1
3 0 1 0 0
3 0 1 0 1
3 1 1 1 0
3 0 1 1 1
4 0 0 0 0
4 0 0 0 1
4 0 0 1 0
4 0 0 1 1
4 1 1 0 0
4 0 1 0 1
4 0 1 1 0
4 0 1 1 1
5 0 0 0 0
5 1 0 0 1
5 0 0 1 0
5 0 0 1 1
5 0 1 0 0
5 0 1 0 1
5 0 1 1 0
5 0 1 1 1
6 0 0 0 0
6 0 0 0 1
6 0 0 1 0
6 0 0 1 1
6 0 1 0 0
6 1 1 0 1
6 0 1 1 0
6 0 1 1 1
7 0 0 0 0
7 1 0 0 1
7 0 0 1 0
7 0 0 1 1
7 0 1 0 0
7 0 1 0 1
7 0 1 1 0
7 0 1 1 1
8 0 0 0 0
8 0 0 0 1
8 0 0 1 0
8 0 0 1 1
8 0 1 0 0
8 1 1 0 1
8 0 1 1 0
8 0 1 1 1
9 0 0 0 0
9 0 0 0 1
9 0 0 1 0
9 0 0 1 1
9 0 1 0 0
9 1 1 0 1
9 0 1 1 0
9 0 1 1 1
10 0 0 0 0
10 0 0 0 1
10 0 0 1 0
10 0 0 1 1
10 0 1 0 0
10 1 1 0 1
10 0 1 1 0
10 0 1 1 1
;

proc print data=Chocs (obs=16);
run;

ods graphics on;
proc bchoice data=Chocs outpost=Bsamp nmc=10000 thin=2 diag=(AutoCorr
     ESS MCSE) seed=124;
   class Dark(ref='0') Soft(ref='0') Nuts(ref='0') Subj;
   model Choice = Dark Soft Nuts / choiceset=(Subj) cprior=normal(var=1000);
run;
