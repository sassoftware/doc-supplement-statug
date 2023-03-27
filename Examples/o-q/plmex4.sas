/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: plmex4                                              */
/*   TITLE: Example 4 for PROC PLM                              */
/*    DESC: cow, electrical shocks                              */
/*     REF: Weisberg, S. Applied Linear Regression 1985         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: GENMOD,PLM                                          */
/*                                                              */
/****************************************************************/

data cow;
   input current response trial experiment;
   datalines;
0  0 35 1
0  0 35 2
1  6 35 1
1  3 35 2
2 13 35 1
2  8 35 2
3 26 35 1
3 21 35 2
4 33 35 1
4 27 35 2
5 34 35 1
5 29 35 2
;

data prior;
   input _type_$ current;
   datalines;
mean 100
var   50
;

proc genmod data=cow;
   class experiment;
   bayes coeffprior=normal(input=prior) seed=1;
   model response/trial = current|experiment / dist=binomial;
   store cowgmd;
   title 'Bayesian Logistic Model on Cow';
run;

proc plm restore=cowgmd;
   estimate
   'Diff at current 0' experiment 1 -1 current*experiment [1, 0 1] [-1, 0 2],
   'Diff at current 1' experiment 1 -1 current*experiment [1, 1 1] [-1, 1 2],
   'Diff at current 2' experiment 1 -1 current*experiment [1, 2 1] [-1, 2 2],
   'Diff at current 3' experiment 1 -1 current*experiment [1, 3 1] [-1, 3 2],
   'Diff at current 4' experiment 1 -1 current*experiment [1, 4 1] [-1, 4 2],
   'Diff at current 5' experiment 1 -1 current*experiment [1, 5 1] [-1, 5 2]
    / exp cl;
run;

ods graphics on;
proc plm restore=cowgmd;
   estimate
   'Diff at current 0' experiment 1 -1 current*experiment [1, 0 1] [-1, 0 2],
   'Diff at current 1' experiment 1 -1 current*experiment [1, 1 1] [-1, 1 2],
   'Diff at current 2' experiment 1 -1 current*experiment [1, 2 1] [-1, 2 2],
   'Diff at current 3' experiment 1 -1 current*experiment [1, 3 1] [-1, 3 2],
   'Diff at current 4' experiment 1 -1 current*experiment [1, 4 1] [-1, 4 2],
   'Diff at current 5' experiment 1 -1 current*experiment [1, 5 1] [-1, 5 2]
    / plots=boxplot(orient=horizontal);
run;
ods graphics off;

