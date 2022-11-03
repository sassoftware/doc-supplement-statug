/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ICALEX1                                             */
/*   TITLE: Documentation Example 2 for Introduction to SEM     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: measurement error model, corn data                  */
/*   PROCS: CALIS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: Introduction to SEM, Example 2                      */
/*    MISC:                                                     */
/****************************************************************/

data corn(type=cov);
   input _type_ $ _name_ $ y x;
   datalines;
cov    y    87.6727    .
cov    x    104.8818   304.8545
mean   .    97.4545    70.6364
n      .    11         11
;

proc calis;
   lineqs
      Y  = alpha * Intercept + beta * Fx + Ey,
      X  =     0 * Intercept +    1 * Fx + Ex;
   variance
      Ex = 57;
   mean
      Fx;
run;

proc calis;
   lineqs
      Y  = alpha * Intercept + beta * Fx + Ey,
      X  =     0 * Intercept +    1 * Fx + Ex;
   variance
      Ex = 0;
   mean
      Fx;
run;

proc calis data=corn;
   lineqs
      Fy  = alpha * Intercept + beta * Fx + DFy,
      Y   = 0     * Intercept + 1.   * Fy + Ey,
      X   = 0     * Intercept + 1.   * Fx + Ex;
   variance
      Ex  = 57.,
      Dfy = 0.;
   mean
      Fx;
run;
