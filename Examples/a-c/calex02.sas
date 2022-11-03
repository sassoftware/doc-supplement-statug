/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CALEX02                                             */
/*   TITLE: Documentation Example 18 for PROC CALIS             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: structural equations, reciprocal effects            */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CALIS, Example 18                              */
/*    MISC:                                                     */
/****************************************************************/

title 'Food example of KMENTA(1971, p.565 & 582)';
data food;
   input Q P D F Y;
   label  Q='Food Consumption per Head'
          P='Ratio of Food Prices to General Price'
          D='Disposable Income in Constant Prices'
          F='Ratio of Preceding Years Prices'
          Y='Time in Years 1922-1941';
   datalines;
  98.485  100.323   87.4   98.0   1
  99.187  104.264   97.6   99.1   2
 102.163  103.435   96.7   99.1   3
 101.504  104.506   98.2   98.1   4
 104.240   98.001   99.8  110.8   5
 103.243   99.456  100.5  108.2   6
 103.993  101.066  103.2  105.6   7
  99.900  104.763  107.8  109.8   8
 100.350   96.446   96.6  108.7   9
 102.820   91.228   88.9  100.6  10
  95.435   93.085   75.1   81.0  11
  92.424   98.801   76.9   68.6  12
  94.535  102.908   84.6   70.9  13
  98.757   98.756   90.6   81.4  14
 105.797   95.119  103.1  102.3  15
 100.225   98.451  105.1  105.0  16
 103.522   86.498   96.4  110.5  17
  99.929  104.016  104.4   92.5  18
 105.223  105.769  110.7   89.3  19
 106.232  113.490  127.1   93.0  20
;

proc calis data=food pshort nostand;
   lineqs
      Q = alpha1 * Intercept + beta1  * P  + gamma1 * D + E1,
      P = theta1 * Intercept + theta2 * Q  + theta3 * F + theta4 * Y + E2;
   variance
      E1-E2 = eps1-eps2;
   cov
      E1-E2 = eps3;
   bounds
      eps1-eps2 >= 0. ;
run;

proc calis data=Food pshort nostand;
   lineqs
      Q = alpha1 * Intercept + beta1  * P  + gamma1 * D + E1,
      P = theta1 * Intercept + theta2 * Q  + theta3 * F + theta4 * Y + E2;
   variance
      E1-E2 = eps1-eps2;
   cov
      E1-E2 = eps3;
   bounds
      eps1-eps2 >= 0. ;
   parameters alpha2 (50.) beta2 gamma2 gamma3 (3*.25);
      theta1  = -alpha2 / beta2;
      theta2  = 1 / beta2;
      theta3  = -gamma2 / beta2;
      theta4  = -gamma3 / beta2;
run;

proc calis data=food pshort nostand;
   lineqs
      Q =  * Intercept +  *  P  +  * D        + E1,
      P =  * Intercept +  *  Q  +  * F +  * Y + E2;
   variance
      E1-E2 = eps1-eps2;
   cov
      E1 E2;
   bounds
      eps1-eps2 >= 0. ;
run;
