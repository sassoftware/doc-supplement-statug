/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIINTR                                            */
/*   TITLE: Getting Started Example for PROC LOGISTIC           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data                              */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Introductory Example.
*****************************************************************/

/*
The data, taken from Cox and Snell (1989, pp 10-11), consists of the number,
r, of ingots not ready for rolling, out of n tested, for a number of
combinations of heating time and soaking time.  PROC LOGISTIC is invoked to
fit the binary logit model to the grouped data.

The ODDSRATIO statement computes odds ratios even though the main effects are
involved in an interaction.  Because Heat interacts with Soak, the odds
ratio for Heat depend on the value of Soak.  ODS Graphics is used to
display a plot of these odds ratios.
*/

title 'Introductory Example';

data ingots;
   input Heat Soak r n @@;
   datalines;
7 1.0 0 10  14 1.0 0 31  27 1.0 1 56  51 1.0 3 13
7 1.7 0 17  14 1.7 0 43  27 1.7 4 44  51 1.7 0  1
7 2.2 0  7  14 2.2 2 33  27 2.2 0 21  51 2.2 0  1
7 2.8 0 12  14 2.8 0 31  27 2.8 1 22  51 4.0 0  1
7 4.0 0  9  14 4.0 0 19  27 4.0 1 16
;

ods graphics on;
proc logistic data=ingots;
   model r/n = Heat | Soak;
   oddsratio Heat / at(Soak=1 2 3 4);
run;


/*
Since the Heat*Soak interaction is nonsignificant, the following statements
fit a main-effects model:
*/

proc logistic data=ingots;
   model r/n = Heat Soak;
run;


/*
To illustrate the use of an alternative form of input data, the following
DATA step creates the INGOTS data set with new variables NotReady and Freq
instead of n and r.  The variable NotReady represents the response of an
individual unit; it has a value of 1 for units not ready for rolling (event)
and a value of 0 for units ready for rolling (nonevent).  The variable Freq
represents the frequency of occurrence of each combination of Heat, Soak, and
NotReady.  Note that, compared to the previous data set, NotReady=1 implies
Freq=r, and NotReady=0 implies Freq=n-r.
*/

data ingots;
   input Heat Soak NotReady Freq @@;
   datalines;
7 1.0 0 10  14 1.0 0 31  14 4.0 0 19  27 2.2 0 21  51 1.0 1  3
7 1.7 0 17  14 1.7 0 43  27 1.0 1  1  27 2.8 1  1  51 1.0 0 10
7 2.2 0  7  14 2.2 1  2  27 1.0 0 55  27 2.8 0 21  51 1.7 0  1
7 2.8 0 12  14 2.2 0 31  27 1.7 1  4  27 4.0 1  1  51 2.2 0  1
7 4.0 0  9  14 2.8 0 31  27 1.7 0 40  27 4.0 0 15  51 4.0 0  1
;

proc logistic data=ingots;
   model NotReady(event='1') = Heat Soak;
   freq Freq;
run;
