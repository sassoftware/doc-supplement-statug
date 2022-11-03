 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: GLMESTFN                                            */
 /*   TITLE: Comparison of Various Types of Estimable Functions  */
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

* This example shows how the various types of
* estimable functions differ;

data one;
   input a b y;
   datalines;
1 1 1.2
1 2 1.3
1 3 1.4
2 1 2.3
2 2 1.1
2 3 4.3
3 1 4.3
3 2 3.2
3 3 5.3
;

title 'Two Way ANOVA With Interaction';
title3 'Completely Balanced';
proc glm;
   classes a b;
   model y= a b a*b / e e1 e2 e3 e4;
run;

data two;
   input a b y;
   datalines;
1 1 1.2
1 1 3.2
1 2 1.3
1 3 1.4
2 1 2.3
2 2 2.1
2 2 1.1
2 3 4.3
3 1 4.3
3 2 3.2
3 3 4.2
3 3 5.3
;

title3 'Unbalanced--Diagonal Cells Have More Data';
proc glm;
   classes a b;
   model y = a b a*b / e e1 e2 e3 e4;
run;

data three;
   input a b y;
   datalines;
1 1 1.2
1 2 1.4
2 1 2.3
2 2 1.1
2 3 4.3
3 1 4.3
3 2 3.2
3 3 5.3
;

title3 'One Missing Cell';
proc glm;
   classes a b;
   model y = a b a*b / e e1 e2 e3 e4;
run;
