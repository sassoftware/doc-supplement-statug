 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: GLMMANOV                                            */
 /*   TITLE: Multivariate Analysis of Variance                   */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: ANOVA                                               */
 /*   PROCS: GLM                                                 */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

* MANOVA data from Morrison's multivariate text, 2nd edition, p 190;

data;
   input sex $ drug $ @;
   input y1 y2 @; output;
   input y1 y2 @; output;
   input y1 y2 @; output;
   input y1 y2 @; output;
   datalines;
M A 5 6 5 4 9 9 7 6
M B 7 6 7 7 9 12 6 8
M C 21 15 14 11 17 12 12 10
F A 7 10 6 6 9 7 8 10
F B 10 13 8 7 7 6 6 9
F C 16 12 14 9 14 8 10 5
;

proc glm;
   classes sex drug;
   model y1 y2 = sex drug sex*drug;
   manova h=sex drug sex*drug / printe printh;
run;
