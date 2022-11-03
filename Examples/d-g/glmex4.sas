/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: GLMEX4                                              */
/*   TITLE: Example 4 for PROC GLM                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Analysis of covariance                              */
/*   PROCS: GLM                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC GLM, EXAMPLE 4.                                */
/*          Snedecor and Cochran (1967), Stat. Methods, p. 422. */
/*    MISC:                                                     */
/****************************************************************/

/* Analysis of Covariance --------------------------------------*/
data DrugTest;
   input Drug $ PreTreatment PostTreatment @@;
   datalines;
A 11  6   A  8  0   A  5  2   A 14  8   A 19 11
A  6  4   A 10 13   A  6  1   A 11  8   A  3  0
D  6  0   D  6  2   D  7  3   D  8  1   D 18 18
D  8  4   D 19 14   D  8  9   D  5  1   D 15  9
F 16 13   F 13 10   F 11 18   F  9  5   F 21 23
F 16 12   F 12  5   F 12 16   F  7  1   F 12 20
;
proc glm data=DrugTest;
   class Drug;
   model PostTreatment = Drug PreTreatment / solution;
   lsmeans Drug / stderr pdiff cov out=adjmeans;
run;
proc print data=adjmeans;
run;
/* Visualize the Fitted Analysis of Covariance Model -----------*/
ods graphics on;

proc glm data=DrugTest plot=meanplot(cl);
   class Drug;
   model PostTreatment = Drug PreTreatment;
   lsmeans Drug / pdiff;
run;

ods graphics off;
