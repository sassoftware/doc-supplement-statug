/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX12                                            */
/*   TITLE: Example 12 for PROC LOGISTIC                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          exact conditional logistic regression analysis,     */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 12. Exact Conditional Logistic Regression
****************************************************************/

/* Exact conditional logistic regression is a method that
addresses issues of separability and small sample sizes.

This example from Hand (1994) uses exact conditional logistic
regression to analyze a data set that has quasi-complete
separation.  The resulting exact parameter estimates are used to
predict the success probabilities of the subjects.*/

title 'Example 12. Exact Conditional Logistic Regression';

data one;
   length Diagnosis $ 9;
   input Diagnosis $ Friendships $ Recovered Total @@;
   datalines;
Anxious   Poor 0 0    Anxious   Good 13 21
Depressed Poor 0 8    Depressed Good 15 20
;

proc logistic data=one;
   class Diagnosis Friendships / param=ref;
   model Recovered/Total = Diagnosis Friendships;
run;

proc logistic data=one exactonly;
   class Diagnosis Friendships / param=ref;
   model Recovered/Total = Diagnosis Friendships;
   exact Diagnosis Friendships
       / outdist=dist joint estimate;
run;

proc print data=dist(obs=10);
run;

proc print data=dist(firstobs=162 obs=175);
run;

proc print data=dist(firstobs=176 obs=184);
run;

proc logistic data=one exactonly outest=est;
   class Diagnosis Friendships / param=ref;
   model Recovered/Total = Diagnosis Friendships;
   exact Intercept Diagnosis Friendships / estimate;
run;
proc means data=est noprint;
   output out=out;
run;
data out; set out; if _STAT_='MEAN'; drop _TYPE_; run;
data est(type=est); set out; _TYPE_='PARMS'; run;

proc logistic data=one inest=est;
   class Diagnosis Friendships / param=ref;
   model Recovered/Total = Diagnosis Friendships / maxiter=0;
   score out=score;
run;

proc print data=score;
   var Diagnosis Friendships P_Event;
run;
