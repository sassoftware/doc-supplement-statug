 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: NLINMAXL                                            */
 /*   TITLE: Maximum Likelihood Estimation using PROC NLIN       */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: nonlinear models,                                   */
 /*   PROCS: NLIN SGPLOT PRINT                                   */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: SEE COMMENTS BELOW                                  */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/
*--------- NLINMAXL --------------------------------------------------*
|                                                                      |
|    Examples of maximum likelihood estimation using proc NLIN         |
|                                                                      |
|    These examples also appear in section 14.3, Maximum Likelihood    |
|    Estimation, BMDP-77, (Dixon, W. J., and M. B. Brown, (1977).      |
|    Biomedical Computer Programs P-Series, University of California   |
|    Press, Berkeley, pp. 499-514.)                                    |
*----------------------------------------------------------------------;





*--------- Estimate Parameters of Logistic Model ----------------------*
|    The following data are from Cox (Cox, D. R., 1970. The Analysis   |
|    of Binary Data, London, Methuen, p. 86).  At the specified time   |
|    (T) of heating, a number of ingots (N) are tested and the number  |
|    (S) not ready for rolling is recorded.                            |
|                                                                      |
|                     I      T      S      N                           |
|                     1      7      0     55                           |
|                     2     14      2    157                           |
|                     3     27      7    159                           |
|                     4     51      3     16                           |
|                                                                      |
|    Cox fits the data with a logistic model:                          |
|                                                                      |
|    F(I) = N(I)*EXP(P1+P2*T(I))/(1+EXP(P1+P2*T(I))))                  |
|                                                                      |
|    If the data are from a binomial distribution, then                |
|                                                                      |
|    WEIGHT(I) = 1/VAR(S(I)) = N(I)/(F(I)*(N(I)-F(I))))                |
|                                                                      |
*----------------------------------------------------------------------;
title1 'Sample program: NLINMAXL    Maximum Likelihood Estimation';
data;
   input time unready tested;
   datalines;
7 0 55
14 2 157
27 7 159
51 3 16
;
proc nlin nohalve;
   parameters p1 = 0 p2 = 0;
   xnumer = exp(p1+p2*time);
   denom = 1 + xnumer;
   model.unready = tested*xnumer/denom;
   casewt=denom/model.unready;
   _weight_ = casewt;
   output out=save predicted=punready residual=runready;
run;
proc print data=save;
run;

proc sgplot data=save;
   scatter y=unready  x=time / markerattrs=(symbol=circle);
   scatter y=punready x=time / markerattrs=(symbol=circlefilled);
run;


*----------Estimate Parameters of Multinomial Data--------------------*
|  Data on the number of Chorda Tympani fibers in rats tongues        |
|  responding to four taste stimuli were recorded (Frank, M., and     |
|  C. Pfafman, (1969)  Taste Nerve Fibers: A Random Distribution on   |
|  Sensitivities To Four Tastes, Science 164, pp. 1183-1185.)         |
|                                                                     |
|             H   +   +   -   -                                       |
|     S   Q   N   +   -   +   -                                       |
|     +   +       2   0   1   0                                       |
|     +   -       1   3   3   2                                       |
|     -   +       3   3   0   1                                       |
|     -   -       3   1   4   .                                       |
|                                                                     |
|     taste stimuli are                                               |
|     H   Hydrogen Chloride (SOUR)      +  Present                    |
|     N   Sodium Chloride   (SALTY)     -  Absent                     |
|     Q   Quinine           (BITTER)                                  |
|     S   Sucrose           (SWEET)                                   |
|                                                                     |
|  NOTE: The cell corresponding to all 4 stimuli at - has no data     |
|        since no sensitivity can result.                             |
|                                                                     |
|  A log-linear model corresponding to a quasi-independence model has |
|  been suggested (Fienburg, S. E., (1972) The Analysis of Incomplete |
|  Multiway Tables, Biometrics 28, pp. 177-202.                       |
|                                                                     |
|  F(I) = K*EXP(PN*N(I)+PH*H(I)+PS*S(I)+PQ*Q(I))                      |
|                                                                     |
|  The normalizing constant K  imposes the constraint                 |
|                                                                     |
|  SUM( K*EXP(PN*N(I)+PH*H(I)+PS*S(I)+PQ*Q(I)) = SUM( FREQ ) = 27     |
|                                                                     |
*---------------------------------------------------------------------;
data;
   h = +1; link n;
   h = -1; link n; return;
n: n = +1; link s;
   n = -1; link s; return;
s: s = +1; link q;
   s = -1; link q; return;
q: q = +1; link v;
   q = -1; link v; return;
v: input freq @@; if freq ne . then output; return;
   datalines;
2 1 3 3 0 3 3 1 1 3 0 4 0 2 1 .
;
proc print;
run;
proc nlin method=newton nohalve;
   parameters  ph = 0.0974 pn = 0.1576 ps = -0.1812 pq = -0.2783;
   retain lsum 0 ;           /* These are retained across observations */
   control sum 1 lastobs 0;  /* These are retained across iterations */
   temp = exp(ph*h+pn*n+ps*s+pq*q);
   model.freq = 27*temp/sum;
   casewt=1/model.freq;
   _weight_ = casewt;
   lsum = lsum + temp;
           /* Compute a sum */
   if ( lastobs < _OBS_ ) then lastobs = _OBS_;
   if ( lastobs = _OBS_ ) then sum = lsum;
   output predicted=pfreq residual=rfreq;
run;
data;
   set;
   trt = 1 + (q=1) + 2*(s=1) + 4*(n=1) + 8*(h=1);
run;
proc print;
run;

proc sgplot;
   scatter y=freq  x=trt / markerattrs=(symbol=circle);
   scatter y=pfreq x=trt / markerattrs=(symbol=circlefilled);
run;
