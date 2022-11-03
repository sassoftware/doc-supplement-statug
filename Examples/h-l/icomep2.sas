/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ICOMEP2                                             */
/*   TITLE: Example 2 for EFFECTPLOT Statement                  */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS Graphics, Unbalanced ANOVA                      */
/*   PROCS: GENMOD                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, Shared Concepts Chapter      */
/*    MISC:                                                     */
/****************************************************************/

/* Unbalanced ANOVA for Two-Way Design with Interaction --------*/
/* Note: Kutner's 24 for drug 2, disease 1 changed to 34. ------*/

title 'Example 2: Unbalanced Two-Way Analysis of Variance';

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

ods graphics on;
proc genmod data=a;
   class drug disease;
   model y=disease drug disease*drug / d=n;
   effectplot / obs;
   effectplot interaction(sliceby=disease) / clm;
run;

proc genmod data=a;
   class drug disease;
   model y=drug disease drug*disease / d=n;
   effectplot box;
   effectplot interaction(x=drug*disease) / obs;
   effectplot mosaic;
   effectplot interaction(plotby=disease);
run;
ods graphics off;
