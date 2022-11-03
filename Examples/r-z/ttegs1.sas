/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ttegs1                                              */
/*   TITLE: Getting Started Example 1 for PROC TTEST            */
/*          (One-Sample t Test)                                 */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: graphs                                              */
/*   PROCS: TTEST                                               */
/*    DATA: Court case length data from                         */
/*          Huntsberger, David V. and Billingsley, Patrick P.   */
/*          (1989), Elements of Statistical Inference, Dubuque, */
/*          IA:  Wm. C. Brown, p. 290.                          */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/
data time;
   input time @@;
   datalines;
 43  90  84  87  116   95  86   99   93  92
121  71  66  98   79  102  60  112  105  98
;
ods graphics on;

proc ttest h0=80 plots(showh0) sides=u alpha=0.1;
   var time;
run;

ods graphics off;
