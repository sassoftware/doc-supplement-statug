/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: tteex04                                             */
/*   TITLE: Documentation Example 4 for PROC TTEST              */
/*          (AB/BA Crossover Design)                            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: graphs                                              */
/*   PROCS: TTEST                                               */
/*    DATA: Asthma data from                                    */
/*          Senn, S. (2002), Cross-over Trials in Clinical      */
/*          Research, Second Edition, New York: John Wiley \&   */
/*          Sons, Chapter 3.                                    */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/
data asthma;
   input Drug1 $ Drug2 $ PEF1 PEF2 @@;
   datalines;
for sal 310 270   for sal 310 260  for sal 370 300
for sal 410 390   for sal 250 210  for sal 380 350
for sal 330 365
sal for 370 385   sal for 310 400  sal for 380 410
sal for 290 320   sal for 260 340  sal for 90  220
;
proc print data=asthma;
run;
ods graphics on;

proc ttest data=asthma plots=interval;
   var PEF1 PEF2 / crossover= (Drug1 Drug2);
run;

ods graphics off;
