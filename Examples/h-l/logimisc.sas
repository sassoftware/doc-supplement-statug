 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: LOGIMISC                                            */
 /*   TITLE: Miscellaneous Examples for PROC LOGISTIC            */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: logistic regression analysis,                       */
 /*   PROCS: LOGISTIC                                            */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*          chapter                                             */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

 /*****************************************************************
     Example 1. Using Proc Logistic for Poisson Regression
 *****************************************************************/

 /*
  The data, taken from Koch et. al (1986), consist of counts of
  new melanoma cases reported during 1969-1971 among white males
  and the corresponding estimated populations at risk for six
  age groups and two geographic regions.  Possion regression
  was proposed to study the vital statistics factors on new
  melanoma cases.  Since the event frequencies are relatively
  small as compared to the corresponding population sizes, the
  logistic regression estimates are essentially the same as
  the Poisson regression estimates.
 */

title1 'Example 1. Poisson Regression';
data;
   drop case_n case_s pop_n pop_s;
   length age_grp $ 5;
   input age_grp $ case_n case_s pop_n pop_s;
   age_grp2 = ( age_grp = '35-44' );
   age_grp3 = ( age_grp = '45-54' );
   age_grp4 = ( age_grp = '55-64' );
   age_grp5 = ( age_grp = '65-74' );
   age_grp6 = ( age_grp = '>=75' );
   case = case_n; pop = pop_n; region = 0; output;
   case = case_s; pop = pop_s; region = 1; output;
   label region = '0 = NORTHERN  1 = SOUTHERN';
   datalines;
<35    61 64 2880262 1074246
35-44  76 75  564535  220407
45-54  98 68  592983  198119
55-64 104 63  450740  134084
65-74  63 45  270908   70708
>=75   80 27  161850   34233
;

proc logistic;
  model case/pop=age_grp2-age_grp6 region;
run;


 /*****************************************************************
        Example 2. Overdispersion in Quantal Assay Data
 *****************************************************************/

 /*
   In bioassay, one is often interested in the median effect dose,
   ED50, which is the concentration of a chemical that is expected
   to produce a response in 50% of the subjects exposed to it.
   By fitting simple models such as logit, probit, or complementary
   log-log, ED50 is a simple function of the regression coeffi-
   cients. However, the basic underlying assumption that the
   quantal assay data follow a binomial distribution may not
   always be appropriate. This example presents an analysis that
   incorporates extra-binomial variation to the data.

   The following SAS statements create the data set ASSAY, which
   contains a set of dose response data. Variable LOGCONC
   represents the log concentration of a chemical, N represents
   the number of subjects dosed, and R represents the number of
   subjects responded.

   PROC LOGISTIC is first used to fit a logit model to the quantal
   assay data. The option SCALE=NONE is specified to display the
   goodness-of-fit statistics. Linear predictor values and
   Pearson residuals are output to data set OUT1, which is
   subsequently used in PROC GPLOT to display the adequacy of
   the fit.
 */

title1 'Example 2. Overdispersion in Quantal Assay Data';
data assay;
   input logconc r n;
   logit=log(r/(n-r));
   datalines;
2.68  10  31
2.76  17  30
2.82  12  31
2.90   7  27
3.02  23  26
3.04  22  30
3.13  29  31
3.20  29  30
3.21  23  30
;

proc logistic data=assay outest=dn covout;
   model r/n= logconc / scale=none;
   output out=out1 xbeta=xb reschi=reschi;
run;

proc sgplot data=out1 noautolegend;
   title 'Plot of Data with Fitted Line';
   scatter y=logit x=logconc;
   series  y=xb    x=logconc;
   label logit   = 'Logit of Proportion Responded'
         logconc = 'Log Concentration';
run;

proc sgplot data=out1;
   title 'Residual Plot';
   scatter y=reschi x=logconc;
   label logit   = 'Pearson Residual'
         logconc = 'Log Concentration';
run;


 /*
   Both goodness-of-fits statistics are statistically significant,
   indicating a lack of fit of the model. However, there is not
   a clear pattern of Pearson residuals and the fit of the
   model appears to be adequate. This suggests that extra-binomial
   variation is responsible for the poor fit.

   The Williams method of modeling overdispersion is then used.
   This is requested by specifying the SCALE=WILLIAMS option.
 */

title2 'Scale=Williams';
proc logistic data=assay outest=dw covout;
   model r/n= logconc / scale=williams;
