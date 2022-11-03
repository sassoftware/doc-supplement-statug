 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: FRIEDMAN                                            */
 /*   TITLE: Two-Way Nonparametric ANOVA                         */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: analysis of variance, nonparametric methods         */
 /*   PROCS: ANOVA RANK                                          */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF:                                                     */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/
*-----------------------------FRIEDMAN---------------------------*
*  Friedman's two-way nonparametric ANOVA can be calculated by   *
*  using the ANOVA procedure in conjunction with the RANK        *
*  procedure done by the blocking variable.  To calculate the    *
*  Chi-Square, multiply the sum-of-squares for treatment by      *
*  12/((t*(t+1)) where t is the number of treatments.            *
*----------------------------------------------------------------*;
title 'Randomized Complete Block Design';

data one;
   input Block Trtment $ Yield;
   datalines;
1 A 32.6
1 B 36.4
1 C 29.5
1 D 29.4
2 A 42.7
2 B 47.1
2 C 32.9
2 D 40.0
3 A 35.3
3 B 40.1
3 C 33.6
3 D 35.0
4 A 35.2
4 B 40.3
4 C 35.7
4 D 40.0
5 A 33.2
5 B 34.3
5 C 33.2
5 D 34.0
6 A 33.1
6 B 34.4
6 C 33.1
6 D 34.1
;

proc rank;
   by Block;
   var Yield;
   ranks Ryield;
run;

proc print;
   title2 'Original and Ranked Values of Yield';
run;

proc anova;
   class Block Trtment;
   model Ryield = Block Trtment;
   title2 'Friedman''s Two-way Nonparametric ANOVA';
run;
