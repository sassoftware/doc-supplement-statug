/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: plmex3                                              */
/*   TITLE: Example 3 for PROC PLM                              */
/*    DESC: Cheese Data                                         */
/*     REF:                                                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: LOGISTIC,PLM                                        */
/*                                                              */
/****************************************************************/

data Cheese;
   do Additive = 1 to 4;
      do y = 1 to 9;
         input freq @@;
         output;
      end;
   end;
   label y='Taste Rating';
   datalines;
0  0  1  7  8  8 19  8 1
6  9 12 11  7  6  1  0 0
1  1  6  8 23  7  5  1 0
0  0  0  1  3  7 14 16 11
;

proc logistic data=cheese;
   freq freq;
   class additive y / param=glm;
   model y=additive;
   store sasuser.cheese;
   title 'Ordinal Model on Cheese Additives';
run;

ods graphics on;
proc plm restore=sasuser.cheese;
   lsmeans additive / cl diff oddsratio plot=diff;
run;
ods graphics off;
