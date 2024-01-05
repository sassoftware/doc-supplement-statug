/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: modecex5                                            */
/*   TITLE: Documentation Example 5 for PROC MODECLUS           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Cluster Analysis                                    */
/*   PROCS: MODECLUS, SGPLOT                                    */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MODECLUS, Example 5                            */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data test;
   input x @@;
   datalines;
1 2 3 4 5 7.5 9 11.5 13 14.5 15 16
;

/*-- METHOD=6 with TRACE and THRESHOLD=0.5 (default) --*/
title 'METHOD=6 with TRACE and THRESHOLD=0.5 (default)';

proc modeclus data=test method=6 r=2.5 trace short out=out;
   var x;
run;

title2 'Plot of DENSITY*X=CLUSTER';

proc sgplot data=out;
   scatter y=density x=x / group=cluster datalabel=_obs_;
run;


/*-- METHOD=6 with TRACE and THRESHOLD=0.55 --*/
title 'METHOD=6 with TRACE and THRESHOLD=0.55';

proc modeclus data=test method=6 r=2.5 trace threshold=0.55 short out=out;
   var x;
run;

title2 'Plot of DENSITY*X=CLUSTER with TRACE and THRESHOLD=0.55';

proc sgplot data=out;
   scatter y=density x=x / group=cluster datalabel=_obs_;
run;

