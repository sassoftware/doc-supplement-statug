/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX3                                             */
/*   TITLE: Example 3 for PROC LOGISTIC                         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          polytomous response data                            */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 3. Ordinal Logistic Regression
*****************************************************************/

/*
The data, taken from McCullagh and Nelder (1989, p.175), were derived from an
experiment concerned with the effect on taste of four cheese additives.  The
nine response categories range from strong dislike (1) to excellent taste
(9).  Let y be the response variable.  The variable Additive specifies the
cheese additive (1, 2, 3, or 4).  The data after the DATALINES statement are
arranged like a 2-way table of additive by rating; i.e., the rows are the
four additives and the columns are the nine levels of the rating scale.

The ODDSRATIO statement produces a plot of the odds ratios when ODS
Graphics is enabled, while the EFFECTPLOT statement displays the
model-predicted probabilities
*/

title 'Example 3. Ordinal Logistic Regression';

data Cheese;
   do Additive = 1 to 4;
      do y = 1 to 9;
         input freq @@;
         output;
      end;
   end;
   label y='Taste Rating';
   datalines;
0  0  1  7  8  8 19  8  1
6  9 12 11  7  6  1  0  0
1  1  6  8 23  7  5  1  0
0  0  0  1  3  7 14 16 11
;

ods graphics on;
proc logistic data=Cheese plots(only)=oddsratio(range=clip);
   freq freq;
   class Additive (param=ref ref='4');
   model y=Additive / covb nooddsratio;
   oddsratio Additive;
   effectplot / polybar;
   title 'Multiple Response Cheese Tasting Experiment';
run;

proc logistic data=Cheese
   plots(only)=effect(x=y sliceby=additive connect yrange=(0,0.4));
   freq freq;
   class Additive (param=ref ref='4');
   model y=Additive / nooddsratio link=alogit;
   oddsratio Additive;
   title 'Multiple Response Cheese Tasting Experiment';
run;

