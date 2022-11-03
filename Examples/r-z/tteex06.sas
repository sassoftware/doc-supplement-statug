/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: tteex06                                             */
/*   TITLE: Documentation Example 6 for PROC TTEST              */
/*          (Bootstrap)                                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: two-sample t test                                   */
/*   PROCS: TTEST                                               */
/*    DATA: Golf scores by gender                               */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data scores;
   input Gender $ Score @@;
   datalines;
f 75  f 76  f 80  f 77  f 80  f 77  f 73
m 82  m 80  m 85  m 85  m 78  m 87  m 82
;

ods graphics on;

proc ttest ci=equal umpu plots=bootstrap(interval);
   class Gender;
   var Score;
   bootstrap / seed=837;
run;

proc ttest plots(only)=bootstrap(interval);
   class Gender;
   var Score;
   bootstrap / seed=810 bootci=percentile;
run;

proc ttest plots(only)=bootstrap(interval);
   class Gender;
   var Score;
   bootstrap / seed=249 bootci=expandedperc;
run;

ods graphics off;