run;


  /*
    With log of concentration as the only explanatory variable,
    ED50 is estimated by exp(-intercept/slope). A 95% confidence
    interval of ED50 is obtained by exponentiating the 95%
    confidence interval for (-intercept/slope). The latter is
    conveniently calculated using Fieller's theorem.

    In a single DATA step, you can compute the confidence limits
    for ED50 from the OUTEST= data set that contains both
    parameter estimates and covariance matrix. The following SAS
    statements compute the 95% confidence interval for ED50 for
    each of the SCALE= option available in PROC LOGISTIC. An
    OUTEST= data set that contains both estimates and dispersion
    is first output for each SCALE= option.  The four OUTEST= data
    sets are then concatenated in data set TWO and confidence
    limits are subsequently calculated for each data set.
 */

title2 'Scale=Pearson';
proc logistic data=assay outest=dp covout noprint;
   model r/n= logconc / scale=p;
run;

title2 'Scale=Deviance';
proc logistic data=assay outest=dd covout noprint;
   model r/n= logconc / scale=d;
run;

data two(keep=scale ed50 lower upper);
   retain b0 b1 v00 v01 v11;
   set dn(in=dn) dw(in=dw) dp(in=dp) dd(in=dd);
   if _name_='r' then do;
      b0= INTERCEPT;
      b1= logconc;
   end;
   if _name_='Intercept' then do;
      v00=INTERCEPT;
      v01=logconc;
   end;
   if _name_='logconc ' then do;
      if dn=1 then scale='NONE    ';
      else if dw=1 then scale='WILLIAMS';
      else if dp=1 then scale='PEARSON ';
      else if dd=1 then scale='DEVIANCE';
      v11=logconc;
      theta=-b0/b1;
      t975=tinv(.975,7);
      c=t975*t975*v11/(b1*b1);
      term1=theta+(c/(1-c))*(theta + v01/v11);
      term2=t975/(b1*(1-c));
      term3=(v00+2*theta*v01+theta*theta*
                           v11-c*(v00-v01*v01/v11));
      term4=term2*sqrt(term3);
      l1=term1-term4;
      u1=term1+term4;
      ed50= exp(theta);
      lower=exp(l1);
      upper=exp(u1);
      output;
   end;
run;

title2 'ED50 and 95% Confidence Interval';
proc print data=two;
   id scale;
run;

 /*****************************************************************
                   Example 3. 1:M Matching
 *****************************************************************/

 /*
   Consider the special case that (i) there is only one case in
   each matched set and the number of controls are the same for all
   sets, and (ii) there is only a single binary covariable with
   relative risk exp(beta). The Samsu consumption data in Breslow
   (1982) contains 80 matched sets. Each matched set has one case
   and four controls. The distribution according to Samsu exposure
   is given in the following table:

     Case          Total Number (Case + Controls)
                       0   1   2   3   4  5

     Exposed           .   5  19  10   6  0
     Not Exposed      10  15   8   7   0  .
     Total            10  20  27  17   6  .


   Let n_0m be the number of sets in which exactly m controls are
   exposed and the case is not; and let n_1m be the number of sets
   in which the case and m controls are exposed. The likelihood of
   the conditional logistic regression model is proportional to the
   product of the likelihood of the binomial distribution
   B(N_m, theta_m), where

         N_m = n_0m + n_1m
   and
         theta_m = m * exp(beta) / [m * exp(beta) + 5 - m]

   Since logit(theta_m) = log( m/(5-m) + beta ), beta can be
   estimated as a parameter in a logistic regression model with
   no intercept and an offset value of m/(5-m).

   This analysis is performed with the PROC LOGISTIC invocation
   below.
 */

title1 'Example 3. 1:M Matching';
data samsu;
   input m r n;
   samsu = 1;
   off= log(m/(5-m));
   datalines;
1  5 20
2 19 27
3 10 17
4  6  6
;

proc logistic data=samsu;
   model r/n = samsu / offset=off noint;
run;

 /*
   Note that you can perform the same analysis using the STRATA statement to
   perform a conditional logistic regression.

   First create the SAMSU data set as a single record for each subject.
 */

data one;
   input exp1-exp5 freq;
   datalines;
1 0 0 0 0 5
1 1 0 0 0 19
1 1 1 0 0 10
1 1 1 1 0 6
1 1 1 1 1 0
0 0 0 0 0 10
0 1 0 0 0 15
0 1 1 0 0 8
0 1 1 1 0 7
0 1 1 1 1 0
;

data two;
   set one;
   retain id 0;
   do i=1 to freq;
      id=id+1;
      output;
   end;
run;

data three;
   set two;
   case=1; samsu=exp1; output;
   case=0; samsu=exp2; output;
           samsu=exp3; output;
           samsu=exp4; output;
           samsu=exp5; output;
   keep case samsu id;
run;

 /*
   Then run a conditional logistic regression.
 */

proc logistic data=three;
   model case(event='1')=samsu;
   strata id;
run;
