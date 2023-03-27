/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ttegs2                                              */
/*   TITLE: Getting Started Example 2 for PROC TTEST            */
/*          (Comparing Group Means)                             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: two-sample t test                                   */
/*          graphs                                              */
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

proc ttest cochran ci=equal umpu;
   class Gender;
   var Score;
run;

ods graphics off;

