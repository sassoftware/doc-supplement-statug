/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: VROEX5                                              */
/*   TITLE: Documentation Example 5 for PROC VARIOGRAM          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: spatial analysis, semivariogram, outliers           */
/*   PROCS: VARIOGRAM                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC VARIOGRAM, EXAMPLE 5                           */
/*    MISC:                                                     */
/****************************************************************/

/* Run PROC VARIOGRAM to produce OUTPAIR= data set -------------*/

title 'Square Root Difference Cloud Example';

proc variogram data=sashelp.thick outp=outp noprint;
   compute novariogram;
   coordinates xc=East yc=North;
   var Thick;
run;


/* Obtain data subset to create square root difference cloud ---*/


data sqroot;
   set outp;
   /*- Include only points +/- 30 degrees of N-S -------*/
   where abs(cos) < 0.5;
   /*- Unit lag of 7, distance tolerance of 3.5 --------*/
   lag_class=int(distance/7 + 0.5000001);
   sqr_diff=sqrt(abs(v1-v2));
run;

proc sort data=sqroot;
   by lag_class;
run;


/* Summarize results with the MEANS procedure ------------------*/

proc means data=sqroot noprint n mean std;
   var sqr_diff;
   by lag_class;
   output out=msqrt n=n mean=mean std=std;
run;
title2 'Summary of Results';

proc print data=msqrt;
   id lag_class;
   var n mean std;
run;


/* Create box plot of the square root difference cloud ---------*/

proc sgplot data=sqroot;
   xaxis label = "Lag Class";
   yaxis label = "Square Root Difference";
   title "Box Plot of the Square Root Difference Cloud";
   vbox sqr_diff / category=lag_class;
run;
