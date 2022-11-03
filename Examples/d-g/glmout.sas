 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: GLMOUT                                              */
 /*   TITLE: Example of Output Data Set for PROC GLM             */
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

  /*--------------------------------------------------*/
  /* GLM - shows use of output dataset                */
  /*--------------------------------------------------*/

data test;
   input a b y aa $ bb $ ;
   datalines;
1 3 18 level1 level3
1 1 20 level1 level1
1 1 22 level1 level1
1 1 24 level1 level1
1 4 18 level1 level4
1 2 14 level1 level2
1 2 19 level1 level2
1 2 15 level1 level2
1 3 19 level1 level3
1 3 21 level1 level3
2 4 14 level2 level4
2 1 15 level2 level1
2 1 16 level2 level1
2 2 19 level2 level2
2 4 12 level2 level4
2 2 24 level2 level2
2 3 10 level2 level3
1 4 19 level1 level4
2 3 18 level2 level3
2 3 20 level2 level3
;

proc glm data=test outstat=new;
   class aa bb;
   model y=aa|bb/ss4;
   means aa|bb/duncan;
run;

 /* print out the statistics */
data _null_;
   set new;
   retain edf;
   if _type_ ='ERROR' then edf = df;
   else do;
   put @1 'F test for effect ' _source_ $ ' was ' F 8.2 ', with'
      df 3. ' and ' edf 3. ' degrees of freedom.' /
     @1 'Probability of a larger F is ' prob 6.4 ', which is' @;
   if prob < .001 then put ' highly ' @;
   else if prob < .01 then put ' very ' @;
   else if prob < .05 then put ' ' @;
   else put ' not ' @;
   put 'significant.' @ /;
   end;
   put /;
run;
