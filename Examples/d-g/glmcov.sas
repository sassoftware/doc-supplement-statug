 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: GLMCOV                                              */
 /*   TITLE: Analysis of Variance with a Covariate               */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: ANOVA GLM                                           */
 /*   PROCS: GLM                                                 */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

data x;
   input Trt Rep x y;
   datalines;
 1 1  35.2  116
 1 2  43.2  226
 1 3  65.6 2103
 2 1  44.8  176
 2 2  59.2 2811
 2 3  48.0  387
20 1  54.4 2334
20 2  60.8 2530
20 3  49.6 1275
21 1  60.8 3197
21 2  59.2 3444
21 3  46.4 2414
24 1  72.0 3045
24 2  59.2 2206
24 3  19.2  540
25 1  76.8 3333
25 2  32.0  410
25 3  70.4 4294
;

proc glm;
   classes trt rep;
   model y=trt rep x trt*x;
run;
