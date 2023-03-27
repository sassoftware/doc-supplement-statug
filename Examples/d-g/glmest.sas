/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: GLMEST                                              */
/*   TITLE: Details Example 1 for PROC GLM                      */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Type 1 SS, Type 2 SS, Type 3 SS, Type 4 SS          */
/*   PROCS: GLM                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC GLM, DETAILS EXAMPLE 1.                        */
/*    MISC:                                                     */
/****************************************************************/


/* Hypothesis Testing in PROC GLM ------------------------------*/

data example;
   input a b y @@;
   datalines;
1 1 23.5  1 1 23.7  1 2 28.7  2 1  8.9  2 2  5.6
2 2  8.9  3 1 10.3  3 1 12.5  3 2 13.6  3 2 14.6
;

proc glm;
   class a b;
   model y=a b a*b / e e1 e2 e3 e4;
run;

