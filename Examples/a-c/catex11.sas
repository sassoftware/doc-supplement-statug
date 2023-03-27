/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CATEX11                                             */
/*   TITLE: Example 11 for PROC CATMOD                          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: categorical data analysis                           */
/*   PROCS: CATMOD                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC CATMOD chapter          */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*----------------------------------------------------------------
Example 11: Predicted Probabilities

             Scoring with Predicted Probabilities
             ------------------------------------
Made-up data to illustrate fitting a model, then obtaining the
predicted probabilities of each subpopulation; that is, 'scoring'
the input data set.
----------------------------------------------------------------*/

title 'Predicted Probabilities';

data loan;
   input Education $ Income $ Purchase $ wt;
   datalines;
high  high  yes    54
high  high  no     23
high  low   yes    41
high  low   no     12
low   high  yes    35
low   high  no     42
low   low   yes    19
low   low   no      8
;

ods output PredictedValues=Predicted (keep=Education Income PredFunction);
proc catmod data=loan order=data;
   weight wt;
   response marginals;
   model Purchase=Education Income / pred design;
run;

proc sort data=Predicted;
   by descending PredFunction;
run;
proc print data=Predicted;
run;

