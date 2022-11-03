/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: GLMEX3                                              */
/*   TITLE: Example 3 for PROC GLM                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Unbalanced ANOVA, two-way interaction, Tukey's test */
/*   PROCS: GLM                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC GLM, EXAMPLE 3.                                */
/*    MISC:                                                     */
/****************************************************************/

/* Unbalanced ANOVA for Two-Way Design with Interaction --------*/

/* Note: Kutner's 24 for drug 2, disease 1 changed to 34. ------*/
title 'Unbalanced Two-Way Analysis of Variance';
data a;
   input drug disease @;
   do i=1 to 6;
      input y @;
      output;
   end;
   datalines;
1 1 42 44 36 13 19 22
1 2 33  . 26  . 33 21
1 3 31 -3  . 25 25 24
2 1 28  . 23 34 42 13
2 2  . 34 33 31  . 36
2 3  3 26 28 32  4 16
3 1  .  .  1 29  . 19
3 2  . 11  9  7  1 -6
3 3 21  1  .  9  3  .
4 1 24  .  9 22 -2 15
4 2 27 12 12 -5 16 15
4 3 22  7 25  5 12  .
;
proc glm;
   class drug disease;
   model y=drug disease drug*disease / ss1 ss2 ss3 ss4;
run;
proc glm;
   class drug disease;
   model y=drug disease drug*disease / ss1 ss2 ss3 ss4;
   lsmeans drug / pdiff=all adjust=tukey;
run;
/* Reproduce the Analysis with ODS Graphics Enabled ------------*/
ods graphics on;
proc glm plot=meanplot(cl);
   class drug disease;
   model y=drug disease drug*disease;
   lsmeans drug / pdiff=all adjust=tukey;
run;
ods graphics off;
