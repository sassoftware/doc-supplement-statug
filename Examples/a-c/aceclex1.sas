/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ACECLEX1                                            */
/*   TITLE: Documentation Example for PROC ACECLUS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multivariate analysis, cluster analysis             */
/*   PROCS: ACECLUS                                             */
/*    DATA: FISHER (1936) IRIS DATA - SASHELP.IRIS              */
/*                                                              */
/*     REF: PROC ACECLUS, Example 1                             */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

title 'Fisher (1936) Iris Data';

proc aceclus data=sashelp.iris out=ace p=.02 outstat=score;
   var SepalLength SepalWidth PetalLength PetalWidth ;
run;

proc sgplot data=ace;
   scatter y=can2 x=can1 / group=Species;
   keylegend / title="Species";
run;

proc fastclus data=ace maxc=3 maxiter=10 conv=0 out=clus;
   var can:;
run;

proc freq;
   tables cluster*Species;
run;

