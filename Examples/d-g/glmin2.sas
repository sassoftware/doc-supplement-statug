/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: GLMIN2                                              */
/*   TITLE: Getting Started Example 2 for PROC GLM              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Polynomial regression                               */
/*   PROCS: GLM                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC GLM, INTRODUCTORY EXAMPLE 2.                   */
/*    MISC:                                                     */
/****************************************************************/


/* PROC GLM for Quadratic Least Squares Regression -------------*/

title 'Regression in PROC GLM';
data iron;
   input fe loss @@;
   datalines;
0.01 127.6   0.48 124.0   0.71 110.8   0.95 103.9
1.19 101.5   0.01 130.1   0.48 122.0   1.44  92.3
0.71 113.1   1.96  83.7   0.01 128.0   1.44  91.4
1.96  86.2
;

/* Scatter Plot of Response Variable Vs. Independent Variable --*/

proc sgscatter data=iron;
   plot loss*fe;
run;
ods graphics off;

/* Fit a Quadratic Regression Model to the Data ----------------*/

proc glm data=iron;
   model loss=fe fe*fe;
run;

/* Previous Analysis Results with Scatter Plot of Original Data */

ods graphics on;
proc glm data=iron;
   model loss=fe fe*fe;
run;
ods graphics off;

/* Fit the Model Without Quadratic Term ------------------------*/

proc glm data=iron;
   model loss=fe;
run;

