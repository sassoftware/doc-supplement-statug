/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ANOVAIN2                                            */
/*   TITLE: Getting Started Example 2 for PROC ANOVA            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: analysis of variance, balanced data, design         */
/*   PROCS: ANOVA                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC ANOVA, INTRODUCTORY EXAMPLE 2.                 */
/*    MISC:                                                     */
/****************************************************************/

/* Randomized Complete Block with One Factor -------------------*/

title1 'Randomized Complete Block';
data RCB;
   input Block Treatment $ Yield Worth @@;
   datalines;
1 A 32.6 112   1 B 36.4 130   1 C 29.5 106
2 A 42.7 139   2 B 47.1 143   2 C 32.9 112
3 A 35.3 124   3 B 40.1 134   3 C 33.6 116
;

/* Perform Analysis for Balanced Data RCB ----------------------*/

proc anova data=RCB;
   class Block Treatment;
   model Yield Worth=Block Treatment;
run;

/* Produce Treatment Means -------------------------------------*/

   means Treatment;
run;
