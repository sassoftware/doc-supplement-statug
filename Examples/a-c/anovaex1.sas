/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ANOVAEX1                                            */
/*   TITLE: Example 1 for PROC ANOVA                            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: analysis of variance, balanced data, design         */
/*   PROCS: ANOVA                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC ANOVA, EXAMPLE 1.                              */
/*    MISC:                                                     */
/****************************************************************/


/* Randomized Complete Block With Factorial Treatment Structure */

/* Blocking Var: PainLevel, Treatment Fctrs: Codeine Acupuncture*/


title1 'Randomized Complete Block With Two Factors';
data PainRelief;
   input PainLevel Codeine Acupuncture Relief @@;
   datalines;
1 1 1 0.0  1 2 1 0.5  1 1 2 0.6  1 2 2 1.2
2 1 1 0.3  2 2 1 0.6  2 1 2 0.7  2 2 2 1.3
3 1 1 0.4  3 2 1 0.8  3 1 2 0.8  3 2 2 1.6
4 1 1 0.4  4 2 1 0.7  4 1 2 0.9  4 2 2 1.5
5 1 1 0.6  5 2 1 1.0  5 1 2 1.5  5 2 2 1.9
6 1 1 0.9  6 2 1 1.4  6 1 2 1.6  6 2 2 2.3
7 1 1 1.0  7 2 1 1.8  7 1 2 1.7  7 2 2 2.1
8 1 1 1.2  8 2 1 1.7  8 1 2 1.6  8 2 2 2.4
;


/* Bar Adds Factors Main Effect and Interaction to the Model ---*/


proc anova data=PainRelief;
   class PainLevel Codeine Acupuncture;
   model Relief = PainLevel Codeine|Acupuncture;
run;

