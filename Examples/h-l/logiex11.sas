/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX11                                            */
/*   TITLE: Example 11 for PROC LOGISTIC                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          conditional logistic regression analysis,           */
/*          exact conditional logistic regression analysis,     */
/*          binomial response data,                             */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 11. Conditional Logistic Regression for Matched Pairs Data
****************************************************************/

/*
The data are a subset of data from the Los Angeles Study of the Endometrial
Cancer Data described in Breslow and Day (1980).  There are 63 matched pairs,
each consisting of a case of endometrial cancer (Outcome=1) and a control
(Outcome=0).  The case and the corresponding control have the same ID.  The
explanatory variables include Gall (an indicator for gall bladder disease)
and Hyper (an indicator for hypertension).  The goal of the analysis is to
determine the relative risk for gall bladder disease controlling for the
effect of hypertension.
*/

title 'Example 11. Conditional Logistic Regression for Matched Pairs';

data Data1;
   do ID=1 to 63;
      do Outcome = 1 to 0 by -1;
         input Gall Hyper @@;
         output;
      end;
   end;
   datalines;
0 0  0 0    0 0  0 0    0 1  0 1    0 0  1 0    1 0  0 1
0 1  0 0    1 0  0 0    1 1  0 1    0 0  0 0    0 0  0 0
1 0  0 0    0 0  0 1    1 0  0 1    1 0  1 0    1 0  0 1
0 1  0 0    0 0  1 1    0 0  1 1    0 0  0 1    0 1  0 0
0 0  1 1    0 1  0 1    0 1  0 0    0 0  0 0    0 0  0 0
0 0  0 1    1 0  0 1    0 0  0 1    1 0  0 0    0 1  0 0
0 1  0 0    0 1  0 0    0 1  0 0    0 0  0 0    1 1  1 1
0 0  0 1    0 1  0 0    0 1  0 1    0 1  0 1    0 1  0 0
0 0  0 0    0 1  1 0    0 0  0 1    0 0  0 0    1 0  0 0
0 0  0 0    1 1  0 0    0 1  0 0    0 0  0 0    0 1  0 1
0 0  0 0    0 1  0 1    0 1  0 0    0 1  0 0    1 0  0 0
0 0  0 0    1 1  1 0    0 0  0 0    0 0  0 0    1 1  0 0
1 0  1 0    0 1  0 0    1 0  0 0
;


/*
In the following SAS statements, PROC LOGISTIC is invoked with the ID
variable declared in the STRATA statement to obtain the conditional logistic
model estimates. The model contains Gall as the only predictor variable.
*/

proc logistic data=Data1;
   strata ID;
   model outcome(event='1')=Gall;
run;


/*
When you believe there is not enough data or that the data are too sparse,
you can perform a stratified exact conditional logistic regression.  The
following SAS statements perform exact conditional logistic regressions on
the original data set by specifying both the STRATA and EXACT statements.
*/

proc logistic data=Data1 exactonly;
   strata ID;
   model outcome(event='1')=Gall;
   exact Gall / estimate=both;
run;
