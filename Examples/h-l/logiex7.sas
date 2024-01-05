/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX7                                             */
/*   TITLE: Example 7 for PROC LOGISTIC                         */
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
Example 7. ROC Curve, Customized Odds Ratios, Goodness-of-Fit
Statistics, R-Square and Confidence Limits
*****************************************************************/

/*
This example plots an ROC curve, estimates a customized odds ratio, produces
the traditional goodness-of-fit analysis, prints the generalized R^2 measures
for the fitted model, and calculates the normal confidence intervals for the
regression parameters.

The data consist of three variables: N (number of subjects in a sample),
DISEASE (number of diseased subjects in the sample), and AGE (age for the
sample).  A linear logistic regression model is fit to study the effect of
age on the probability of contracting the disease.

Finally, ODS Graphics and the PLOTS= option are used
to plot the ROC curve, and the EFFECTPLOT statement displays the
model-predicted probabilities.*/

title 'Example 7: ROC Curve, R-Square, ...';

data Data1;
   input disease n age id $;
   datalines;
 0 14 25 a
 0 20 35 b
 0 19 45 c
 7 18 55 d
 6 12 65 e
17 17 75 f
;

ods graphics on;
%let _ROC_XAXISOPTS_LABEL=False Positive Fraction;
%let _ROC_YAXISOPTS_LABEL=True Positive Fraction;
proc logistic data=Data1 plots(only)=roc(id=id);
   model disease/n=age / scale=none
                         clparm=wald
                         clodds=pl
                         rsquare;
   units age=10;
   id id;
   effectplot;
run;

proc logistic data=Data1 plots(only)=oddsratio;
   effect polyAge=polynomial(Age / degree=2);
   model disease/n=polyAge;
   oddsratio Age;
run;

