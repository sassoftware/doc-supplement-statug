 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: CATEST                                              */
 /*   TITLE: PROC CATMOD Examples of the ESTIMATE= Option        */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: categorical data analysis,                          */
 /*   PROCS: CATMOD                                              */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

 /* Continuation of the Getting Started Example: ----------------*/
 /*    Generalized Logits Model                                  */
 /* From: Stokes, Davis, and Koch (1995, 235-240).               */
 /*--------------------------------------------------------------*/

data school;
   length Program $ 9;
   input School Program $ Style $ Count @@;
   datalines;
1 regular   self 10  1 regular   team 17  1 regular   class 26
1 afternoon self  5  1 afternoon team 12  1 afternoon class 50
2 regular   self 21  2 regular   team 17  2 regular   class 26
2 afternoon self 16  2 afternoon team 12  2 afternoon class 36
3 regular   self 15  3 regular   team 15  3 regular   class 16
3 afternoon self 12  3 afternoon team 12  3 afternoon class 20
;
proc catmod order=data;
   ods select PopProfiles Estimates;
   weight Count;
   model Style=School Program;
run;

   /* Odds corresponding to each logit function */
   /* for each subpopulation in the data        */
   ods select ContrastEstimates;
   contrast 'School 1 odds'
      Intercept 1 School  1  0 Program  1,
      Intercept 1 School  1  0 Program -1 / est=exp;
   contrast 'School 2 odds'
      Intercept 1 School  0  1 Program  1,
      Intercept 1 School  0  1 Program -1 / est=exp;
   contrast 'School 3 odds'
      Intercept 1 School -1 -1 Program  1,
      Intercept 1 School -1 -1 Program -1 / est=exp;
run;

   /* School 1 Odds */
   contrast 'School 1 regular self/class odds'
      all_parms 1 0  1 0 0 0   1  0 / est=exp;
   contrast 'School 1 regular team/class odds'
      all_parms 0 1  0 1 0 0   0  1 / est=exp;
   contrast 'School 1 after   self/class odds'
      all_parms 1 0  1 0 0 0  -1  0 / est=exp;
   contrast 'School 1 after   team/class odds'
      all_parms 0 1  0 1 0 0   0 -1 / est=exp;
run;

   /* Odds Ratios for School Program */
   contrast 'Odds Ratios for School Program'
      program 2 / est=exp;
run;
