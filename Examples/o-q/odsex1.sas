/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSEX1                                              */
/*   TITLE: Documentation Example 1 for ODS                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS                                                 */
/*   PROCS: TTEST                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: Using the Output Delivery System                    */
/*    MISC:                                                     */
/****************************************************************/

title 'Comparing Group Means';

data Scores;
   input Gender $ Score @@;
   datalines;
f 75  f 76  f 80  f 77  f 80  f 77  f 73
m 82  m 80  m 85  m 85  m 78  m 87  m 82
;

*
ods html body='ttest.htm' style=HTMLBlue;

proc ttest;
   class Gender;
   var Score;
run;

*
ods html close;

/*
ods _all_ close;
ods html body='ttest.htm' contents='ttestc.htm' frame='ttestf.htm'
         style=HTMLBlue;
ods graphics on;
*/

proc ttest;
   class Gender;
   var Score;
run;

/*
ods html close;
ods html;
ods pdf;
*/
