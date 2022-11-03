/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX15                                            */
/*   TITLE: Example 15 for PROC LOGISTIC                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binomial response data,                             */
/*          CLOGLOG link                                        */
/*   PROCS: LOGISTIC                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 15. Complementary Log-Log Model for Interval-Censored Survival Times
*****************************************************************/

/*
Often survival times are not observed more precisely than the interval (for
instance, a day) within which the event occurred.  Survival data of this form
are known as grouped or interval- censored data.  A discrete analogue of the
continuous proportional hazards model (Prentice and Gloeckler 1978; Allison
1982) is used to investigate the relationship between these survival times
and a set of explanatory variables.

As a example of this method. consider a study of the effect of insecticide on
flour beetles.  Four different concentrations of an insecticide were sprayed
on separate groups of flour beetles and the numbers of male and female
flour beetles dying in successive intervals are recorded.  The data are saved
in data set BEETLES below.  This data set contains four variables: TIME, SEX,
CONC, and FREQ.  TIME represents the interval death time; for example, TIME=2
is the interval between day 1 and day 2.  Insects surviving the duration (13
days) of the experiment are given a TIME value of 14.  The variable SEX
represents the sex of the insect (1=male, 2=female), CONC represents the
concentration of the insecticide (mg/cm^2), and FREQ represents the frequency
of the observations.

To use PROC LOGISTIC with the grouped survival data, you must expand the data
so that each beetle has a separate record for each day of survival. A beetle
that died in the third day (time=3) would contribute three observations to
the analysis, one for each day it was alive at the beginning of the day. A
beetle that survives the 13-day duration of the experiment (time=14) would
contribute 13 observations.

A new data set DAYS that contains the beetle-day observations is created from
the data set BEETLES. In addition to the variables SEX, CONC and FREQ, the
data set contains an outcome variable Y and the variable DAY taking the
values 1,...,13.  Y has a value of 1 if the observation corresponds to the
day that the beetle died and has a value of 0 otherwise.

PROC LOGISTIC is invoked to fit a complementary log-log model for binary data
with response variable Y and explanatory variables DAY, SEX, and CONC. Since
the values of Y are coded 0 and 1, specifying the DESCENDING option ensures
that the event (y=1) probability is modeled. The DAY variable is specified
with the GLM coding, which adds a parameter to the model for each of
DAY=1,...,13.  The coefficients of these 13 DAY parameters can be used to
estimate the baseline survival function. The NOINT option is specified to
prevent any redundancy in estimating the coefficients of the DAY effects. The
Newton-Raphson algorithm is used for the maximum likelihood estimation of the
parameters.

Finally, DATA step code is used to compute the survivor curves for
male and female flour beetles exposed to the insecticide of
concentrations .20 mg/cm2 and .80 mg/cm2. The SGPLOT procedure is
used to plot the survival curves. Instead of plotting them as step
functions, the PBSPLINE statement is used to smooth the curves.
*/

title 'Example 15: CLOGLOG Model for Interval-Censored Survival Times';

data Beetles(keep=time sex conc freq);
   input time m20 f20 m32 f32 m50 f50 m80 f80;
   conc=.20; freq= m20; sex=1; output;
             freq= f20; sex=2; output;
   conc=.32; freq= m32; sex=1; output;
             freq= f32; sex=2; output;
   conc=.50; freq= m50; sex=1; output;
             freq= f50; sex=2; output;
   conc=.80; freq= m80; sex=1; output;
             freq= f80; sex=2; output;
   datalines;
 1   3   0  7  1  5  0  4  2
 2  11   2 10  5  8  4 10  7
 3  10   4 11 11 11  6  8 15
 4   7   8 16 10 15  6 14  9
 5   4   9  3  5  4  3  8  3
 6   3   3  2  1  2  1  2  4
 7   2   0  1  0  1  1  1  1
 8   1   0  0  1  1  4  0  1
 9   0   0  1  1  0  0  0  0
10   0   0  0  0  0  0  1  1
11   0   0  0  0  1  1  0  0
12   1   0  0  0  0  1  0  0
13   1   0  0  0  0  1  0  0
14 101 126 19 47  7 17  2  4
;

data Days;
   set Beetles;
   do day=1 to time;
      if (day < 14) then do;
         y= (day=time);
         output;
      end;
   end;
run;

proc logistic data=Days outest=est1;
   class day / param=glm;
   model y(event='1')= day sex conc
         / noint link=cloglog technique=newton;
   freq freq;
run;

data one (keep=day survival element s_m20 s_f20 s_m80 s_f80);
   array dd[13] day1-day13;
   array sc[4] m20 f20 m80 f80;
   array s_sc[4] s_m20 s_f20 s_m80 s_f80 (1 1 1 1);
   set est1;
   m20= exp(sex + .20 * conc);
   f20= exp(2 * sex + .20 * conc);
   m80= exp(sex + .80 * conc);
   f80= exp(2 * sex + .80 * conc);
   survival=1;
   day=0;
   output;
   do day=1 to 13;
      element= exp(-exp(dd[day]));
      survival= survival * element;
      do i=1 to 4;
         s_sc[i] = survival ** sc[i];
      end;
      output;
   end;
run;

%modstyle(name=LogiStyle,parent=htmlblue,markers=circlefilled);
ods listing style=LogiStyle;
proc sgplot data=one;
   title 'Flour Beetles Sprayed with Insecticide';
   xaxis grid integer;
   yaxis grid label='Survival Function';
   pbspline y=s_m20 x=day /
      legendlabel = "Male at 0.20 conc." name="pred1";
   pbspline y=s_m80 x=day /
      legendlabel = "Male at 0.80 conc." name="pred2";
   pbspline y=s_f20 x=day /
      legendlabel = "Female at 0.20 conc." name="pred3";
   pbspline y=s_f80 x=day /
      legendlabel = "Female at 0.80 conc." name="pred4";
   discretelegend "pred1" "pred2" "pred3" "pred4" / across=2;
run;

ods listing close;
ods listing;
