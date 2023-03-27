/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ANOVAIN1                                            */
/*   TITLE: Getting Started Example for PROC ANOVA              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: analysis of variance, balanced data, design         */
/*   PROCS: ANOVA                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC ANOVA, INTRODUCTORY EXAMPLE 1.                 */
/*    MISC:                                                     */
/****************************************************************/


/* One-Way Layout with Means Comparisons -----------------------*/

title1 'Nitrogen Content of Red Clover Plants';
data Clover;
   input Strain $ Nitrogen @@;
   datalines;
3DOK1  19.4 3DOK1  32.6 3DOK1  27.0 3DOK1  32.1 3DOK1  33.0
3DOK5  17.7 3DOK5  24.8 3DOK5  27.9 3DOK5  25.2 3DOK5  24.3
3DOK4  17.0 3DOK4  19.4 3DOK4   9.1 3DOK4  11.9 3DOK4  15.8
3DOK7  20.7 3DOK7  21.0 3DOK7  20.5 3DOK7  18.8 3DOK7  18.6
3DOK13 14.3 3DOK13 14.4 3DOK13 11.8 3DOK13 11.6 3DOK13 14.2
COMPOS 17.3 COMPOS 19.4 COMPOS 19.1 COMPOS 16.9 COMPOS 20.8
;


/* Analysis where Strain: Treatment Levels, Nitrogen: Response -*/


ods graphics on;

proc anova data = Clover;
   class Strain;
   model Nitrogen = Strain;
   means Strain / tukey;
run;

