/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX14                                            */
/*   TITLE: Example 14 for PROC LOGISTIC                        */
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
Example 14. Complementary log-log Model for Infection Rates
*****************************************************************/

/*
Antibodies produced in response to an infectious disease like malaria remain
in the body after the individual has recovered from the disease. A
serological test detects the presence or absence of antibodies. An individual
with such antibodies is termed seropositive. In areas where the disease is
endemic, the inhabitants are at fairly constant risk of infection. The
probability of an individual never having been infected in Y years is
exp(-uY) where u is the mean number of infections per year (see the
appendix of Draper, C.C., Voller, A., and Carpenter, R.G. 1972, "The
epidemiologic interpretation of serologic data in malaria," American Journal
of Tropical Medicine and Hygiene, 21, 696-703). Rather than estimating the
unknown u, it is of interest to epidemiologists to estimate the probability
of a person living in the area being infected in one year. This infection
rate is 1-exp(-u).

The SAS statements below create the data set SERO, which contains the results
of a serological survey of malaria infection. Individuals of nine age groups
were tested. Variable A represents the midpoint of the age range for each age
group, N represents the number of individuals tested in each age group and R
represents the number of individuals that are sero- positive.
*/

title 'Example 14. CLOGLOG Model for Infection Rates';

data sero;
   input Group A N R;
   X=log(A);
   label X='Log of Midpoint of Age Range';
   datalines;
1  1.5  123  8
2  4.0  132  6
3  7.5  182 18
4 12.5  140 14
5 17.5  138 20
6 25.0  161 39
7 35.0  133 19
8 47.0   92 25
9 60.0   74 44
;


/*
For the ith group with age midpoint A_i, the probability of being
seropositive is p_i=1-exp(-uA_i). It follows that

log(log(1-p_i)) = log(u) + log(A_i)

By fitting a binomial model with a complementary log-log link function and by
using X=log(A) as an offset term, b0=log(u) is estimated as an intercept
parameter. The following SAS statements invoke PROC LOGISTIC to compute the
maximum likelihood estimate of b0. The LINK=CLOGLOG option is specified to
request the complementary log-log link function. Also specified is the
CLPARM=PL option, which produces the profile-likelihood confidence limits for
the b0.
*/

proc logistic data=sero;
   model R/N= / offset=X
                link=cloglog
                clparm=pl
                scale=none;
   title 'Constant Risk of Infection';
run;


/*
The maximum likelihood estimate of b0 is -4.6605. This translates into an
infection rate of 1-exp(-exp(-4.6605))=.00942.  The 95\% confidence interval
for the infection rate, obtained by back-transforming the 95\% confidence
interval for b0, is (.0082, .0011); that is, there is a 95\% chance that the
interval of 8 to 11 infections per thousand individuals contains the true
infection rate.

The goodness-of-fit statistics for the constant risk model are statistically
significant (p<.0001), indicating that the assumption of constant risk of
infection is not correct. One can fit a more extensive model by allowing a
separate risk of infection for each age group. Let u_i be the mean number of
infections per year for the ith age group. The probability of seropositive
for the ith group with age midpoint A_i is p_i=1-exp(-u_iA_i), so that

log(-log(1-p_i)=log(u_i) + log(A_i)

In the following SAS statements, the GLM parameterization creates dummy
variables for the age groups.  PROC LOGISTIC is invoked to fit a
complementary log-log model that contains the dummy variables as the only
explanatory variables with no intercept term and with X=log(A) as an offset
term.  Note that log(u_i) is the regression parameter associated with
GROUP=i.  The DATA statement transforms the estimates and confidence limits
saved in the CLPARMPL data set to estimate the infection rates in one year's
time.
*/

proc logistic data=sero;
   ods output ClparmPL=ClparmPL;
   class Group / param=glm;
   model R/N=Group / noint
                     offset=X
                     link=cloglog
                     clparm=pl;
   title 'Infectious Rates and 95% Confidence Intervals';
run;

data ClparmPL;
   set ClparmPL;
   Estimate=round( 1000*( 1-exp(-exp(Estimate)) ) );
   LowerCL =round( 1000*( 1-exp(-exp(LowerCL )) ) );
   UpperCL =round( 1000*( 1-exp(-exp(UpperCL )) ) );
run;

