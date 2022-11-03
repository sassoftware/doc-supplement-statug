/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: tteex02                                             */
/*   TITLE: Documentation Example 2 for PROC TTEST              */
/*          (One-Sample Comparison with the FREQ Statement)     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: one-sample t test                                   */
/*          graphs                                              */
/*   PROCS: TTEST                                               */
/*    DATA: Children's reading skill data from                  */
/*          Moore, David S. (1995), The Basic Practice of       */
/*          Statistics}, New York: W. H. Freeman, p. 337.       */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/
data read;
   input score count @@;
   datalines;
40 2   47 2   52 2   26 1   19 2
25 2   35 4   39 1   26 1   48 1
14 2   22 1   42 1   34 2   33 2
18 1   15 1   29 1   41 2   44 1
51 1   43 1   27 2   46 2   28 1
49 1   31 1   28 1   54 1   45 1
;
ods graphics on;

proc ttest data=read h0=30;
   var score;
   freq count;
run;

ods graphics off;
