/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX6                                             */
/*   TITLE: Example 6 for PROC LOGISTIC                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 6. Logistic Regression Diagnostics
*****************************************************************/

/*
Finney( 1947) lists data on a controlled experiment to study the effect of
the rate and volume of air on a transient reflex vasoconstriction in the
skin of the digits. 39 tests under various combinations of rate and volume of
air inspired were obtained.  The end point of each test is whether or not
vasoconstriction occurred.  Pregibon (1981) uses this set of data to
illustrate the diagnostic measures he proposes for detecting influential
observations and in quantifying their effects on various aspects of the
maximum likelihood fit.

The variable Response represents the outcome of the test.  PROC LOGISTIC is
invoked to fit a logistic regression model to the vasoconstriction data.
The INFLUENCE option is specified to display the regression diagnostics.
*/

title 'Example 6. Logistic Regression Diagnostics';

data vaso;
   length Response $12;
   input Volume Rate Response @@;
   LogVolume=log(Volume);
   LogRate=log(Rate);
   datalines;
3.70  0.825  constrict       3.50  1.09   constrict
1.25  2.50   constrict       0.75  1.50   constrict
0.80  3.20   constrict       0.70  3.50   constrict
0.60  0.75   no_constrict    1.10  1.70   no_constrict
0.90  0.75   no_constrict    0.90  0.45   no_constrict
0.80  0.57   no_constrict    0.55  2.75   no_constrict
0.60  3.00   no_constrict    1.40  2.33   constrict
0.75  3.75   constrict       2.30  1.64   constrict
3.20  1.60   constrict       0.85  1.415  constrict
1.70  1.06   no_constrict    1.80  1.80   constrict
0.40  2.00   no_constrict    0.95  1.36   no_constrict
1.35  1.35   no_constrict    1.50  1.36   no_constrict
1.60  1.78   constrict       0.60  1.50   no_constrict
1.80  1.50   constrict       0.95  1.90   no_constrict
1.90  0.95   constrict       1.60  0.40   no_constrict
2.70  0.75   constrict       2.35  0.03   no_constrict
1.10  1.83   no_constrict    1.10  2.20   constrict
1.20  2.00   constrict       0.80  3.33   constrict
0.95  1.90   no_constrict    0.75  1.90   no_constrict
1.30  1.625  constrict
;

ods graphics on;
title 'Occurrence of Vasoconstriction';
proc logistic data=vaso;
   model Response=LogRate LogVolume/influence;
run;

proc logistic data=vaso plots(only label)=(phat leverage dpc);
   model Response=LogRate LogVolume;
run;
