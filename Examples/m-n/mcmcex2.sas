/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: MCMCEX2                                             */
/*   TITLE: Documentation Example 2 for PROC MCMC               */
/*          Box-Cox Transformation                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: MCMC                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MCMC, EXAMPLE 2                                */
/*    MISC:                                                     */
/****************************************************************/

/****************************************************************/
/*  Box-Cox Transformation, with a Continuous Prior on Lambda   */
/****************************************************************/

title 'Box-Cox Transformation, with a Continuous Prior on Lambda';
data boxcox;
   input y x @@;
   datalines;
10.0  3.0  72.6  8.3  59.7  8.1  20.1  4.8  90.1  9.8   1.1  0.9
78.2  8.5  87.4  9.0   9.5  3.4   0.1  1.4   0.1  1.1  42.5  5.1
57.0  7.5   9.9  1.9   0.5  1.0 121.1  9.9  37.5  5.9  49.5  6.7
 8.3  1.8   0.6  1.8  53.0  6.7 112.8 10.0  40.7  6.4   5.1  2.4
73.3  9.5 122.4  9.9  87.2  9.4 121.2  9.9  23.1  4.3   7.1  3.5
12.4  3.3   5.6  2.7 113.0  9.6 110.5 10.0   3.1  1.5  52.4  7.9
80.4  8.1   0.6  1.6 115.1  9.1  15.9  3.1  56.5  7.3  85.4  9.8
32.5  5.8  43.0  6.2   0.1  0.8  21.8  5.2  15.2  3.5   5.2  3.0
 0.2  0.8  73.5  8.2   4.9  3.2   0.2  0.3  69.0  9.2   3.6  3.5
 0.2  0.9 101.3  9.9  10.0  3.7  16.9  3.0  11.2  5.0   0.2  0.4
80.8  9.4  24.9  5.7 113.5  9.7   6.2  2.1  12.5  3.2   4.8  1.8
80.1  8.3  26.4  4.8  13.4  3.8  99.8  9.7  44.1  6.2  15.3  3.8
 2.2  1.5  10.3  2.7  13.8  4.7  38.6  4.5  79.1  9.8  33.6  5.8
 9.1  4.5  89.3  9.1   5.5  2.6  20.0  4.8   2.9  2.9  82.9  8.4
 7.0  3.5  14.5  2.9  16.0  3.7  29.3  6.1  48.9  6.3   1.6  1.9
34.7  6.2  33.5  6.5  26.0  5.6  12.7  3.1   0.1  0.3  15.4  4.2
 2.6  1.8  58.6  7.9  81.2  8.1  37.2  6.9
;

ods graphics on;
proc mcmc data=boxcox nmc=50000 propcov=quanew seed=12567
          monitor=(lda);
   ods select PostSumInt TADpanel;
   parms beta0 0  beta1 0  lda 1 s2 1;

   beginnodata;
   prior beta: ~ general(0);
   prior s2 ~ gamma(shape=3, scale=2);
   prior lda ~ unif(-2,2);
   sd = sqrt(s2);
   endnodata;

   ys = (y**lda-1)/lda;
   mu = beta0+beta1*x;
   ll = (lda-1)*log(y)+lpdfnorm(ys, mu, sd);
   model general(ll);
run;

proc transreg data=boxcox details pbo;
   ods output boxcox = bc;
   model boxcox(y / convenient lambda=-2 to 2 by 0.01) = identity(x);
   output out=trans;
run;

proc print noobs label data=bc(drop=rmse);
   title2 'Confidence Interval';
   where ci ne ' ' or abs(lambda - round(lambda, 0.5)) < 1e-6;
   label convenient = '00'x ci = '00'x;
run;

/****************************************************************/
/*   Box-Cox Transformation, Modeling Lambda = 0                */
/****************************************************************/

title 'Box-Cox Transformation, Modeling Lambda = 0';
data boxcox;
   do x = 1 to 8 by 0.025;
      ly = x + normal(7);
      y = exp(ly);
      output;
   end;
run;

proc mcmc data=boxcox outpost=simout nmc=50000 seed=12567
          monitor=(lda);
   ods select PostSumInt;
   parms s2 1 alpha 10;
   beginnodata;
   prior s2 ~ gamma(shape=3, scale=2);
   if alpha=0 then lp = log(2);
      else lp = log(1);
   prior alpha ~ dgeneral(lp, lower=-200, upper=200);
   lda = alpha * 0.01;
   sd = sqrt(s2);
   endnodata;
   if alpha=0 then
      ll = -ly+lpdfnorm(ly, x, sd);
   else do;
      ys = (y**lda - 1)/lda;
      ll = (lda-1)*ly+lpdfnorm(ys, x, sd);
   end;
   model general(ll);
run;

proc freq data=simout;
   ods select onewayfreqs freqplot;
   tables lda /nocum plot=freqplot(scale=percent);
run;
ods graphics off;

