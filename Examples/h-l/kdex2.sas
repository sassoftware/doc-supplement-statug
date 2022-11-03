/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: KDEX2                                               */
/*   TITLE: Documentation Examples 3, 4, and 5 for PROC KDE     */
/* PRODUCT: SAS                                                 */
/*  SYSTEM: ALL                                                 */
/*    KEYS: kernel density estimation, ODS Graphics             */
/*   PROCS: KDE                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC KDE, Examples 3, 4, and 5                      */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data bivnormal;
   seed = 1283470;
   do i = 1 to 1000;
      z1 = rannor(seed);
      z2 = rannor(seed);
      z3 = rannor(seed);
      x = 3*z1+z2;
      y = 3*z1+z3;
      output;
   end;
   drop seed;
run;


/* Changing the Bandwidth (Bivariate) */

ods graphics on;
proc kde data=bivnormal;
   bivar x y / bwm=2;
run;

proc kde data=bivnormal;
   bivar (x y) (x (bwm=0.5) y (bwm=2));
run;
ods graphics off;

/* Requesting Additional Output Tables */

proc kde data=bivnormal;
   bivar x y / bivstats levels percentiles unistats;
run;

/* Specifying Non-Default Percentiles */

proc kde data=bivnormal;
   bivar x y / levels=2.5, 50, 97.5
               percentiles=2.5, 25, 50, 75, 97.5;
run;

/* Examples of All Univariate Plots */

ods graphics on;
proc kde data=bivnormal;
   univar x / plots=(density histogram histdensity);
   univar x y / plots=densityoverlay;
run;
ods graphics off;
