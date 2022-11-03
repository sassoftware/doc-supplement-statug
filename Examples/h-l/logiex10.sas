
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX10                                            */
/*   TITLE: Example 10 for PROC LOGISTIC                        */
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
Example 10. Overdispersion
*****************************************************************/

/*
In a seed germination test, seeds of two cultivars were planted in pots of
two soil conditions. The following SAS statements create the data set SEEDS,
which contains the observed proportion of seeds that germinated for various
combinations of cultivar and soil condition. Variable N represents the number
of seeds planted in a pot, and R represents the number germinated. CULT and
SOIL are indicator variables, representing the cultivar and soil condition,
respectively.

PROC LOGISTIC is first used to fit a logit model to the data, with CULT, SOIL
and CULT*SOIL (the CULT x SOIL interaction) as explanatory variables. The
option SCALE=NONE is specified to display the goodness-of-fit statistics.

The results from the first LOGISTIC run suggest that without adjusting for
the overdispersion, the standard errors are likely to be underestimated,
causing the Wald tests to be oversensitive.  In PROC LOGISTIC, there are
three SCALE= options to accommodate overdispersion. With unequal sample sizes
for the observations, SCALE=WILLIAMS is preferred.  In the second LOGISTIC
call, the option SCALE=WILLIAMS is included. The Williams model estimates a
scale parameter by equating the value of Pearson's chi-square for full model
to its approximate expected value. The full model considered here is the
factorial model with cultivar and soil condition as factors.

The estimate of the Williams scale parameter is 0.075941 and is given in the
formula for the WEIGHT variable at the beginning of the printed output. Since
both CULT and CULT*SOIL are not statistically significant (p=.5289 and
p=.9275, respectively), a reduced model containing only the soil condition
factor is then fitted in the final LOGISTIC run.  Here, the observations are
weighted by 1/(1+0.075941(N-1)) by including the scale estimate in the
SCALE=WILLIAMS option as shown.
*/

title 'Example 10. Overdispersion';

data seeds;
   input pot n r cult soil;
   datalines;
 1 16     8      0       0
 2 51    26      0       0
 3 45    23      0       0
 4 39    10      0       0
 5 36     9      0       0
 6 81    23      1       0
 7 30    10      1       0
 8 39    17      1       0
 9 28     8      1       0
10 62    23      1       0
11 51    32      0       1
12 72    55      0       1
13 41    22      0       1
14 12     3      0       1
15 13    10      0       1
16 79    46      1       1
17 30    15      1       1
18 51    32      1       1
19 74    53      1       1
20 56    12      1       1
;


proc logistic data=seeds;
   model r/n=cult soil cult*soil/scale=none;
   title 'Full Model With SCALE=NONE';
run;

proc logistic data=seeds;
   model r/n=cult soil cult*soil / scale=williams;
   title 'Full Model With SCALE=WILLIAMS';
run;

proc logistic data=seeds;
   model r/n=soil / scale=williams(0.075941);
   title 'Reduced Model With SCALE=WILLIAMS(0.075941)';
run;
