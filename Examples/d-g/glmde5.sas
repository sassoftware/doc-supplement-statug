/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: GLMDE5                                              */
/*   TITLE: Details Example 5 for PROC GLM                      */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Simple effects                                      */
/*   PROCS: GLM                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC GLM, DETAILS EXAMPLE 5.                        */
/*    MISC:                                                     */
/****************************************************************/


/* Simple Effects ----------------------------------------------*/

data twoway;
   input A B Y @@;
   datalines;
1 1 10.6   1 1 11.0   1 1 10.6   1 1 11.3
1 2 -0.2   1 2  1.3   1 2 -0.2   1 2  0.2
1 3  0.1   1 3  0.4   1 3 -0.4   1 3  1.0
2 1 19.7   2 1 19.3   2 1 18.5   2 1 20.4
2 2 -0.2   2 2  0.5   2 2  0.8   2 2 -0.4
2 3 -0.9   2 3 -0.1   2 3 -0.2   2 3 -1.7
3 1 29.7   3 1 29.6   3 1 29.0   3 1 30.2
3 2  1.5   3 2  0.2   3 2 -1.5   3 2  1.3
3 3  0.2   3 3  0.4   3 3 -0.4   3 3 -2.2
;

proc glm data=twoway;
   class A B;
   model Y = A B A*B;
run;

   lsmeans A*B / slice=B;
run;

