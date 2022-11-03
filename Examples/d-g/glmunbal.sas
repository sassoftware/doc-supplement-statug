/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: GLMUNBAL                                            */
/*   TITLE: Getting Started Example 1 for PROC GLM              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Unbalanced ANOVA, two-way design                    */
/*   PROCS: GLM                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC GLM, INTRODUCTORY EXAMPLE 1.                   */
/*    MISC:                                                     */
/****************************************************************/

/* PROC GLM for Unbalanced ANOVA -------------------------------*/
title 'Analysis of Unbalanced 2-by-2 Factorial';
data exp;
   input A $ B $ Y @@;
   datalines;
A1 B1 12 A1 B1 14     A1 B2 11 A1 B2 9
A2 B1 20 A2 B1 18     A2 B2 17
;
proc glm data=exp;
   class A B;
   model Y=A B A*B;
run;
/* Produce Previous Analysis Results with an Interaction Plot --*/
ods graphics on;
proc glm data=exp;
   class A B;
   model Y=A B A*B;
run;
ods graphics off;
