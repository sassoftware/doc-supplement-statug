
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LIFEREX6                                            */
/*   TITLE: Example 6 for PROC LIFEREG                          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: survival data analysis, probability plotting        */
/*   PROCS: LIFEREG                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC LIFEREG, EXAMPLE 6.                            */
/*    MISC:                                                     */
/****************************************************************/


data Micro;
   input t1 t2 f;
   datalines;
. 6 6
6 12 2
12 24 0
24 48 2
24 .  1
48 168 1
48 .   839
168 500 1
168 .   150
500 1000 2
500 .    149
1000 2000 1
1000 . 147
2000 . 122
;

ods graphics on;
proc lifereg data=Micro;
   model ( t1 t2 ) = / d=lognormal intercept=25 scale=5;
   weight f;
   probplot
   pupper = 10
   itprintem
   printprobs
   maxitem = (1000,25)
   ppout;
   inset;
run;

