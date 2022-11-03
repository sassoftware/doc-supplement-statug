/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: FREQEX7                                             */
/*   TITLE: Documentation Example 7 for PROC FREQ               */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: categorical data analysis,                          */
/*    KEYS: multiway frequency/crosstabulation tables,          */
/*    KEYS: Cochran-Mantel-Haenszel statistics,                 */
/*    KEYS: common relative risks, Breslow-Day test,            */
/*    KEYS: ODS Graphics, relative risk plot                    */
/*   PROCS: FREQ                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC FREQ, Example 7                                */
/*    MISC:                                                     */
/****************************************************************/
/* Cochran-Mantel-Haenszel Statistics --------------------------*/
data Migraine;
   input Gender $ Treatment $ Response $ Count @@;
   datalines;
female Active  Better 16   female Active  Same 11
female Placebo Better  5   female Placebo Same 20
male   Active  Better 12   male   Active  Same 16
male   Placebo Better  7   male   Placebo Same 19
;
ods graphics on;
proc freq data=Migraine;
   tables Gender*Treatment*Response /
          relrisk plots(only)=relriskplot(stats) cmh noprint;
   weight Count;
   title 'Clinical Trial for Treatment of Migraine Headaches';
run;
ods graphics off;
